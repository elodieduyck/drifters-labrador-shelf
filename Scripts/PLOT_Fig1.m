%% Figure 1: Overview of the circulation and bathymetric features

fig1a=figure('units','normalized','outerposition',[0 0 .5 1]);
m_proj('lambert','long',[-67 -40],'lat',[40 69]);
hold on
[CS,CH]=m_contourf(lonT,latT,topoT,[-6000 -2500 -2000 -1500 -1000 -750 -500 -250 -100 0],'edgecolor','none');
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7]);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
colormap(m_colmap('blues',10))
c=colorbar('location','southoutside','FontSize',15);
c.Label.String='Depth (km)';
caxis([-2000 0])
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)


fig1b=figure('units','normalized','outerposition',[0 0 .5 1]);
m_proj('lambert','long',[-61 -48],'lat',[48 59.5],'rectbox','on');
hold on
[CS,CH]=m_contourf(lonT,latT,topoT,[-1000:50:0],'edgecolor','none');
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7]);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
c=colorbar('location','southoutside','FontSize',15);
c.Label.String='Depth (km)';
colormap(m_colmap('blues',10))
caxis([-500 0])
m_grid('xtick',-80:5:20,'ytick',40:2.5:85,'tickdir','in','yaxislocation','left','fontsize',15)

clear CS CH c fig1a fig1b