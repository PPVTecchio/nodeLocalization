% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This function is used to compute all noisy and averaged range
% measurements between neighbors. It is slightly different from the one in
% the folder stepByStep, as this one computes all in one go, while the
% other computes each subset of range measurements at every time step.

function node = computeRangeStep(node,network)
  % For each node
  for i = 1:network.m
    % Substracts the node itself from its neighbors list
    neighbors     = setdiff(node(i).neighbors,i);
    % Get the true ranges to compute proportional variances
    trueRanges    = node(i).trueRanges(neighbors);
    varRanges     = diag(trueRanges) / network.varRangesProportion;
    cholVarRanges = chol(varRanges,'lower'); 
    % Compute noisy ranges by inserting gaussian noise with propotional var
    noisyRanges   = repmat(trueRanges,1,network.T) + ...
                    cholVarRanges*randn(length(neighbors),network.T);
    % Computes averaged noisy measurements over time              
    meanRanges    = cumsum(noisyRanges,2);
    meanRanges    = meanRanges ./ [1:network.T];
    % Save computed averaged noisy ranges                  
    node(i).meanRanges(neighbors,:) = meanRanges;
    node(i).meanRanges(i,:) = 0;
%     i
  end
end