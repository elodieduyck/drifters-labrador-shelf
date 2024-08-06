%% Figure 4 Quasi eulerian maps of velocity derived from drifters

[lonmin, lonmax, latmin, latmax]=deal(-70, -30, 40, 70);
% Count the number of separate drifters that have data in one bin -> So we
% can make sure data from each bin shown is from more than one drifter

% compute total number of data in each bin as well as bin limits and which
% bin each data point is associated to
[numz,xmid,ymid,id_x,id_y]=histcounts2(drift_lon,drift_lat,[lonmin:1/3:lonmax],[latmin:1/6:latmax]); 

% Verify that each bin indeed has data from > 1 drifter
% The operation is quite long, can also immediately load
load([data_folder 'drift_bin_count.mat'])

% drift_id_whole=repmat(drifter_data_SVP.IdBuoy,length(drift_time),1);
% drift_bin_count=zeros(size(numz));
% for i=1:size(numz,1)
%     for j=1:size(numz,2)
%         if ~numz(i,j)==0
%             drift_bin_count(i,j)=length(unique(drift_id_whole(find(id_x==i & id_y==j))));
%         end
%     end
% end


%% General map
m_proj('lambert','long',[-67 -35],'lat',[40 68]);

[mz_speed,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,sqrt(drift_u.^2+drift_v.^2),[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_speed(numz<5)=NaN; % Check there's more than 5 data points in each bin
mz_speed(drift_bin_count'<=1)=NaN; % Check there's at least two independent (different drifters) measurements in each bin

[mz_u,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_u,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
[mz_v,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_v,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_u(numz<5)=NaN;
mz_v(numz<5)=NaN;
[Xmid,Ymid]=meshgrid(xmid,ymid);

fig=figure('units','normalized','outerposition',[0 0 .5 1]);
hold on
m_pcolor(xmid-1/6,ymid-1/12,mz_speed) % adjust to have coordinates at the center of colored pixel, not at south west edge
m_quiver(Xmid,Ymid,mz_u,mz_v,'k')
m_contour(lonT,latT,topoT,[-2000 -1000 -250],'edgecolor',[.95 .95 .95],'linewidth',1.5);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.7 .7 .7]);
colormap lansey
caxis([0 60])
m_grid('xtick',-80:10:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)


%% Zoom Labrador shelf
arrowscale=0.01;
m_proj('lambert','long',[-66,-49],'lat',[53,63],'rectbox','on');

[mz_speed,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,sqrt(drift_u.^2+drift_v.^2),[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_speed(numz<5)=NaN; % Check there's more than 10 data points in each bin
mz_full(drift_bin_count'<=1)=NaN; % Check there's at least two independent (different drifters) measurements in each bin

[mz_u,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_u,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
[mz_v,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_v,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_u(numz<5)=NaN;
mz_v(numz<5)=NaN;
[Xmid,Ymid]=meshgrid(xmid,ymid);

figure
hold on
m_pcolor(xmid-1/6,ymid-1/12,mz_speed) % adjust to have coordinates at the center of colored pixel, not at south west edge
m_quiver(Xmid,Ymid,mz_u*arrowscale,mz_v*arrowscale,'k','AutoScale','Off')
m_contour(lonT,latT,topoT,[-2000 -1000 -250],'edgecolor',[.95 .95 .95],'linewidth',1.5);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.7 .7 .7]);
colormap lansey
caxis([0 60])
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)


%% Zoom Newfoundland shelf
arrowscale=0.01;
m_proj('lambert','long',[-57,-42],'lat',[40,51],'rectbox','on');

[mz_speed,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,sqrt(drift_u.^2+drift_v.^2),[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_speed(numz<5)=NaN; % Check there's more than 10 data points in each bin
% mz_full(drift_bin_count'<=1)=NaN; % Check there's at least two independent (different drifters) measurements in each bin

[mz_u,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_u,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
[mz_v,xmid,ymid,numz,~]=twodstats(drift_lon,drift_lat,drift_v,[lonmin:1/3:lonmax],[latmin:1/6:latmax]);
mz_u(numz<5)=NaN;
mz_v(numz<5)=NaN;
[Xmid,Ymid]=meshgrid(xmid,ymid);

figure
hold on
m_pcolor(xmid-1/6,ymid-1/12,mz_speed) % adjust to have coordinates at the center of colored pixel, not at south west edge
m_quiver(Xmid,Ymid,mz_u*arrowscale,mz_v*arrowscale,'k','AutoScale','Off')
m_contour(lonT,latT,topoT,[-2000 -1000 -250],'edgecolor',[.95 .95 .95],'linewidth',1.5);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.7 .7 .7]);
colormap lansey
caxis([0 60])
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)

%% colmap

fig=figure('units','normalized','outerposition',[0 0 .5 .5]);
colormap lansey
caxis([0 60])
colorbar('Location','south','FontSize',15);
axis off

%%
clear lonmin lonmax latmin latmax arrowscale mz_speed xmid ymid Xmid Ymid numz mz_u mz_v mz_full id_x id_y drift_bin_count
