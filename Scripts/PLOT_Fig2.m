%% Figure 2 Drifter concentration

area_full=[-70 -42 -42 -70 -70;68 68 51 51 68];
area_LSh=[-68 -61 -59 -54 -50 -62 -68;62.5 62.5 57 55 51 51 62.5];

[lonmin, lonmax, latmin, latmax]=deal(-68, -35, 40, 68);
m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);

% Drifter data concentration map
fig2a=figure('units','normalized','outerposition',[0 0 .5 1]);
[mat,xmid,ymid]=twodhist(drift_lon,drift_lat,[-70:1/3:-30],[40:1/6:70]);
m_pcolor(xmid,ymid,mat)
colormap(flipud(pink))
hold on
m_contour(lonT,latT,topoT,[-2000 -1000 -250],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contour(lonT,latT,topoT,[-1000 -1000],'edgecolor',[.7 .7 .7],'linewidth',2);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
% m_plot(area_full(1,:),area_full(2,:)) 
% m_plot(area_LSh(1,:),area_LSh(2,:))
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.8 .8 .8],'linewidth',3)
m_grid('xtick',-80:10:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
caxis([0 150])
c=colorbar('location','southoutside','FontSize',15);
c.Label.String='Number of drogued surface drifter data point per bin';


% Data density per year and per month
time_mat=repmat(drifter_data_SVP.time,length(drifter_data_SVP.IdBuoy),1)';
time_mat_full=time_mat(inpolygon(drifter_data_SVP.Longitude,drifter_data_SVP.Latitude,area_full(1,:),area_full(2,:)));
time_mat_LSh=time_mat(inpolygon(drifter_data_SVP.Longitude,drifter_data_SVP.Latitude,area_LSh(1,:),area_LSh(2,:)));

fig2b=figure('units','normalized','outerposition',[0.55 0 .4 1]);
colors=lines(2);

subplot(2,1,1)
hold on
% amount of data per year
histogram(year(time_mat_full),1992:2023)
histogram(year(time_mat_LSh),1992:2023)
yyaxis right
% Fraction of data per year
plot(1992.5:2022.5,histcounts(year(time_mat_full),1992:2023,'Normalization','probability'),'color',colors(1,:),'linewidth',2,'LineStyle','-')
plot(1992.5:2022.5,histcounts(year(time_mat_LSh),1992:2023,'Normalization','probability'),'color',colors(2,:),'linewidth',2,'LineStyle','-')
set(gca,'YColor','k')
xlabel('years')
legend('Labrador Sea','Labrador Shelf')
set(gca,'FontSize',15);

subplot(2,1,2)
hold on
% amount of data per month
histogram(month(time_mat_full),0.5:12.5)
histogram(month(time_mat_LSh),0.5:12.5) % Less data in the spring, which makes sense
yyaxis right
% Fraction of data per month
plot(1:12,histcounts(month(time_mat_full),0.5:12.5,'Normalization','probability'),'color',colors(1,:),'linewidth',2,'LineStyle','-')
plot(1:12,histcounts(month(time_mat_LSh),0.5:12.5,'Normalization','probability'),'color',colors(2,:),'linewidth',2,'LineStyle','-')
xlabel('months')
set(gca,'YColor','k')
set(gca,'FontSize',15);

clear area_full area_LSh fig2a fig2b c time_mat time_mat_full time_mat_LSh mat xmid ymid colors