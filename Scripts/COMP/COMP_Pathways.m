%% Pathways

% Define the 5 sections and 11 boxes used to identify pathways

% Here is the tool used to define the section
% Draw detailed map of subregion
% color=lines(3)
% m_proj('lambert','long',[-60 -40],'lat',[46 53]);
% figure
% hold on
% [CS,CH]=m_contourf(lonT,latT,topoT,[-6000 -3500 -2500 -1500 -1000 0],'edgecolor','none');
% m_contour(lonT,latT,topoT,[-3500 -3000 -2500 -2000 -1500 -1000 -500 -250 -100 0],'edgecolor',[.7 .7 .7]);
% m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
% m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',brighten(color(2,:),0.5),'linewidth',2);
% colormap(m_colmap('blues',10))
% c=colorbar('location','southoutside','FontSize',15);
% c.Label.String='Depth (km)';
% caxis([-4000 0])
% m_plot(squeeze(trap_boxes(1,:,:)),squeeze(trap_boxes(2,:,:)))
% m_grid('xtick',-80:1:20,'ytick',40:1:85,'tickdir','in','yaxislocation','left','fontsize',15)
% 
% % Make circle at shelfbreak where applicable 
% [xc,yc]=ginput(1);
% [xc,yc]=m_xy2ll(xc,yc);
% m_plot(xc,yc,'.y')
% m_range_ring(xc,yc,100,'color','y')
% 
% % Draw boxes
% x=[];
% y=[];
% for i=1:4
% [xt,yt]=ginput(1);
% plot(xt,yt,'.b')
% x=[x xt];
% y=[y yt];
% plot(x,y,'b')
% end
% x=[x x(1)];
% y=[y y(1)];
% plot(x,y,'r')
% [xl,yl]=m_xy2ll(x,y);
% clear x y

trap_DS=[  -62.2 -56.6 -56.4 -62 -62.2;
    66.5 67.2 67 66.3 66.5];
trap_WGC=[ -50.3 -53.1 -52.8 -50 -50.3; 
     63 62 61.8 62.8 63];

trap_NLsh_sh=[ -64.5  -62  -62  -64.5  -64.5;
   60.5 61.7 61.3 60.1 60.5];
trap_NLsh_sl=[  -62 -58.8 -58.8 -62 -62;
    61.7 61.3 60.9 61.3 61.7];

trap_MLsh_sh=[ -60.5  -58.4  -58.2  -60.3  -60.5;
   55.6   56.3   56.1   55.4   55.6];
trap_MLsh_sl=[ -58.4  -56.3  -56.1  -58.2  -58.4;
   56.3 56.9 56.7 56.1 56.3];

trap_SLsh_sh=[ -55.9  -56.1  -53  -52.8  -55.9;
   52 52.3 52.9 52.6 52];
trap_SLsh_sl=[-53 -50.3 -50.1 -52.8 -53;
   52.9 53.3 53 52.6 52.9];

trap_NL_sh=[  -59.5  -59.4  -48.6  -48.6  -59.5
   50.7 50.9 47.1 46.8 50.7];
trap_NL_fp=[-48.6 -48.6 -45.6 -45.4 -48.6;
    46.8 47.1 47.5 47.2 46.8];
trap_NL_fc=[-45.4 -44.1 -44.4 -45.6 -45.4;
    47.2 49.3 49.5 47.5 47.2];

trap_boxes=cat(3,trap_WGC,trap_DS,trap_NLsh_sl,trap_NLsh_sh,trap_MLsh_sl,trap_MLsh_sh,trap_SLsh_sl,trap_SLsh_sh,trap_NL_fc,trap_NL_fp,trap_NL_sh);
trap_boxes_names=["trap_WGC","trap_DS","trap_NLsh_sl","trap_NLsh_sh","trap_MLsh_sl","trap_MLsh_sh","trap_SLsh_sl","trap_SLsh_sh","trap_NL_fc","trap_NL_fp","trap_NL_sh"];

% Indicate which box corresponds to which section
trap_section=[1 1 2 2 3 3 4 4 5 5 5];


% Identify Which drifters goes through the boxes, when they enter and leave

trapped_enter=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_time_enter=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_leave=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_time_leave=zeros(size(trap_boxes,3),size(drift_lon,2));

for i=1:size(trap_boxes,3)
    trapped_enter(i,:)=sum(inpolygon(drift_lon,drift_lat,trap_boxes(1,:,i),trap_boxes(2,:,i)))>0;
    trapped_leave(i,:)=sum(inpolygon(drift_lon,drift_lat,trap_boxes(1,:,i),trap_boxes(2,:,i)))>0;
    for j=1:size(drift_lon,2)
        if trapped_enter(i,j)>0
          trapped_time_enter(i,j)=find(inpolygon(drift_lon(:,j),drift_lat(:,j),trap_boxes(1,:,i),trap_boxes(2,:,i)),1,'first');
          trapped_time_leave(i,j)=find(inpolygon(drift_lon(:,j),drift_lat(:,j),trap_boxes(1,:,i),trap_boxes(2,:,i)),1,'last');
        end
    end
