%% Define shelf boundary
[lonmin, lonmax, latmin, latmax]=deal(-70, -20, 40, 70);
m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);

% Select isobath: 1000m
shelf_gr=[];
shelfs=m_contour(lonT,latT,topoT,[-1000 -1000],'edgecolor','k');

% find the longest unbroken 1000m isobath, which corresponds to the
% shelfbreak, and convert to geographic coordinates
id_vert=find(shelfs(1,:)==-1000);
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
shelf_gr_sm=smoothdata(shelf_gr_1km','gaussian',windowSize)';

%Interpolate to a 5km resolution shelf
shelf_km=[0;cumsum(m_lldist(shelf_gr_sm(1,:), shelf_gr_sm(2,:)))];
shelf_5km=0:5:max(shelf_km);
shelf_gr_5km=interp1(shelf_km,shelf_gr_sm',shelf_5km)';
shelf_km=shelf_5km;

% Compute the final shelf boundary, and a polygon to identify drifters that cross in
% and out of the shelf
pts_shelf=shelf_gr_5km;
shelf_poly=[pts_shelf [-80 -50 -30 -30 ;35 35 35 60] shelf_gr_5km(:,1)]; 

clear shelf_5km shelf_gr shelf_gr_xy windowSize id_vert max_vert id_vertmax shelfs shelf_gr_1km shelf_gr_sm shelf_1km

% % Test plot the shelf boundary and the polygon
figure
hold on
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.7 .7 .7]);
m_contour(lonT,latT,topoT,[-5000 -2000 -1000 -500 -200 0],'edgecolor',[.7 .7 .7]);
% m_plot(shelf_gr(1,:),shelf_gr(2,:),'.b');
% m_plot(shelf_gr2(1,:),shelf_gr2(2,:),'.g');
m_plot(shelf_gr_5km(1,:),shelf_gr_5km(2,:),'.r');
m_plot(shelf_poly(1,:),shelf_poly(2,:),'r');
m_grid
