%% Figure S5: Pathways between 2 boxes -> Built in the same way as Figure 8

% Change parameters to display different combinaisons
colmap=lines(8);

serie_1=2;
serie_2=5;
col_start=4; % choose color combination
nb_origin=sum(trap_section==serie_1)
nb_fate=sum(trap_section==serie_2)

m_proj('lambert','long',[-66 -36],'lat',[41 67.5]);
for j=1:nb_origin

    fig=figure('units','normalized','outerposition',[0 0 .5 1]);
    hold on
    m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.9 .9 .9],'linewidth',1);
    m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');

    % Plot drifter trajectories
    trap_origin=find(trap_section==serie_1,1,'first')+j-1;
    for k=1:nb_fate
        trap_fate=find(trap_section==serie_2,1,'first')+k-1;
        drift_id=res.pathid(res.origin==trap_origin & res.fate==trap_fate);
        m_plot(drift_lon(:,cell2mat(drift_id)),drift_lat(:,cell2mat(drift_id)),'color',brighten(colmap(k+col_start,:),+0.5), 'linewidth',1.2);
    end

    % plot shelf boundary and boxes
    m_plot(pts_shelf(1,:),pts_shelf(2,:),'color',[.7 .7 .7],'linewidth',3)
    for k=1:nb_fate
        trap_fate=find(trap_section==serie_2,1,'first')+k-1;
        m_plot(trap_boxes(1,:,trap_fate),trap_boxes(2,:,trap_fate),'color',colmap(k+col_start,:),'linewidth',4)
    end
    m_plot(trap_boxes(1,:,trap_origin),trap_boxes(2,:,trap_origin),'color',[.3 .3 .3],'linewidth',3)
    m_grid('xtick',-80:10:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)

end

clear colmap nb_origin nb_fate serie_1 serie_2 col_start trap_origin fig drift_id j k trap_fate