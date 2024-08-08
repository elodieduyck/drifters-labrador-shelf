%% Figure 10 Fate of exported waters
% Heat map of export

%% Flemish Pass
k=0;
m_proj('lambert','long',[-69 -20],'lat',[40 69]);
drift_sel=cell2mat(res.fateid(35));

% Select drifter coordinates before and after reaching Flemish Pass
sel_lon_in=[];
sel_lat_in=[];
sel_lon_out=[];
sel_lat_out=[];
for i=1:length(drift_sel)
    cross_time=trapped_time_enter(9,drift_sel(i)); % Flemish Pass box
    sel_lon_in=[sel_lon_in drift_lon(cross_time-1460:cross_time,drift_sel(i))];
    sel_lat_in=[sel_lat_in drift_lat(cross_time-1460:cross_time,drift_sel(i))];

    % And where do they go?
    if cross_time+1460<=length(drift_lon)
        sel_lon_out=[sel_lon_out drift_lon(cross_time:cross_time+1460,drift_sel(i))];
        sel_lat_out=[sel_lat_out drift_lat(cross_time:cross_time+1460,drift_sel(i))];
    else
        fill_nans=nan(1461-length(drift_lon(cross_time:end,drift_sel(i))),1);
        sel_lon_out=[sel_lon_out [drift_lon(cross_time:end,drift_sel(i));fill_nans]];
        sel_lat_out=[sel_lat_out [drift_lat(cross_time:end,drift_sel(i));fill_nans]];
    end

end

fig=figure('units','normalized','outerposition',[0 0 .5 1]);
ax1=axes
% Bin coordinates before reaching Flemish Pass
[mat,xmid,ymid]=twodhist(sel_lon_in,sel_lat_in,[-70:1:0],[40:1/2:70]);
mat=mat./sum(sum(mat))*100; % Percentage of data
mat(mat==0)=NaN;
m_pcolor(xmid,ymid,mat)
colormap(ax1,[1 1 1; sky(20)])
caxis([0 .7])
m_grid('xtick',-80:10:20,'ytick',40:10:85,'tickdir','in','yaxislocation','left','fontsize',15)
ax2=axes
% Bin coordinates after reaching Flemish Pass
[mat,xmid,ymid]=twodhist(sel_lon_out,sel_lat_out,[-70:1:0],[40:1/2:70]);
mat=mat./sum(sum(mat))*100; % Percentage of data
mat(mat==0)=NaN;
m_pcolor(xmid,ymid,mat)
colormap(ax2,flipud(pink(20)))
caxis([0 .7])
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
% m_plot(pts_shelf(1,shelf_km<km_max & shelf_km>km_min),pts_shelf(2,shelf_km<km_max & shelf_km>km_min),'color', [.7,.7,.7], 'Linewidth',3)
m_grid
m_ungrid
axis(ax2,'off')
linkaxes([ax1,ax2])
title('Origin and fate of Flemish Pass drifters','FontSize',15);

%% Flemish Cap

k=0;
m_proj('lambert','long',[-69 -20],'lat',[40 69]);
drift_sel=cell2mat(res.fateid(39));
sel_lon_in=[];
sel_lat_in=[];
sel_lon_out=[];
sel_lat_out=[];
for i=1:length(drift_sel)
    cross_time=trapped_time_enter(10,drift_sel(i));
    sel_lon_in=[sel_lon_in drift_lon(cross_time-1460:cross_time,drift_sel(i))];
    sel_lat_in=[sel_lat_in drift_lat(cross_time-1460:cross_time,drift_sel(i))];

    % And where do they go?
    if cross_time+1460<=length(drift_lon)
        sel_lon_out=[sel_lon_out drift_lon(cross_time:cross_time+1460,drift_sel(i))];
        sel_lat_out=[sel_lat_out drift_lat(cross_time:cross_time+1460,drift_sel(i))];
    else
        fill_nans=nan(1461-length(drift_lon(cross_time:end,drift_sel(i))),1);
        sel_lon_out=[sel_lon_out [drift_lon(cross_time:end,drift_sel(i));fill_nans]];
        sel_lat_out=[sel_lat_out [drift_lat(cross_time:end,drift_sel(i));fill_nans]];
    end

end

fig=figure('units','normalized','outerposition',[0 0 .5 1]);
ax1=axes
[mat,xmid,ymid]=twodhist(sel_lon_in,sel_lat_in,[-70:1:0],[40:1/2:70]);
mat=mat./sum(sum(mat))*100; % Percentage of data
mat(mat==0)=NaN;
m_pcolor(xmid,ymid,mat)
colormap(ax1,[1 1 1; sky(20)])
caxis([0 .7])
m_grid('xtick',-80:10:20,'ytick',40:10:85,'tickdir','in','yaxislocation','left','fontsize',15)
ax2=axes
[mat,xmid,ymid]=twodhist(sel_lon_out,sel_lat_out,[-70:1:0],[40:1/2:70]);
mat=mat./sum(sum(mat))*100; % Percentage of data
mat(mat==0)=NaN;
m_pcolor(xmid,ymid,mat)
colormap(ax2,flipud(pink(20)))
caxis([0 .7])
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
% m_plot(pts_shelf(1,shelf_km<km_max & shelf_km>km_min),pts_shelf(2,shelf_km<km_max & shelf_km>km_min),'color', [.7,.7,.7], 'Linewidth',3)
m_grid
m_ungrid
axis(ax2,'off')
linkaxes([ax1,ax2])
title('Origin and fate of Flemish Cap drifters','FontSize',15);


%% Make colormaps
fig=figure('units','normalized','outerposition',[0 0 .5 .5]);
colormap([1 1 1; sky(20)])
caxis([0 0.7])
colorbar('Location','south','FontSize',15);
axis off

fig=figure('units','normalized','outerposition',[0 0 .5 .5]);
colormap(flipud(pink(20)))
caxis([0 0.7])
colorbar('Location','south','FontSize',15);
axis off

%% Compute how many days it takes for drifters to reach 30W after crossing
% Flemish Pass
days_FPto30W=[];
for i=cell2mat(res.fateid(35))
    cross_time=trapped_time_enter(9,i);
    days_FPto30W=[days_FPto30W find(drifter_data_SVP.Longitude(cross_time:end,i)>-30,1,'first')./4];
end
sprintf('Media number of days from Flemish Pass to 30W: %1.0f',median(days_FPto30W))
% We take the median, not the mean, to avoid having the data biased by the drifters that took much longer


% Flemish Cap
days_FCto30W=[];
for i=cell2mat(res.fateid(39))
    cross_time=trapped_time_enter(10,i);
    days_FCto30W=[days_FCto30W find(drifter_data_SVP.Longitude(cross_time:end,i)>-30,1,'first')./4];
end
sprintf('Media number of days from Flemish Cap to 30W: %1.0f',median(days_FCto30W))


clear cross_time drift_sel sel_lon_in sel_lon_out sel_lat_in sel_lat_out mat xmid ymid ax1 ax2 fig fill_nans
