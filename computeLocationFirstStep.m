% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: For the first time step, computes the unknown node locations 
% at every node based on linear system solution and boxed constraints.

% Math deduction of equations
%(L X)'(L X) = 0 -> X' L' L X = 0
% |Xa' Xu'| |LLaa LLau| |Xa| = 0
%           |LLua LLuu| |Xu| 
% [Xa' LLaa + Xu' LLua; Xa' LLau + Xu' LLuu] * [Xa;Xu] = 0
% Xa' LLaa Xa + Xu' LLua Xa + Xa' LLau Xu + Xu' LLuu Xu = 0
% f(Xu) = Xu' LLuu Xu + Xa' (LLau + LLua') Xu + Xa' LLaa Xa
% grad  = Xu' LLuu + Xa' (LLau + LLua') + LLuu' Xu
% hess  = 2 LLuu
function node = computeLocationFirstStep(node,network)

  for i = 1:network.m
    Laa = node(i).meanSquareLambdaMatrix(network.anchors ,network.anchors ,1);
    Lau = node(i).meanSquareLambdaMatrix(network.anchors ,network.unknowns,1);
    Lua = node(i).meanSquareLambdaMatrix(network.unknowns,network.anchors ,1);
    Luu = node(i).meanSquareLambdaMatrix(network.unknowns,network.unknowns,1);

    At =  [Lau; Luu];
    Bt =  [Laa; Lua];

      node(i).Xut(:,:,1) = -At\(Bt*network.coordAnchors');
      % Box constraints, if outside the possible n-dim cube, then put
      % exactly in the midle of it
      [row,col] = find(node(i).Xut(:,:,1) > 1);
      node(i).Xut(row,col,1) = network.boxSize/2;
      [row,col] = find(node(i).Xut(:,:,1) < 0);
      node(i).Xut(row,col,1) = network.boxSize/2;
      % Compute gradient because we need later on sometimes to compute
      % stepsizes.
      node(i).gradt(:,:,1) = 2 * Luu' * node(i).Xut(:,:,1) + ...
                            (Lua + Lau') * network.coordAnchors';
      node(i).eXut(1) = norm(node(i).Xut(:,:,1) - network.coordUnknowns');
  end %m
  
end %function
