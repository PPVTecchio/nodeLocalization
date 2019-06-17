% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This function computes the barycentric coordinates from a subset
% of range measurements via our bideterminant method.

function [barycenters,bideterminants,determinant] = baryCoord(dist)
    minContent = 1; % minimum volume to be consider
    eamax = 2;      % maximum volume error generated from noises to be 
                    % accepted
    % Get distances
    EDM = dist.^2;  % Euclidean distance matrix
    s = size(EDM,2)-1;
    
    Mb = [0 ones(1,s);ones(s,1) EDM(1:s,1:s)];
    vb = [1; EDM(1:s,s+1)];
    
    determinant = det(Mb);
    % Tests if volume satisfies some constraints from theory  
    if (abs(determinant) < minContent)     || ...
       (sign(determinant) ==  1 && s == 3) || ...
       (sign(determinant) == -1 && s == 4)
        barycenters = nan(1,s);
        bideterminants = nan(1,s);
        return
    end
    
    sdet = sign(determinant);
    adet = sqrt(determinant * sdet);
    
    bideterminants = nan(1,s);
    
    for j = 1:s
        M_ = Mb;
        M_(:,j+1) = vb;
        bideterminants(j) = det(M_);
    end
       
    sbidet = sign(bideterminants);
    abidet = (bideterminants .* sbidet) / adet;
    % Computes if sum of signed volumes makes sense and there is not much
    % influence from noise.
    ea = (sum(abidet) - adet)/adet;
    
    if abs(ea) > eamax
      barycenters = nan(1,s);
      bideterminants  = nan(1,s);
      return
    end
    
    barycenters = bideterminants ./ determinant;
end
