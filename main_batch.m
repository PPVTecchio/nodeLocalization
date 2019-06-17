% Author: Pedro Paulo Ventura Tecchio
% Date:   June 6th, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This is the main file needed to execute batch node localization.

close all  % I like to close and clean everything before starting.
clear all
clc

addpath('./source/')

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

%% Number of random networks to simulate
nNetworkSamples = 20;   


%% Output data structure
in.u = in.m - (in.n + 1);
output = struct('Xut'                , nan(in.u,in.n,in.T),...
                'eXut'               , nan(in.T,1),...
                'Xu'                 , nan(in.u,in.n));

%% Simulates networks in the background
% according to parallel machine specifications of the host

for idx = 1:nNetworkSamples
  f(idx) = parfeval(@computeNetworkLocalization,1,in);
end

for idx = 1:nNetworkSamples
  % fetchNext blocks until next results are available.
  [completedIdx,value] = fetchNext(f);
  output(completedIdx) = value;
  fprintf('Got result with index: %d.\n', completedIdx);
end

%% Computes and plots the RMSE of each simulated network
rmse = nan(in.T,in.m,nNetworkSamples);

for idx = 1:nNetworkSamples
  difference = output(idx).Xut - output(idx).Xu;
  differencesq = difference.^2;
  sumdifferencesq = sum(sum(differencesq,2),1);
  rmse(:,:,idx) = sqrt(sumdifferencesq/in.T);
  plot(rmse(:,:,idx),'Color',rand(1,3))
  hold on
end

title('RMSE for each simulated network')
xlabel('Iterations')
ylabel('RMSE')


