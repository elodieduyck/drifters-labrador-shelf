%% Figure S1 :
%
area_full=[-70 -42 -42 -70 -70;68 68 51 51 68];
area_LSh=[-68 -61 -59 -54 -50 -62 -68;62.5 62.5 57 55 51 51 62.5];

%% Show the filtering

load([data_folder+ "drifter_data_SVP_6h_nofilt.mat"],'drifter_data_SVP_nofilt');
terific_sel=drifter_data_SVP.Program=="TERIFIC5";

fig=figure('units','normalized','outerposition',[0 0 .5 0.7]);
m_proj('lambert','long',[-67 -60],'lat',[60 64]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',3)
m_plot(drifter_data_SVP.Longitude(:,terific_sel),drifter_data_SVP.Latitude(:,terific_sel));
m_grid('xtick',-80:2:20,'ytick',40:1:85,'tickdir','in','yaxislocation','left','fontsize',15)


fig=figure('units','normalized','outerposition',[0 0 .5 0.7]);
m_proj('lambert','long',[-67 -60],'lat',[60 64]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',3)
m_plot(drifter_data_SVP_nofilt.Longitude(:,terific_sel),drifter_data_SVP_nofilt.Latitude(:,terific_sel));
m_grid('xtick',-80:2:20,'ytick',40:1:85,'tickdir','in','yaxislocation','left','fontsize',15)

%% Undrogued
color=lines(5);

fig=figure('units','normalized','outerposition',[0 0 .5 1])
m_proj('lambert','long',[-69 -38],'lat',[40 68]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',3)
for i=1:length(drifter_data_SVP.IdBuoy)
    if sum(drifter_data_SVP.undrogued(:,i))>0
        if sum(inpolygon(drifter_data_SVP.Longitude(drifter_data_SVP.undrogued(:,i)==1,i),drifter_data_SVP.Latitude(drifter_data_SVP.undrogued(:,i)==1,i),area_LSh(1,:),area_LSh(2,:)))>0
            m_plot(drifter_data_SVP.Longitude(drifter_data_SVP.undrogued(:,i)==1,i),drifter_data_SVP_nofilt.Latitude(drifter_data_SVP.undrogued(:,i)==1,i),'color',color(1,:));
        end
    end
end
m_grid('xtick',-80:10:20,'ytick',40:10:85,'tickdir','in','yaxislocation','left','fontsize',15)

%%  Gaps
color=lines(5);

area_LSh=[-68 -61 -59 -54 -50 -62 -68;62.5 62.5 57 55 51 51 62.5]
fig=figure('units','normalized','outerposition',[0 0 .5 1])
m_proj('lambert','long',[-69 -38],'lat',[40 68]);
hold on
m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',2)
k=1;
% Drifters for which we remove a part (after gap) on the Labrador shelf
for i=1:length(drifter_data_SVP.IdBuoy)
    if sum(drifter_data_SVP.gap(:,i))>0
        if sum(inpolygon(drifter_data_SVP.Longitude(drifter_data_SVP.gap(:,i)==1,i),drifter_data_SVP.Latitude(drifter_data_SVP.gap(:,i)==1,i),area_LSh(1,:),area_LSh(2,:)))>0
            m_plot(drifter_data_SVP.Longitude(drifter_data_SVP.gap(:,i)==0,i),drifter_data_SVP.Latitude(drifter_data_SVP.gap(:,i)==0,i),'color',color(k,:),'linewidth',2.5);
            m_plot(drifter_data_SVP.Longitude(drifter_data_SVP.gap(:,i)==1,i),drifter_data_SVP.Latitude(drifter_data_SVP.gap(:,i)==1,i),'color',color(k,:),'linewidth',2.5, 'linestyle',':');
            k=k+1;
            sprintf('BuoyID: %s',drifter_data_SVP.IdBuoy(i))
        end
    end
end
m_grid('xtick',-80:10:20,'ytick',40:10:85,'tickdir','in','yaxislocation','left','fontsize',15)



clear drifter_data_SVP_nofilt terific_sel fig color area_full area_LSh