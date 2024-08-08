%% Figure 6 Absence of direct connection
% Figure with different colors for BB + HS and for WGC

% Drifters that passed by Davis strait
area_DS=[  -61.99  -56.01  -55.9991  -61.98  -61.99
   66.64   66.99   66.80   66.48   66.64];
drift_sel_DS=[]; % save drifter
indate_save_DS=[];
outdate_save_DS=[];
for i=1:size(drift_lon,2)
    if sum(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)))>1 % does it ping > 1 time in area?
        indate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)),1,'first'); % enter?
        outdate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)),1,'last'); % leaves?
        if drift_lat(indate,i)>drift_lat(outdate,i) % Check if drifter goes south
            drift_sel_DS=[drift_sel_DS i]; % save drifter
            indate_save_DS=[indate_save_DS indate];
            outdate_save_DS=[outdate_save_DS outdate];
        end
    end
end

% Drifters that passed by Hudson Strait
area_HS=[-65 -66 -66 -65 -65; 60 60 62 62 60];
drift_sel_HS=[]; % save drifter
indate_save_HS=[];
outdate_save_HS=[];
for i=1:size(drift_lon,2)
    if sum(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)))>1 % does it ping > 1 time in area?
        indate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)),1,'first'); % enter?
        outdate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)),1,'last'); % leaves?
         if drift_lon(indate,i)<drift_lon(outdate,i) | drift_lat(indate,i)>drift_lat(outdate,i)% Check if drifter goes east
            drift_sel_HS=[drift_sel_HS i]; % save drifter
            indate_save_HS=[indate_save_HS indate];
            outdate_save_HS=[outdate_save_HS outdate];
         end
    end
end



[lonmin, lonmax, latmin, latmax]=deal(-70, -30, 40, 68.5);
m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);
color=lines(3);

fig5=figure('units','normalized','outerposition',[0 0 .5 1]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',3)
for i=1:length(drift_sel_DS)
m_plot(drift_lon(indate_save_DS(i):end,drift_sel_DS(i)),drift_lat(indate_save_DS(i):end,drift_sel_DS(i)),'color',color(2,:), 'linewidth',1.2)
end
for i=1:length(drift_sel_HS)
m_plot(drift_lon(indate_save_HS(i):end,drift_sel_HS(i)),drift_lat(indate_save_HS(i):end,drift_sel_HS(i)),'color',color(1,:), 'linewidth',1.2)
end

m_plot(area_DS(1,:),area_DS(2,:),'color',[1 .8 .6], 'linewidth',2);
m_plot(area_HS(1,:),area_HS(2,:),'color',[.6 .8 1], 'linewidth',2);
m_grid('xtick',-80:10:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)

clear fig5 area_DS drift_sel_DS indate_save_DS outdate_save_DS area_HS drift_sel_HS indate_save_HS outdate_save_HS indate outdate