%% Figure 3 Methods: Shelf sections and key passage points for pathway identification

[lonmin, lonmax, latmin, latmax]=deal(-67, -40, 40, 68);
m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);

% Check shelf and distances
color=lines(2);
fig3a=figure('units','normalized','outerposition',[0 0 .5 1]);
hold on
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7]);
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',brighten(color(2,:),0.5),'linewidth',2);
m_plot(pts_shelf(1,1:100:end),pts_shelf(2,1:100:end),'.','markersize',15,'color',brighten(color(2,:),0.5));
m_text(pts_shelf(1,1:100:end),pts_shelf(2,1:100:end),string(ceil(shelf_km(1:100:end))), 'FontSize',18);
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',18)

fig3b=figure('units','normalized','outerposition',[0 0 .5 1]);
hold on
[CS,CH]=m_contourf(lonT,latT,topoT,[-6000 -2500 -2000 -1500 -1000 -750 -500 -250 -100 0],'edgecolor','none');
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7]);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
colormap(m_colmap('blues',10))
c=colorbar('location','southoutside','FontSize',15);
c.Label.String='Depth (km)';
caxis([-2000 0])
m_plot(squeeze(trap_boxes(1,:,:)),squeeze(trap_boxes(2,:,:)),'color','m','linewidth',3)
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)

clear fig3a fig3b color CS CH c