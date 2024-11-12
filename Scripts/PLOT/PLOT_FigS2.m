%% OSISAF
[lonmin, lonmax, latmin, latmax]=deal(-70, -40, 45, 70);

% Load OSISAF data
folder_OSISAF='C:\Users\u241341\Documents\5-Data\siconc\';
lon_OSISAF=double(load([folder_OSISAF 'OSISAF_SI_20192023.mat']).longitude);
lat_OSISAF=double(load([folder_OSISAF 'OSISAF_SI_20192023.mat']).latitude);
siconc_OSISAF=load([folder_OSISAF 'OSISAF_SI_20192023.mat']).siconc;
time_OSISAF=datetime(1970,1,1)+seconds(load([folder_OSISAF 'OSISAF_SI_20192023.mat']).time)*1e-9;
siconc_OSISAF(siconc_OSISAF==-32767)=NaN;

% 4 snapshots sea ice + drogued and undrogued drifters
snap_times=['05-dec-2021';'05-jan-2022';'05-feb-2022';'05-Mar-2022']

for i=1:size(snap_times,1)
    figure('units','normalized','outerposition',[0 0 1 1]);
    m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);
    hold on
    m_pcolor(lon_OSISAF,lat_OSISAF,squeeze(siconc_OSISAF(time_OSISAF==datetime(snap_times(i,:)),:,:)))
    m_contour(lonT,latT,topoT,[-5000 -2500 -1000 -500 -250 0],'edgecolor',[.7 .7 .7],'linewidth',1);
    m_contourf(lonT,latT,topoT,[0 0],'facecolor',[.9 .9 .9],'edgecolor','none');
    colormap(m_colmap('blue'))
    clim([0 100])
    timedr_sel=find(drifter_data_SVP.time==datetime(snap_times(i,:)));
    sel_dr=~drifter_data_SVP.undrogued(drifter_data_SVP.time==datetime(snap_times(i,:)),:);
    sel_undr=logical(drifter_data_SVP.undrogued(drifter_data_SVP.time==datetime(snap_times(i,:)),:));
    % if timedr_sel>20
    m_scatter(drifter_data_SVP.Longitude(timedr_sel,sel_dr),drifter_data_SVP.Latitude(timedr_sel,sel_dr),15,'g','filled','Clipping','on')
    m_plot(drifter_data_SVP.Longitude(timedr_sel-50:timedr_sel,sel_dr),drifter_data_SVP.Latitude(timedr_sel-50:timedr_sel,sel_dr),'g','Clipping','on')
    m_scatter(drifter_data_SVP.Longitude(timedr_sel,sel_undr),drifter_data_SVP.Latitude(timedr_sel,sel_undr),15,'r','filled','Clipping','on')
    m_plot(drifter_data_SVP.Longitude(timedr_sel-50:timedr_sel,sel_undr),drifter_data_SVP.Latitude(timedr_sel-50:timedr_sel,sel_undr),'r','Clipping','on')
    m_grid('xtick',-80:10:20,'ytick',40:5:85,'tickdir','in','yaxislocation','left','fontsize',15)
    title(string(datetime(snap_times(i,:))))
end
