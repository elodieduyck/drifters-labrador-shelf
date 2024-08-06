%% Figure 9 Newfoundland export

% Display where the drifters that went through Flemish Pass left the shelf
% and were exported offshore

m_proj('lambert','long',[-60 -40],'lat',[39.5 52]);
colmap=lines(2);

% Limits along the shelf used to show where drifters get out
lim1=4000;
lim2=4300;
lim3=4600;

% Compute until when the drifter remains within 100 km of the shelf -> So
% we do not look at when it crosses the shelf but when it really leaves the
% shelf area

shelf_km_100=shelf_km_drift;
shelf_km_100(dist_shelf>100 | dist_shelf<-100)=NaN;
max_dist_sh=nanmax(shelf_km_100,[],1);

figure
k=0;
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=cell2mat(res.fateid(35)) % drifters that passed through Flemish Pass
    if max_dist_sh(i)<lim1
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[772 646 1872]),drift_lat(:,[772 646 1872]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)

m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(cell2mat(res.fateid(35)))),'fontsize',15) 

figure
k=0;
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=cell2mat(res.fateid(35))
    if max_dist_sh(i)>=lim1 && max_dist_sh(i)<lim2
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[2196 886 1879]),drift_lat(:,[2196 886 1879]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim2),pts_shelf(2,shelf_km==lim2),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(cell2mat(res.fateid(35)))),'fontsize',15)

figure
k=0;
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=cell2mat(res.fateid(35))
    if max_dist_sh(i)>=lim2 && max_dist_sh(i)<lim3
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[2191 2034 1713]),drift_lat(:,[2191 2034 1713]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim2),pts_shelf(2,shelf_km==lim2),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim3),pts_shelf(2,shelf_km==lim3),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(cell2mat(res.fateid(35)))),'fontsize',15)

figure
k=0;
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=cell2mat(res.fateid(35))
    if max_dist_sh(i)>=lim3
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[2345 1896 1425]),drift_lat(:,[2345 1896 1425]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim2),pts_shelf(2,shelf_km==lim2),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim3),pts_shelf(2,shelf_km==lim3),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(cell2mat(res.fateid(35)))),'fontsize',15)

clear shelf_km_100 max_dist_sh i j k i_ex lim1 lim2 lim3 colmap

