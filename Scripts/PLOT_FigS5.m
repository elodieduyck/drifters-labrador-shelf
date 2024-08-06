
%% Newfoundland export Flemish Cap

% We use the 2500m isobath

%% Define shelf boundary at newfoundland
m_proj('lambert','long',[-57,-42],'lat',[40,51],'rectbox','on');

% Select isobath: 2500m
shelf_gr=[];
shelfs=m_contour(lonT,latT,topoT,[-2500 -2500],'edgecolor','k');

% find the longest unbroken 1000m isobath, which corresponds to the
% shelfbreak, and convert to geographic coordinates
id_vert=find(shelfs(1,:)==-2500);
[max_vert,id_vertmax]=max(shelfs(2,id_vert)); 
shelf_gr_xy=shelfs(:,id_vert(id_vertmax)+1:id_vert(id_vertmax+1)-1);
shelf_gr_xy=fliplr(shelf_gr_xy);
[shelf_gr(1,:), shelf_gr(2,:)]=m_xy2ll(shelf_gr_xy(1,:),shelf_gr_xy(2,:));

% Only keep the shelf boundary north of 42N and West of 41W
shelf_gr=shelf_gr(:,shelf_gr(1,:)<-41);
shelf_gr=shelf_gr(:,shelf_gr(2,:)>42);
shelf_gr=unique(shelf_gr','rows','stable')'; % to remove double points 

% Interpolate to regular, 1km resolution shelf
shelf_km=[0;cumsum(m_lldist(shelf_gr(1,:), shelf_gr(2,:)))];
shelf_1km=0:1:max(shelf_km);
shelf_gr_1km=interp1(shelf_km,shelf_gr',shelf_1km)';

% Smooth the shelf with a 150km window to keep large features only
windowSize=150;
% shelf_gr_1km=smoothdata2(shelf_gr_1km,'lowess',windowSize)
shelf_gr=smoothdata(shelf_gr','gaussian',windowSize)';

%Interpolate to a 5km resolution shelf
shelf_km=[0;cumsum(m_lldist(shelf_gr(1,:), shelf_gr(2,:)))];
shelf_5km=0:5:max(shelf_km);
shelf_gr_5km=interp1(shelf_km,shelf_gr',shelf_5km)';
shelf_km=shelf_5km;

% Compute the final shelf boundary, and a polygon to identify drifters that cross in
% and out of the shelf
pts_shelf=shelf_gr_5km;
shelf_poly=[pts_shelf [-50 -35 -35 -50 ; 40 35 55 55] shelf_gr_5km(:,1)]; 


shelf_km_100=shelf_km_drift;
shelf_km_100(dist_shelf>100 | dist_shelf<-100)=NaN;
max_dist_sh=nanmax(shelf_km_100,[],1);

lim1=700;
lim2=950;

drift_sel=cell2mat(res.fateid(39));
drift_sel=drift_sel(ismember(cell2mat(res.fateid(39)),cell2mat(res.originid(39))));

colmap=lines(1)
figure
k=0;
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=drift_sel % drifters that passed through Flemish Cape and came from the shelfbreak
    if max_dist_sh(i)<lim1
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[1814 1824 1861]),drift_lat(:,[1814 1824 1861]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',2)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(drift_sel)),'fontsize',15)

k=0;
figure
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=drift_sel
    if max_dist_sh(i)>=lim1 && max_dist_sh(i)<lim2
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;
    end
end
m_plot(drift_lon(:,[2405 2229 2039]),drift_lat(:,[2405 2229 2039]),'color',colmap(1,:),'linewidth',1.1)
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',2)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim2),pts_shelf(2,shelf_km==lim2),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
title(sprintf('%1.0f out of %1.0f drifters',k,length(drift_sel)),'fontsize',15)

k=0;
figure
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
for i=drift_sel
    if max_dist_sh(i)>lim1 && max_dist_sh(i)>=lim2
        m_plot(drift_lon(:,i),drift_lat(:,i),'color',[.7 .9 1],'linewidth',1.1)
        k=k+1;

    end

end
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',2)
m_plot(pts_shelf(1,shelf_km==lim1),pts_shelf(2,shelf_km==lim1),'*k','MarkerSize',4)
m_plot(pts_shelf(1,shelf_km==lim2),pts_shelf(2,shelf_km==lim2),'*k','MarkerSize',4)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
m_plot(drift_lon(:,[1992 1951]),drift_lat(:,[1992 1951]),'color',colmap(1,:),'linewidth',1.1)
title(sprintf('%1.0f out of %1.0f drifters',k,length(drift_sel)),'fontsize',15)

