% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Modified on: June 13th, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: Initializes the network parameters, which are basically the true
% locations of each node, the anchor and unknown groups.

function [node,network] = initNetwork(node,network,listCoord,listAnchor)
  if nargin == 2
    % Define random anchor and unknown groups
    network.anchors  = sort(randperm(network.m,network.n+1));
    network.unknowns = setdiff([1:network.m],network.anchors);
    % Sets true random coordinates for nodes inside the n-dim cube of gieven
    % side size boxSize.
    for i = 1:network.m
      node(i).coord       = network.boxSize*rand(network.n,1);
    end
  elseif nargin == 4
    % Define random anchor and unknown groups
    network.anchors  = listAnchor;
    network.unknowns = setdiff([1:network.m],network.anchors);
    % Sets true random coordinates for nodes inside the n-dim cube of gieven
    % side size boxSize.
    for i = 1:network.m
      node(i).coord       = listCoord(i,:)';
    end
  end
  
  % These are used as global variables.
  network.coordAll      = [node.coord];
  network.coordAnchors  = network.coordAll(:,network.anchors);
  network.coordUnknowns = network.coordAll(:,network.unknowns);
%   i
end