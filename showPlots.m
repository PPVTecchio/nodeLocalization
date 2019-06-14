% Author: Pedro Paulo Ventura Tecchio
% Date:   May 3rd, 2019
% Company: University of Pennsylvania / Electrical and Systems Engineering
% About: This file is used to plot the unknown node locations over time and 
% the norm of the error (difference from computed location and ground
% truth). 

function showPlots(node,network,wichNodeToPlot)
    % Norm of error
    figure(10)
    hold on
    grid on
    xlabel('Iteration t')
    ylabel('Difference norm')
    title('Difference between current and true location')
    for i = 1:network.m
      plot(node(i).eXut,'Color',network.color(i,:),'LineWidth',2)
    end
    
    % Unknown node locations over time
    if network.n == 3

      for k = 1:numel(wichNodeToPlot)
        j = wichNodeToPlot(k);
        Yut = permute(node(j).Xut, [3 1 2]);
        figure(100+j)
        hold on
        grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        title(sprintf('Location over time at node %d',j))
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
        end %for i
        % plot trajectories from initial guess (squares), to final solution
        % (asterisc)
        for i = 1:network.u
          plot3(Yut(:,i,1),...
                Yut(:,i,2),...
                Yut(:,i,3),...
                '-',...
                'Color',network.color(network.unknowns(i),:))
          plot3(Yut(end,i,1),...
                Yut(end,i,2),...
                Yut(end,i,3),...
                '*',...
                'Color',network.color(network.unknowns(i),:))
          plot3(Yut(1,i,1),...
                Yut(1,i,2),...
                Yut(1,i,3),...
                's',...
                'Color',network.color(network.unknowns(i),:))
        end %for i
      end %for k
    
    elseif network.n == 2
      
      for k = 1:numel(wichNodeToPlot)
        j = wichNodeToPlot(k);
        Yut = permute(node(j).Xut, [3 1 2]);
        figure(100+j)
        hold on
        grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        title(sprintf('Location over time at node %d',j))
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
        end %for i
        % plot trajectories from initial guess (squares), to final solution
        % (asterisc)
        for i = 1:network.u
          plot(Yut(:,i,1),...
               Yut(:,i,2),...
               '-',...
               'Color',network.color(network.unknowns(i),:))
          plot(Yut(end,i,1),...
               Yut(end,i,2),...
               '*',...
               'Color',network.color(network.unknowns(i),:))
          plot(Yut(1,i,1),...
               Yut(1,i,2),...
               's',...
               'Color',network.color(network.unknowns(i),:))
        end %for i
      end %for k
    end %if network.n
end %function

