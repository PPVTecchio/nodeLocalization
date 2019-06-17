% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This function is used to computed both the generalized barycentric
% coordinates and our LambdaMatrices which contain all possible barycentric
% coordinates for each neighboring group.

function node = computeBaryCoordStep(node,network)
  % This can be seen as an exchange of noisy range data at time step t.
  % Each node forms a matrix contained the range measurements of other
  % nodes. SUBOPTIMAL IMPLEMENTATION AS WE COULD ONLY GET FROM NEIGHBORING
  % NODES.
for t = 1:network.T  
  rangeMatrixTemp = nan(network.m);
  for i = 1:network.m
    rangeMatrixTemp(i,:) = node(i).meanRanges(:,t); 
  end
  
  % This loop all nodes in the network
  for i = 1:network.m
    % Start some temp variables
    tempLambdaMatrix = nan(network.m,node(i).nNeighborGroups);
    tempCounter = 0;
    % This computes all possible barycentric coordinates for each possible
    % neighbor combination. THIS CAN TAKE QUITE SOME TIME.
    for l = 1:node(i).nNeighborGroups
      % Creates temporary matrix with all ranges for subset of neighbors
      M = zeros(network.n+1);
      neighbors = node(i).neighborGroups(l,:);
      for j = 1:network.n+1
        for k = 1:network.n+1
          M(j,k) = rangeMatrixTemp(neighbors(j),neighbors(k));
        end
      end
      % Test if matrix is valid, there are no missing ranges
      if nnz(isnan(M(:,:)))      
        continue
      end
      % Call function to compute barycoord
      [bary,~,~] = baryCoord([M node(i).meanRanges(neighbors,t)]);
      % Test if results are valid (there are no nan flags).
      if nnz(isnan(bary))
        continue
      end

      % This is the matrix L from text, our LambdaMatrix
      tempCounter = tempCounter + 1;
      tempLambdaMatrix(:,tempCounter) = 0;
      tempLambdaMatrix(neighbors,tempCounter) = bary;
      
    end %l
    
    if tempCounter > 0
        
        tempLambdaMatrix = tempLambdaMatrix(:,1:tempCounter);

        %Generalized lambda method
        node(i).generalizedLambda(:,t) = sum(tempLambdaMatrix,2)/tempCounter;

        % Capital L method
        temp = zeros(network.m,1);
        temp(i) = 1;
        tempLambdaMatrix = tempLambdaMatrix - repmat(temp,1,tempCounter);
        squareLambdaMatrix = tempLambdaMatrix*tempLambdaMatrix';
    else
        node(i).generalizedLambda(:,t) = node(i).generalizedLambda(:,t-1);
        squareLambdaMatrix = node(i).meanSquareLambdaMatrix(:,:,t-1);
        node(i).tempCounterFlag = node(i).tempCounterFlag + 1;
    end
    
    % Performs averaging process over LambdaMatrix
    if t == 1
      node(i).meanSquareLambdaMatrix(:,:,t) = squareLambdaMatrix;
    else
      node(i).meanSquareLambdaMatrix(:,:,t) = ...
        ((t-1) * node(i).meanSquareLambdaMatrix(:,:,t-1) + ...
        squareLambdaMatrix) / t;
    end
     
%     [t i]
  end %i
end %t
end