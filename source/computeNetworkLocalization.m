% Author: Pedro Paulo Ventura Tecchio
% Date:   June 6th, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This function execute node localization with
% arbitrary anchor locations in n-dimensional Euclidean space. It was
% tested for both 2D and 3D spaces. Except for showPlots, it should work
% for other dimensions.

function output = computeNetworkLocalization(in)

%% Properties to set network
network.m = in.m;                  % Number of nodes 
network.n = in.n;                  % Number of dimensions
network.a = network.n + 1;         % Minimal number of anchors
network.u = network.m - network.a; % Maximum number of unknowns
network.T = in.T;                  % Number of steps to simulate
network.boxSize = in.boxSize;      % Network is randomly placed in a n-dim 
                                   % cube of this side length
network.r = in.r;                  % Radius of communication and range
network.varRangesProportion = in.varRangesProportion;  % Variance of range measurements

%% Node data structure
node = struct('coord'              , nan(network.n,1),...
              'rangeRadius'        , nan,...
              'trueRanges'         , nan(network.m,1),...
              'meanRanges'         , nan(network.m,network.T),...
              'neighbors'          , [],...
              'degree'             , nan,...
              'neighborGroups'     , [],...
              'coordAnchors'       , nan(network.n,network.a),...
              'coordUnknowns'      , nan(network.n,network.u),...
              'validNeighborGroups', [],...
              'lambdaMatrix'       , [],...
              'meanLambdaMatrix'   , [],...
              'tempCounterFlag'    , 0,...
              'generalizedLambda'  , nan(network.m,network.T),...
              'Xut'                , zeros(network.u,network.n,network.T),...
              'eXut'               , nan(network.T,1),...
              'gradt'              , nan(network.u,network.n,network.T));

output.Xut  = nan(network.u,network.n,network.T,network.m);
output.eXut = nan(network.T,network.m);
output.Xu   = nan(network.u,network.n);
            
%% Init network
[node,network] = initNetwork(node,network);

%% Init node
[node,network] = initNodes(node,network);

%% Set noisy range measurements from neighbors
node = computeRangeStep(node,network);

%% Compute all possible barycentric coordinates
node = computeBaryCoordStep(node,network);

%% Compute all unknown node locations in all nodes
node = computeLocationFirstStep(node,network);
node = computeLocationStep(node,network);

%% Format output
for i = 1:network.m
  output.Xut(:,:,:,i) = node(i).Xut;
  output.eXut(:,i) = node(i).eXut;
  
end
output.Xu = network.coordUnknowns';
