% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: At every time step iteration, after the first one, computes the
% unknown node locations at every node based on Shahin Shahrampour mirror 
% descent code, which become a descentralized gradient descent algorithm.
% We tested and proposed a few different ways to compute step sizes. 
% We coded a subfunction with all tested ones, but this code slows downs 
% quite a bit while testing switch cases every step size.

% Math deduction of equations
%(L X)'(L X) = 0 -> X' L' L X = 0
% |Xa' Xu'| |LLaa LLau| |Xa| = 0
%           |LLua LLuu| |Xu| 
% [Xa' LLaa + Xu' LLua; Xa' LLau + Xu' LLuu] * [Xa;Xu] = 0
% Xa' LLaa Xa + Xu' LLua Xa + Xa' LLau Xu + Xu' LLuu Xu = 0
% tr(Xa' LLaa Xa + Xu' LLua Xa + Xa' LLau Xu + Xu' LLuu Xu) = tr(0)
% f(Xu) = tr(Xu' LLuu Xu + Xa' (LLau + LLua') Xu + Xa' LLaa Xa)
% grad  = (LLuu + LLuu') Xu + 2 LLua Xa; LLau = LLua'

function node = computeLocationStep(node,network)
for t = 2:network.T
  for i = 1:network.m
    Laa = node(i).meanSquareLambdaMatrix(network.anchors ,network.anchors ,t);
    Lau = node(i).meanSquareLambdaMatrix(network.anchors ,network.unknowns,t);
    Lua = node(i).meanSquareLambdaMatrix(network.unknowns,network.anchors ,t);
    Luu = node(i).meanSquareLambdaMatrix(network.unknowns,network.unknowns,t);

%     At =  [Lau; Luu];
%     Bt =  [Laa; Lua];

    % Compute gradient based on previous equations
    node(i).gradt(:,:,t) = 2 * Luu' * node(i).Xut(:,:,t-1) + ...
                          (Lua + Lau') * network.coordAnchors';
    % Compute averaged result among all neighbors, using weight matrix W
    for j = 1:network.m
      node(i).Xut(:,:,t) = node(i).Xut(:,:,t) + ...
                           network.W(i,j) * node(j).Xut(:,:,t-1);
    end

      % swtich case is TOO SLOW!!!!!!!!!
%       update = computeUpdate('fixed',node(i).gradt(:,:,t),1e-4);
%       update = computeUpdate('normalized',node(i).gradt(:,:,t),1e-3);
%       update = computeUpdate('eigen',node(i).gradt(:,:,t),Luu);
%       update = computeUpdate('ya-xiang',node(i).gradt(:,:,t),Luu,Lau'+Lua);
%       update = computeUpdate('optimal',node(i).gradt(:,:,t),0.99,Luu'+Luu);
%       update = computeUpdate('optimal',node(i).gradt(:,:,t),0.99,...
%                (Luu'+Luu)^4,(Luu'+Luu)^2);
    % For now, we are using fixed step sizes
    etas = 1e-3;
    update = etas * node(i).gradt(:,:,t);
    % Update unknown node estimates
    node(i).Xut(:,:,t) = node(i).Xut(:,:,t) - update;
    
    node(i).eXut(t) = norm(node(i).Xut(:,:,t) - network.coordUnknowns');
%     [t i]
  end %m
end %t
end %function

% function update = computeUpdate(type,gradt,param1,param2,param3)
%   switch type
%     case 'fixed'
%       etas = param1;
%       update = etas * gradt;
%     case 'normalized'
%       etas = param1/norm(gradt);
%       update = etas * gradt;
%     case 'eigen'
%       % param1 = Luu
%       eigLuu = eig(param1);
%       etas = param2/(max(eigLuu) + min(eigLuu));
%       update = etas * gradt;
%     case 'ya-xiang'  
%       % Step-Sizes for the gradient method; Ya-xiang Yuan
%       % param1 = Luu
%       % param2 = Lau'+Lua
%       gti = reshape(gradt,[],1);
%       Hti = kron(eye(n),param1);
%       etas = (gti'*gti)/(gti'*Hti^2*gti);
%       update = etas*gradt;
%     case 'optimal'
%       % param1 = 0.9x
%       % param2 = Luu'+Luu
%       etas = (gradt'*param2*gradt)\(gradt'*gradt);
%       update = gradt*param1*etas;
%     case 'mod_optimal'
%       % param1 = 0.9x
%       % param2 = (Luu'+Luu)^4
%       % param3 = (Luu'+Luu)^2
%       etas = (gradt'*param2*gradt)\(gradt'*param3*gradt);
%       update = gradt*param1*etas;
%   end 
% end
