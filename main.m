% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This is the main file needed to execute node localization with
% arbitrary anchor locations in n-dimensional Euclidean space. It was
% tested for both 2D and 3D spaces. Except for showPlots, it should work
% for other dimensions.

close all  % I like to close and clean everything before starting.
clear all
clc

%% Properties to set network
rng(69)    % Random generator seed number. Changes networks without 
           % changing its parameters bellow.

network.m = 14;                    % Number of nodes 
network.n = 3;                     % Number of dimensions
network.a = network.n + 1;         % Minimal number of anchors
network.u = network.m - network.a; % Maximum number of unknowns
network.T = 5e4;                   % Number of steps to simulate
network.boxSize = 10;              % Network is randomly placed in a n-dim 
                                   % cube of this side length
network.r = 9;                     % Radius of communication and range
network.varRangesProportion = 10;  % Variance of range measurements

%% Choosing a specific network (if desired)
setNetworkCoordinates = [1 5 1;2 5 9;5 3 6;8 2 9;3 7 9;
                         5 7 4;9 2 4;8 1 5;7 6 3;8 3 1;
                         9 2 6;3 8 5;7 7 2;1 4 2];
setNetworkAnchors = [1;4;6;12];
                          

%% Properties to show plots
network.color = rand(network.m,3);

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

%% Init network
% Completely random network
% [node,network] = initNetwork(node,network);
% Specific network
[node,network] = initNetwork(node,network,setNetworkCoordinates,...
                             setNetworkAnchors);

%% Init node
[node,network] = initNodes(node,network);

%% Set noisy range measurements from neighbors
node = computeRangeStep(node,network);

%% Show network graph
showNetwork(node,network)

%% Compute all possible barycentric coordinates
node = computeBaryCoordStep(node,network);

%% Compute all unknown node locations in all nodes
node = computeLocationFirstStep(node,network);
node = computeLocationStep(node,network);

%% Show unknown node locations over time and norm of its error
showPlots(node,network,1)
