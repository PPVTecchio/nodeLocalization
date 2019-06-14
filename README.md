# nodeLocalization
This project seeks to localize nodes in a Wireless Network using only range measurements and a small subset of reference locations.
* Reference nodes are called Anchors and have known locations.
* We call non-anchor nodes, Unknowns.
* Nodes lie in **n-dimensional Euclidean space**. While we usually have n = 2 or n = 3 in current applications; our implementation, with exception of plot functions, is able to deal with any possible number of dimensions.
* We utilize the minimum number of anchors, which is n + 1.
* **Anchors and Unknows may lie arbitrarily**, i.e. there is no assumption on how the anchors are placed in the network.

## Requirements for utilization
* A running Matlab environment. Tested with Matlab R2018b - academic use.
* The Parallel Computing Toolbox is called when doing RMSE simulation via batch processing. But, it is not required to run the standard single network case.

## How to use

### Single network simulation
In order to run a simulation on a single network, one needs to set the following parameters on **main.m** file.
````matlab
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
````

If one desires to specify a network, it can be done by inputing its nodes coordinates to *setNetworkCoordinates* and choosing anchor node labels in *setNetworkAnchors* as follows:
````matlab
%% Choosing a specific network (if desired)
setNetworkCoordinates = [1 5 1;2 5 9;5 3 6;8 2 9;3 7 9;
                         5 7 4;9 2 4;8 1 5;7 6 3;8 3 1;
                         9 2 6;3 8 5;7 7 2;1 4 2];
setNetworkAnchors = [1;4;6;12];
````

The following code will run the specified network, if one desires to run a completly random network just uncomment and comment the specific lines calling **initNetwork()** with 2 or 4 arguments.
````matlab
%% Init network
% Completely random network
% [node,network] = initNetwork(node,network);
% Specific network
[node,network] = initNetwork(node,network,setNetworkCoordinates,...
                             setNetworkAnchors);
````

Another important parameter for the convergence of the method must be set on **computeLocationStep.m**, it is the value of the stepsize utilized on the distributed gradient method. We utilize a fixed small value as a standard, but we show other possibilities on the commented section of this file.
````matlab
% For now, we are using fixed step sizes
    etas = 1e-3;
````

The result of running the specified network with the parameters given before is shown in the following plots, which are generated automatically by the functions **showNetwork()** and **showPlots()**:

![Example network specified in the file.](/network_14nodes_example_case_5e4iterations.png)
![Difference norm between ground truth and estimation over iterations.](/difference_14nodes_example_case_5e4iterations.png)
![Trajectories of the estimated values at node 1.](/trajectories_14nodes_example_case_5e4iterations.png)

We utilized a structure to contain all variables and estimated values for each node in the network as follows:
````matlab
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
````
If one wishes to see:
* Neighbors of node i, one can call
````matlab
node(i).neighbors
````
* All possible combinations of neighbors of node i that are utilized
````matlab
node(i).neighborGroups
````
* All barycentric coordinates of node i are stored sequentially on *lambdaMatrix* following the order given by *neighborGroups*. Pay attention that we store all barycentric coordinates for all iterations.
````matlab
node(i).lambdaMatrix
````

### Batch simulation for RMSE evaluation

In order to run a batch simulation to evaluate RMSE for different random networks one may call **main_batch.m** with the following parameters specified inside the file.

````matlab
rng(69)    % Random generator seed number. Changes networks without 
           % changing its parameters bellow.

%% Properties to set network
in.m = 14;                    % Number of nodes 
in.n = 3;                     % Number of dimensions
in.T = 1e4;                   % Number of steps to simulate
in.boxSize = 10;              % Network is randomly placed in a n-dim 
                                   % cube of this side length
in.r = 10;                    % Radius of communication and range
in.varRangesProportion = 10;  % Variance of range measurements
````
````matlab
%% Number of random networks to simulate
nNetworkSamples = 20; 
````
The output of this function is a plot with all RMSE values over iterations with different colors for each network. An example of running 28 networks is given below:

![RMSE simulation of 28 random networks](/first_RMSE_simulated_run_with_28_random_networks_and_same_parameters.png)

## Credits
This implementation was coded by myself, Pedro Paulo Ventura Tecchio, while pursuing a Ph.D. degree at University of Pennsylvania. Related paper:

```latex
@inproceedings{tecchio2019NodeLocalization,
  author={Tecchio, Pedro Paulo Ventura and Atanasov, Nikolay and Shahrampour, Shahin and Pappas, George J.},
  booktitle={2019 American Control Conference (ACC2019)},
  title={N-Dimensional Distributed Network Localization With Noisy Range Measurements and Arbitrary Anchor Placement},
  year={2019}
}
```

## License
This project is distributed under GNU GPLv3 license.

