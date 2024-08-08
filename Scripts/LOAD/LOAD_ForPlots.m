%%%%%%%% General parameters for plots and computations %%%%%%%%
% Already saved combined drifter data (GDP + EGC Drift from 01-Jan-90 to
% 01-Jun-23
load([data_folder+ "drifter_data_SVP_6h.mat"],'drifter_data_SVP');

% Box for loading the shelf and for the general maps
[lonmin, lonmax, latmin, latmax]=deal(-70, -20, 40, 70);
m_proj('lambert','long',[lonmin,lonmax],'lat',[latmin,latmax]);

% Load topography from publicly available etopo22 60s surface file

% topofile=[data_folder '\Topo\ETOPO_2022_v1_60s_N90W180_surface.nc'];
% lonT=ncread(topofile,'lon');
% latT=ncread(topofile,'lat');
% [~,startlon]=min(abs(lonT-lonmin));
% [~,endlon]=min(abs(lonT-lonmax));
% [~,startlat]=min(abs(latT-latmin));
% [~,endlat]=min(abs(latT-latmax));
% lonT=ncread(topofile,'lon',startlon, endlon-startlon);
% latT=ncread(topofile,'lat',startlat, endlat-startlat);
% topoT=ncread(topofile,'z',[startlon startlat],[endlon-startlon endlat-startlat])';
% save([data_folder+ "Topo\etopo22_surf60s_SPNA\longitude.mat"],'lonT');
% save([data_folder+ "Topo\etopo22_surf60s_SPNA\latitude.mat"],'latT');
% save([data_folder+ "Topo\etopo22_surf60s_SPNA\topo.mat"],'topoT');

% Load topography from pre-saved data
load([data_folder+ "etopo22_surf60s_SPNA\longitude.mat"],'lonT');
load([data_folder+ "etopo22_surf60s_SPNA\latitude.mat"],'latT');
load([data_folder+ "etopo22_surf60s_SPNA\topo.mat"],'topoT');

% Select drifter data
% Only keep data from drogued drifters, remove data after a >30 days data
% gap, and remove empty drifters, before rearranging data in 2D arrays for
% longitude, latitude, zonal and meridional velocities 
sel_clean=~drifter_data_SVP.undrogued & ~drifter_data_SVP.gap & isfinite(drifter_data_SVP.Longitude);
drift_lon=drifter_data_SVP.Longitude;
drift_lat=drifter_data_SVP.Latitude;
drift_lon(~sel_clean)=nan;
drift_lat(~sel_clean)=nan;
drift_u=drifter_data_SVP.u;
drift_v=drifter_data_SVP.v;
drift_u(~sel_clean)=nan;
drift_v(~sel_clean)=nan;

drift_time=drifter_data_SVP.time';

clear sel_clean startlat endlat startlon endlon topofile lonmin lonmax latmin latmax
