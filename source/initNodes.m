% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: Initializes all nodes by computing its true neighbors ranges which
% is used to define neighbors via the radius parameter. Node degree and
% possible neighbor groups are also computed from neighboring groups. Other
% variables are initialized to be used later on.

function [node,network] = initNodes(node,network)
  % For each node
  for i = 1:network.m
    node(i).rangeRadius = network.r; % Define comm and range radius
    node(i).tempCounterFlag = 0;     % Flag used for computing barycoord
    % Compute true ranges and init mean ranges variable
    thisCoord           = repmat(node(i).coord,1,network.m);
    othersCoord         = network.coordAll;
    node(i).trueRanges  = sqrt(sum((thisCoord - othersCoord).^2,1))';
    node(i).meanRanges  = nan(network.m,network.T);
    % Compute neighbors from true ranges and range radius
    neighbors  = (node(i).trueRanges < node(i).rangeRadius);
    node(i).neighbors  = find(neighbors);                       
    node(i).degree     = length(node(i).neighbors); % Node degree
    % Compute neighboring groups from combination without replacement
    % THIS CAN BE REALLY SLOW!!!
    node(i).neighborGroups = nchoosek(setdiff(node(i).neighbors,i),...
                                      network.n + 1);
    % Init all necessary future variables 
    node(i).nNeighborGroups = size(node(i).neighborGroups,1);
    node(i).meanSquareLambdaMatrix = nan(network.m,network.m,network.T);
    node(i).generalizedLambda = nan(network.m,network.T);
    node(i).Xut   = zeros(network.u,network.n,network.T);
    node(i).eXut  = nan(network.T,1);
    node(i).gradt = nan(network.u,network.n,network.T);
    %node(i).etas  = zeros(network.n,network.n,network.T,network.m);

%     i
  end
  % Computes weight comm matrix
  Adj = zeros(network.m);
  for i = 1:network.m
    Adj(i,node(i).neighbors) = 1;
  end
  Lap = diag(sum(Adj,2)) - Adj;
  network.W = eye(size(Lap)) - 1/max(eig(Lap))*Lap;

end