end


% If more than one box of the section was crossed, need to check crossing
% times to define which boxes the drifters entered and left the section
% from. We also need to pay extra attention that if the drifter circulated
% several times over the shelf, only one of these is taken into account
for i=1:max(trap_section)
    nb_box=find(trap_section==i); % which boxes belong to this section
        for k=1:size(drift_lon,2) % go through all the drifters, for both when they entered and left boxes
            if sum(trapped_enter(nb_box,k))>1 && i~=1
                nb_box_trapped=nb_box(trapped_enter(nb_box,k)>0); % which boxes were crossed?
                % Choose the box that was entered first, while making sure
                % the drifter comes from upstream (except if we're dealing
                % with origin boxes)
                time_previous_serie=max(trapped_time_enter(1:min(nb_box)-1,k));
                if time_previous_serie~=0 
                    [~,idmin]=min(trapped_time_enter(nb_box_trapped(trapped_time_enter(nb_box_trapped,k)>time_previous_serie),k));
                else
                    [~,idmin]=min(trapped_time_enter(nb_box_trapped,k));
                end
                trapped_enter(nb_box_trapped,k)=0;
                trapped_enter(nb_box_trapped(idmin),k)=1;
            end
            if sum(trapped_leave(nb_box,k))>1 && i~=5 % If more than one box of the section was crossed, need to check crossing times
                nb_box_trapped=nb_box(trapped_leave(nb_box,k)>0);
                time_next_serie=trapped_time_leave(max(nb_box)+1:end,k);
                time_next_serie=min(time_next_serie(time_next_serie~=0)); 
                % Choose the box that left last, while making sure
                % the drifter continues downstream
                if time_next_serie~=0
                    [~,idmax]=max(trapped_time_leave(nb_box_trapped(trapped_time_leave(nb_box_trapped,k)<time_next_serie),k));
                else
                    [~,idmax]=max(trapped_time_leave(nb_box_trapped,k));
                end
                trapped_leave(nb_box_trapped,k)=0;
                trapped_leave(nb_box_trapped(idmax),k)=1;
            end
        end
end
trapped_time_enter(trapped_enter==0)=0;
trapped_time_leave(trapped_leave==0)=0;


% Build table summarizing the pathways
id_res=1;
res=table;
res.origin=nan;
res.fate=nan;
res.originnb=nan;
res.originid=cell(1,1);
res.fatenb=nan;
res.fateid=cell(1,1);
res.pathnb=nan;
res.pathid=cell(1,1);
res.speedall=cell(1,1);
res.speed=nan;
warning('off','MATLAB:table:RowsAddedExistingVars') % do not display warning that when we add rows 
% we are not assigning values to all variables and that variables are extended with default values when not assigned
for i=1:length(trap_boxes)
    traps_totest=find(trap_section>trap_section(i));
    fill_nb=length(traps_totest);
    res.origin(id_res:id_res+fill_nb-1)=i;
    res.originnb(id_res:id_res+fill_nb-1)=sum(trapped_enter(i,:));
    res.originid(id_res:id_res+fill_nb-1)={find(trapped_enter(i,:))};
    for j=1:length(traps_totest)
        % How many arrive in trap?
        res.fate(id_res+j-1)=traps_totest(j);
        res.fatenb(id_res+j-1)=sum(trapped_enter(traps_totest(j),:));
        res.fateid(id_res+j-1)={find(trapped_enter(traps_totest(j),:))};
        % How many went from origin to fate box
        res.pathnb(id_res+j-1)=sum(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)); % using first crossed box for fate and last crossed box for origin
        res.pathid(id_res+j-1)={find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))};
        % Median time from one trap to the next
        res.speedall(id_res+j-1)={hours(trapped_time_enter(traps_totest(j),find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)))-trapped_time_leave(i,find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))))*6};
        res.speed(id_res+j-1)=days(hours(median(trapped_time_enter(traps_totest(j),find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)))-trapped_time_leave(i,find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))))*6));
    end
    id_res=id_res+fill_nb;
end

% Number of drifter used in pathways method
total_drift=[];
for i=1:height(res)
total_drift=[total_drift cell2mat(res.pathid(i))];
end
sprintf('Number of drifters used in method: %d',length(unique(total_drift)))

clear time_next_serie time_previous_serie nb_box_trapped nb_box i j k fill_nb idmin idmax id_res traps_totest trapped_enter trapped_leave
clear trap_DS trap_NorthLsh_1 trap_NorthLsh_2 trap_MidLsh_1 trap_MidLsh_2 trap_SouthLsh_1 trap_SouthLsh_2 trap_NL_1 trap_NL_fp trap_NL_fc 
