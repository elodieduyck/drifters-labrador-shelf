%% Figure 5 Export regions

% Display number of drifters exported by 200km segments of the shelf
% compared to number of drifters on-shelf (within 100km)

step=200;
step_max=5000;

out_step=cell(1,floor(step_max/step));
total_step=cell(1,floor(step_max/step));

for j=1:floor(step_max/step)
    km_min=(j-1)*step;
    km_max=j*step;
    drift_sel=unique(out_k(out_km<km_max & out_km>=km_min));

    % Compute total amount of drifter within 100km at the shelf at that section
    for i=1:length(drifter_data_SVP.IdBuoy)
        if ~isempty(find(shelf_km_drift(:,i)<km_max & shelf_km_drift(:,i)>=km_min & dist_shelf(:,i)>-100 & dist_shelf(:,i)<0,1))
            if dist_shelf(find(shelf_km_drift(:,i)<km_max & shelf_km_drift(:,i)>=km_min & dist_shelf(:,i)>-100 & dist_shelf(:,i)<0,1),i)<0%>=sum(dist_shelf(shelf_km_drift(:,i)<km_max & shelf_km_drift(:,i)>km_min & dist_shelf(:,i)>-100 & dist_shelf(:,i)<100,i)>0) % Is the drifter mostly on or off shelf
                total_step{j}=[total_step{j} i];
            end
        end
    end

    % Compute drifters crossing offshore at that section
    for i=1:length(drift_sel)
        % check if drifter is on shelf
        if dist_shelf(find(shelf_km_drift(:,drift_sel(i))<km_max & shelf_km_drift(:,drift_sel(i))>=km_min,1,'first'),drift_sel(i))<0 % is the drifter on or off shelf as it arrives in that region?
            if (sum(ismember(out_k(out_km<km_max & out_km>=km_min),drift_sel(i)))>sum(ismember(in_k(in_km<km_max & in_km>=km_min),drift_sel(i)))) % check if the drifter crossed offshore more often than onshore
                if ~ismember(drift_sel(i),in_k(in_km<km_max+5*step & in_km>=km_min+step)) % check that it does not re-enter right after
                    out_step{j}=[out_step{j} drift_sel(i)];
                end
            end
        end
    end
end

%% Map
fig=figure('units','normalized','outerposition',[0 0 .5 1]);
m_proj('lambert','long',[-62 -40],'lat',[41 65]);
hold on

m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');

for j=1:floor(step_max/step)
    km_min=(j-1)*step;
    km_max=j*step;
    sel=[pts_shelf(1,shelf_km<=km_max & shelf_km>km_min); pts_shelf(2,shelf_km<=km_max & shelf_km>km_min)];
    [x,y]=m_ll2xy(sel(1,:)',sel(2,:)');
    z=zeros(size(x));
    col=ones(size(x))*(length(out_step{j}));
    surface([x x],[y y],[z z],[col col],'facecol','no','edgecol','interp','linew',round(length(total_step{j})/10));
end

% Add info about shelf boundary
m_plot(interp1(shelf_km,pts_shelf(1,:),0:500:5000),interp1(shelf_km,pts_shelf(2,:),0:500:5000),'.k')
m_text(interp1(shelf_km,pts_shelf(1,:),0:500:5000)+.5,interp1(shelf_km,pts_shelf(2,:),0:500:5000)+.3,string(0:500:5000),'FontSize',15);
m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
colmap=m_colmap('diverging',12);
colormap(colmap(7:12,:))
c=colorbar('location','southoutside','FontSize',15);
c.Label.String='Number of exported drifters';
caxis([0 30])

%% Histogram
color=lines(2);
figure
hold on
bar(step/2:step:step_max-step/2,cellfun(@length,total_step),'FaceColor',brighten(color(2,:),0.7));
bar(step/2:step:step_max-step/2,cellfun(@length,out_step),'FaceColor',color(2,:));
legend('Total number of drifter', 'Number of exported drifters','Fontsize',15)
set(gca,'FontSize',15)

%% Drifters exported at the different sections
step=200*3; % Display by region of the shelf
k=0;
color=lines(2);
m_proj('lambert','long',[-69 -30],'lat',[40 69]);

for j=1400:step:4500
    k=k+1;
    km_min=j;
    km_max=j+step;
    drift_sel=unique(out_k(out_km<km_max & out_km>=km_min));
    fig=figure('units','normalized','outerposition',[0 0 .5 1]);
    hold on
    m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
    m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
    for i=1:length(drift_sel)
        % check if drifter is on shelf
        if dist_shelf(find(shelf_km_drift(:,drift_sel(i))<km_max & shelf_km_drift(:,drift_sel(i))>km_min,1,'first'),drift_sel(i))<0 % is the drifter on or off shelf as it arrives in that region?
            if (sum(ismember(out_k(out_km<km_max & out_km>km_min),drift_sel(i)))>sum(ismember(in_k(in_km<km_max & in_km>km_min),drift_sel(i)))) % check if the drifter crossed offshore more often than onshore
                if ~ismember(drift_sel(i),in_k(in_km<km_max+step*5 & in_km>=km_min+step)) % check that it does not re-enter right after
                    cross_time=out_time(find(out_k==drift_sel(i) & out_km<km_max & out_km>=km_min ,1,'last'));
                    m_plot(drifter_data_SVP.Longitude(cross_time:end,drift_sel(i)),drifter_data_SVP.Latitude(cross_time:end,drift_sel(i)),'color',color(2,:))
                    m_plot(drifter_data_SVP.Longitude(1:cross_time,drift_sel(i)),drifter_data_SVP.Latitude(1:cross_time,drift_sel(i)),'color',color(1,:))
                end
            end
        end
    end
    m_plot(pts_shelf(1,shelf_km<km_max & shelf_km>=km_min),pts_shelf(2,shelf_km<km_max & shelf_km>=km_min),'color', [.3,.3,.3], 'Linewidth',3)
    m_grid('xtick',-80:5:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
    title(sprintf('%d to %d km',km_min,km_max),'fontsize',15)
end

clear km_min km_max out_step total_step drift_sel drift_sel_in fig cross_time sel x y z col step step_max i j k colmap