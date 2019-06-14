% Author: Pedro Paulo Ventura Tecchio
% Date:   June 13th, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This file is used to plot the network structue, i.e. node locations
% and their communication and ranging edges.

function showNetwork(node,network)
  % Unknown node locations over time
  if network.n == 3

    figure(1)
    hold on
    grid on
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title('Network graph')
    axis([0 network.boxSize+1 0 network.boxSize+1 0 network.boxSize+1]) 
    % plot boundaries ot the convexhull of anchor nodes
    vertices = network.coordAnchors';
    faces = nchoosek(1:network.a,network.n);
    patch('Vertices',vertices,'Faces',faces,'FaceColor','none',...
          'DisplayName','Anchor ConvexHull','LineWidth',1,'MarkerSize',8)
    % plot anchors and unknowns coordinates as circles.
    % check if it is anchor or unknown, anchor markers are filled.
    for i = 1:network.m
      if ismember(i,network.anchors)
        plot3(network.coordAll(1,i),...
              network.coordAll(2,i),...
              network.coordAll(3,i),...
              'o',...
              'MarkerEdgeColor',network.color(i,:),...
              'MarkerFaceColor',network.color(i,:))
      else
        plot3(network.coordAll(1,i),...
              network.coordAll(2,i),...
              network.coordAll(3,i),...
              'o','MarkerEdgeColor',network.color(i,:))
      end %if ismember

      % plot edges according to communication and ranging distances
      for j = 1:numel(node(i).neighbors)
        aux = [node(i).coord node(node(i).neighbors(j)).coord];
        plot3(aux(1,:),aux(2,:),aux(3,:),'--','color',network.color(i,:));
      end %for j

    end %for i

  elseif network.n == 2

    figure(1)
    hold on
    grid on
    xlabel('x')
    ylabel('y')
    title('Network graph')
    axis([0 network.boxSize+1 0 network.boxSize+1]) 
    % plot boundaries ot the convexhull of anchor nodes
    vertices = network.coordAnchors';
    faces = nchoosek(1:network.a,network.n);
    patch('Vertices',vertices,'Faces',faces,'FaceColor','none',...
          'DisplayName','Anchor ConvexHull','LineWidth',1,'MarkerSize',8)
    % plot anchors and unknowns coordinates as circles.
    % check if it is anchor or unknown, anchor markers are filled.
    for i = 1:network.m
      if ismember(i,network.anchors)
        plot(network.coordAll(1,i),...
             network.coordAll(2,i),...
             'o',...
             'MarkerEdgeColor',network.color(i,:),...
             'MarkerFaceColor',network.color(i,:))
      else
        plot(network.coordAll(1,i),...
             network.coordAll(2,i),...
             'o','MarkerEdgeColor',network.color(i,:))
      end %if ismember

      % plot edges according to communication and ranging distances
      for j = 1:numel(node(i).neighbors)
        aux = [node(i).coord node(node(i).neighbors(j)).coord];
        plot(aux(1,:),aux(2,:),'--','color',network.color(i,:));
      end %for j

    end %for i
  end %if network.n
end %function

