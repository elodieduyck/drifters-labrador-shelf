%% S2: Fate of DS and HS drifters depending on where they leave the straits

area_DS=[  -61.99  -56.01  -55.9991  -61.98  -61.99;   66.64   66.99   66.80   66.48   66.64];
area_HS=[-65 -66 -66 -65 -65; 60 60 62 62 60];

%% Davis strait
color=parula(6);
color=color(2:5,:);
% Plot drifters exiting straits with colors to differentiate origin
% For davis strait, conditions
drift_sel_DS=[]; % save drifter
indate_save_DS=[];
outdate_save_DS=[];
for i=1:size(drift_lon,2)
    if sum(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)))>1 % does it ping > 1 time in area?
        indate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)),1,'first'); % enter?
        outdate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_DS(1,:),area_DS(2,:)),1,'last'); % leaves?
        if drift_lat(outdate-2,i)>drift_lat(outdate+2,i) % Check if drifter goes south
            drift_sel_DS=[drift_sel_DS i]; % save drifter
            indate_save_DS=[indate_save_DS indate];
            outdate_save_DS=[outdate_save_DS outdate];
        end
    end
end

fig=figure('units','normalized','outerposition',[0 0 .5 0.7]);
m_proj('lambert','long',[-70 -52],'lat',[59 68]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=1:length(drift_sel_DS)
    if drift_lat(outdate_save_DS(i)+10,drift_sel_DS(i))<drift_lat(outdate_save_DS(i),drift_sel_DS(i))% Check that the drifter flows southwards
        try
            m_plot(drift_lon(:,drift_sel_DS(i)),drift_lat(:,drift_sel_DS(i)),'Color',[.7 .7 .7])
            [x,y]=m_ll2xy(drift_lon(outdate_save_DS(i):end,drift_sel_DS(i)),drift_lat(outdate_save_DS(i):end,drift_sel_DS(i)));
            z=zeros(size(x));
            col=ones(length(x),1)*drift_lon(outdate_save_DS(i),drift_sel_DS(i));
            surface([x x],[y y],[z z],[col col],'facecol','no','edgecol','interp','linew',1.5);
        catch
        end
    end
end
m_plot(area_DS(1,:),area_DS(2,:),'r')
m_grid('xtick',-80:5:20,'ytick',40:2:85,'tickdir','in','yaxislocation','left','fontsize',15)
colormap(color)
colorbar('Location','southoutside','FontSize',15);
caxis([-62 -56])


% For hudson strait, conditions
drift_sel_HS=[]; % save drifter
indate_save_HS=[];
outdate_save_HS=[];
for i=1:size(drift_lon,2)
    if sum(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)))>1 % does it ping > 1 time in area?
        indate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)),1,'first'); % enter?
        outdate=find(inpolygon(drift_lon(:,i),drift_lat(:,i),area_HS(1,:),area_HS(2,:)),1,'last'); % leaves?
        if drift_lon(outdate-2,i)<drift_lon(outdate+2,i)  % Check if drifter goes east
            drift_sel_HS=[drift_sel_HS i]; % save drifter
            indate_save_HS=[indate_save_HS indate];
            outdate_save_HS=[outdate_save_HS outdate];
        end
    end
end

fig=figure('units','normalized','outerposition',[0 0 .5 0.7]);
m_proj('lambert','long',[-69 -55],'lat',[55 63]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=1:length(drift_sel_HS)
    try
        m_plot(drift_lon(:,drift_sel_HS(i)),drift_lat(:,drift_sel_HS(i)),'Color',[.7 .7 .7])
        [x,y]=m_ll2xy(drift_lon(outdate_save_HS(i):end,drift_sel_HS(i)),drift_lat(outdate_save_HS(i):end,drift_sel_HS(i)));
        z=zeros(size(x));
        col=ones(length(x),1)*drift_lat(outdate_save_HS(i),drift_sel_HS(i));
        surface([x x],[y y],[z z],[col col],'facecol','no','edgecol','interp','linew',1.5);
    catch
    end
end
m_plot(area_HS(1,:),area_HS(2,:),'r')
m_grid('xtick',-80:5:20,'ytick',40:2:85,'tickdir','in','yaxislocation','left','fontsize',15)
colormap(color)
colorbar('Location','southoutside','FontSize',15);
caxis([60.2 61])

clear outdate_save_DS indate_save_DS color drift_sel_DS outdate_save_HS indate_save_HS color drift_sel_HS x y z outdate indate i area_DS area_HS col fig