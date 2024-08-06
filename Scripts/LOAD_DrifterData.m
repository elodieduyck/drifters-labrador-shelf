%%%%%%%% Load and combine drifter data %%%%%%%%

drifter_time=datetime(1990,1,1,0,0,0):hours(6):datetime(2023,6,1);

%% EGC drift
% Load EGC Drift data into structure
% Would need to get the nc file and re-load it in the structure, at the
% moment issue is that the nc file does not have the drogue info
% load([data_folder 'Drifters\EGCDrift\final\tables\drifter_data_EGCDrift_6h.mat']);

% Check how to load the nc data
ncfilename=[data_folder 'EGCDrift\EGCDrIFT_140819-151122_6h.nc'];
% ncdisp(ncfilename);

time_EGC=datetime(1950,1,1)+days(ncread(ncfilename,'TIME'));
idtime_start=find(ismember(drifter_time,time_EGC),1,'first');
idtime_end=find(ismember(drifter_time,time_EGC),1,'last');

% Structure
drifter_data_EGC=struct;
drifter_data_EGC.time=drifter_time;
drifter_data_EGC.IdBuoy=[ncread(ncfilename,'IMEI_SVP'); ncread(ncfilename,'IMEI_SVPS')];

drifter_data_EGC.Longitude_raw=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.Latitude_raw=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.u_raw=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.v_raw=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.SST=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.undrogued=zeros(length(drifter_time),length(drifter_data_EGC.IdBuoy));

drifter_data_EGC.Longitude_raw(idtime_start:idtime_end,:)=[ncread(ncfilename,'LON_SVP') ncread(ncfilename,'LON_SVPS')];
drifter_data_EGC.Latitude_raw(idtime_start:idtime_end,:)=[ncread(ncfilename,'LAT_SVP') ncread(ncfilename,'LAT_SVPS')];
drifter_data_EGC.u_raw(idtime_start:idtime_end,:)=[ncread(ncfilename,'U_SVP') ncread(ncfilename,'U_SVPS')];
drifter_data_EGC.v_raw(idtime_start:idtime_end,:)=[ncread(ncfilename,'V_SVP') ncread(ncfilename,'V_SVPS')];
drifter_data_EGC.SST(idtime_start:idtime_end,:)=[ncread(ncfilename,'SST_SVP') ncread(ncfilename,'SST_SVPS')];
drifter_data_EGC.undrogued(idtime_start:idtime_end,:)=[ncread(ncfilename,'DROGUE_SVP') ncread(ncfilename,'DROGUE_SVPS')];

% Filter with 25h Butterworth filter
F=1/(25*3600); Fs=1/(6*3600); % 25hr cutoff
[y,x]=butter(5, F/(Fs/2));

drifter_data_EGC.Longitude=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.Latitude=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.u=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));
drifter_data_EGC.v=nan(length(drifter_time),length(drifter_data_EGC.IdBuoy));

for i=1:length(drifter_data_EGC.IdBuoy)
        % 25hr butterworth filter.
        % first interpolate because the filter only deals with finite data: Use
        % fill missing and later on replace the nan values
        lon_temp=fillmissing(drifter_data_EGC.Longitude_raw(:,i),'linear');
        lat_temp=fillmissing(drifter_data_EGC.Latitude_raw(:,i),'linear');
        lon_temp=filtfilt(y,x,lon_temp);
        lat_temp=filtfilt(y,x,lat_temp);
        % replace original nans by nans
        lon_temp(isnan(drifter_data_EGC.Longitude_raw(:,i)))=NaN;
        lat_temp(isnan(drifter_data_EGC.Latitude_raw(:,i)))=NaN;

        % Compute speeds from filtered trajectories
        complex_sp=latlon2uv(datenum(drifter_data_EGC.time),lat_temp,lon_temp);
        u_temp=real(complex_sp);
        v_temp=imag(complex_sp);

        % arrange in structure
        drifter_data_EGC.Longitude(:,i)=lon_temp;
        drifter_data_EGC.Latitude(:,i)=lat_temp;
        drifter_data_EGC.u(:,i)=u_temp;
        drifter_data_EGC.v(:,i)=v_temp;     

end

clear u_temp v_temp lon_temp lat_temp complex_sp i F Fs x y ncfilename idtime_end idtime_start time_EGC

%% GDP

% If loading from GDP dataset
% Load data
% buoydata=[load([data_folder 'Drifters\GDP\dat_files\buoydata_1_5000.dat']);load([data_folder 'Drifters\GDP\dat_files\buoydata_5001_10000.dat']);load([data_folder 'Drifters\GDP\dat_files\buoydata_10001_15000.dat']);load([data_folder 'Drifters\GDP\dat_files\buoydata_15001_may23.dat'])];
% buoydata(buoydata==999.9990)=NaN;
% buoydata(buoydata(:,6)>180,6)=buoydata(buoydata(:,6)>180,6)-360;
% 
% meta1=readtable([data_folder 'Drifters\GDP\dat_files\dirfl_1_5000.dat'],'ReadVariableNames',false,'Format','%f %f %f %s %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f');
% meta2=readtable([data_folder 'Drifters\GDP\dat_files\dirfl_5001_10000.dat'],'ReadVariableNames',false,'Format','%f %f %f %s %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f');
% meta3=readtable([data_folder 'Drifters\GDP\dat_files\dirfl_10001_15000.dat'],'ReadVariableNames',false,'Format','%f %f %f %s %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f');
% meta4=readtable([data_folder 'Drifters\GDP\dat_files\dirfl_15001_may23.dat'],'ReadVariableNames',false,'Format','%f %f %f %s %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f %f %{yyyy/MM/dd}D %{HH:mm}D %f');
% metadata=[meta1;meta2;meta3;meta4];
% metadata.Properties.VariableNames = {'ID','WMO','Program','Type','DDate','DHour','DLat','DLon','EDate','EHour','Elat','ELon','DODate','DOHour','DeathType'};
% metadata.Type=string(metadata.Type);
% 
% % Select drifters in Subpolar North Atlantic
% poly=[-80 -80 5 5 -80;45 80 80 45 45];
% idbuoy_GDP=[];
% f=waitbar(0,'still busyyyyy');
% for i=1:length(buoydata)
%     waitbar(i/buoydata,f)
%     if ismember(buoydata(i,1),idbuoy_GDP)==0
%         if inpolygon(buoydata(i,6),buoydata(i,5),poly(1,:),poly(2,:)) % & buoydata(i,4)>=1998
%            idbuoy_GDP=[idbuoy_GDP,buoydata(i,1)];
%         end
%     end 
% end
% 
% buoy_GDP=cell(1,length(idbuoy_GDP));
% meta_GDP=cell(1,length(idbuoy_GDP));
% f=waitbar(0,'still busyyyyy');
% for i=1:length(idbuoy_GDP)
%     waitbar(i/length(idbuoy_GDP),f)
%     buoy_GDP(i)={buoydata(ismember(buoydata(:,1),idbuoy_GDP(i)),:)};
%     meta_GDP{i}=metadata(ismember(metadata{:,1},idbuoy_GDP(i)),:);
% end
% buoy_GDP=cellfun(@(x) table(x(:,1),datetime(x(:,4),x(:,2),floor(x(:,3)),(x(:,3)-floor(x(:,3)))*24,0,0),x(:,6),x(:,5),x(:,7),nan(length(x(:,1)),1),x(:,8),x(:,9),'VariableNames',{'Platform','Locdate','Longitude','Latitude','SST','Salinity','u','v'}),buoy_GDP,'UniformOutput',0);
% 
% save([data_folder + "Drifters\GDP\processing\buoyGDP.mat"],"buoy_GDP");
% save([data_folder + "Drifters\GDP\processing\metaGDP.mat"],"meta_GDP");

clear idbuoy_GDP buoydata metadata meta1 meta2 meta3 meta4 f poly

% If loading existing
load([data_folder + "GDP\buoyGDP.mat"],"buoy_GDP");
load([data_folder + "GDP\metaGDP.mat"],"meta_GDP");

% Create drifter data structure

nb_buoy=length(buoy_GDP);

drifter_data_GDP=struct();
drifter_data_GDP.IdBuoy=strings(1,nb_buoy);
drifter_data_GDP.Program=strings(1,nb_buoy);

drifter_data_GDP.time=drifter_time;
drifter_data_GDP.Longitude=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.Latitude=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.u=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.v=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.Longitude_raw=nan(length(drifter_time),nb_buoy); % We filter to get the 25h low passed trajectories but still save the originals
drifter_data_GDP.Latitude_raw=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.u_raw=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.v_raw=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.SST=nan(length(drifter_time),nb_buoy);
drifter_data_GDP.undrogued=zeros(length(drifter_time),nb_buoy);

% set filter:
F=1/(25*3600); Fs=1/(6*3600); % 25hr cutoff
[y,x]=butter(5, F/(Fs/2));

for i=1:nb_buoy
    % % set idtime for arranging in structure organized by drifter ID
    idtime_start_new=find(ismember(drifter_time,buoy_GDP{i}.Locdate),1,'first');
    idtime_start_old=find(ismember(buoy_GDP{i}.Locdate,drifter_time),1,'first');
    idtime_end_new=find(ismember(drifter_time,buoy_GDP{i}.Locdate),1,'last');
    idtime_end_old=find(ismember(buoy_GDP{i}.Locdate,drifter_time),1,'last');
    if length(isfinite(buoy_GDP{i}.Longitude))>15 % filter doesn't work if shorter, but also not very useful to have such short segments, we can just ignore them for filtering
        drifter_data_GDP.IdBuoy(i)=string(meta_GDP{i}.ID);
        % 25hr butterworth filter.
        % first interpolate because the filter only deals with finite data: Use
        % fill missing and later on replace the nan values
        lon_temp=fillmissing(buoy_GDP{i}.Longitude,'linear');
        lat_temp=fillmissing(buoy_GDP{i}.Latitude,'linear');
        lon_temp=filtfilt(y,x,lon_temp);
        lat_temp=filtfilt(y,x,lat_temp);
        % replace original nans by nans
        lon_temp(isnan(buoy_GDP{i}.Longitude))=NaN;
        lat_temp(isnan(buoy_GDP{i}.Longitude))=NaN;

        % Compute speeds from filtered trajectories
        % complex_sp=latlon2uv(datenum(buoy_NOAA{i}.Locdate(isfinite(lon_temp))),lat_temp(isfinite(lon_temp)),lon_temp(isfinite(lon_temp)));
        complex_sp=latlon2uv(datenum(buoy_GDP{i}.Locdate),lat_temp,lon_temp);
        u_temp=real(complex_sp);
        v_temp=imag(complex_sp);

        % arrange in structure
        drifter_data_GDP.Longitude(idtime_start_new:idtime_end_new,i)=lon_temp(idtime_start_old:idtime_end_old);
        drifter_data_GDP.Latitude(idtime_start_new:idtime_end_new,i)=lat_temp(idtime_start_old:idtime_end_old);
        drifter_data_GDP.u(idtime_start_new:idtime_end_new,i)=u_temp(idtime_start_old:idtime_end_old);
        drifter_data_GDP.v(idtime_start_new:idtime_end_new,i)=v_temp(idtime_start_old:idtime_end_old);


    end
    % Keep the raw data for comparisons
    % Here we just lookup the data and arrange them in the structure / no
    % interpolation
    drifter_data_GDP.Longitude_raw(idtime_start_new:idtime_end_new,i)=buoy_GDP{i}.Longitude(idtime_start_old:idtime_end_old);
    drifter_data_GDP.Latitude_raw(idtime_start_new:idtime_end_new,i)=buoy_GDP{i}.Latitude(idtime_start_old:idtime_end_old);
    drifter_data_GDP.u_raw(idtime_start_new:idtime_end_new,i)=buoy_GDP{i}.u(idtime_start_old:idtime_end_old);
    drifter_data_GDP.v_raw(idtime_start_new:idtime_end_new,i)=buoy_GDP{i}.v(idtime_start_old:idtime_end_old);

    % Other data
    drifter_data_GDP.SST(idtime_start_new:idtime_end_new,i)=buoy_GDP{i}.SST(idtime_start_old:idtime_end_old);
    drifter_data_GDP.undrogued(drifter_time>=meta_GDP{i}.DODate,i)=1;

end

% Give program names for identified drifters
dep_time=[datetime(2019,12,4); datetime(2020,2,28); datetime(2020,2,29); datetime(2020,3,4); datetime(2020,8,23); datetime(2020,8,24); datetime(2021,8,15);  datetime(2021,8,20); datetime(2021,9,16); datetime(2021,9,17); datetime(2021,9,18) ]; 

for i=1:nb_buoy
    if ismember(meta_GDP{i}.DDate,dep_time(1)) && meta_GDP{i}.DLat>59.75 && meta_GDP{i}.DLat<70       
        drifter_data_GDP.Program(i)="TERIFIC1";
    elseif ismember(meta_GDP{i}.DDate,dep_time(2:4)) && meta_GDP{i}.DLat>59.75 && meta_GDP{i}.DLat<70       
        drifter_data_GDP.Program(i)="TERIFIC2";
    elseif ismember(meta_GDP{i}.DDate,dep_time(5:6)) && meta_GDP{i}.DLat>59.75 && meta_GDP{i}.DLat<70       
        drifter_data_GDP.Program(i)="TERIFIC3";
    elseif ismember(meta_GDP{i}.DDate,dep_time(7:8)) && meta_GDP{i}.DLat>59.75 && meta_GDP{i}.DLat<70       
        drifter_data_GDP.Program(i)="TERIFIC4";
    elseif ismember(meta_GDP{i}.DDate,dep_time(9:11)) && meta_GDP{i}.DLat>59.75 && meta_GDP{i}.DLat<70       
        drifter_data_GDP.Program(i)="TERIFIC5";
    else
        drifter_data_GDP.Program(i)="GDP";
    end
end


clear u_temp v_temp lon_temp lat_temp complex_sp i F Fs x y nb_buoy idtime_start_new idtime_start_old idtime_end_new idtime_end_old buoy_GDP meta_GDP dep_time

%% Combine

drifter_data_SVP=struct;
drifter_data_SVP.time=drifter_time;
drifter_data_SVP.IdBuoy=[drifter_data_GDP.IdBuoy drifter_data_EGC.IdBuoy'];
drifter_data_SVP.Program=[drifter_data_GDP.Program repmat("EGC-DrIFT",length(drifter_data_EGC.IdBuoy),1)'];
drifter_data_SVP.Longitude=[drifter_data_GDP.Longitude drifter_data_EGC.Longitude];
drifter_data_SVP.Latitude=[drifter_data_GDP.Latitude drifter_data_EGC.Latitude];
drifter_data_SVP.u=[drifter_data_GDP.u drifter_data_EGC.u];
drifter_data_SVP.v=[drifter_data_GDP.v drifter_data_EGC.v];
drifter_data_SVP.SST=[drifter_data_GDP.SST drifter_data_EGC.SST];
drifter_data_SVP.undrogued=[drifter_data_GDP.undrogued drifter_data_EGC.undrogued];

% Identify gaps longer than 30 days
drifter_data_SVP.gap=zeros(length(drifter_data_SVP.time),length(drifter_data_SVP.IdBuoy));
gap30=NaN(length(drifter_data_SVP.IdBuoy),1);
for i=1:length(drifter_data_SVP.IdBuoy)
    % detect gaps
    for j=find(isfinite(drifter_data_SVP.Latitude(:,i)),1,'first'):length(drifter_data_SVP.time)-1
        if isfinite(drifter_data_SVP.Latitude(j,i))
            for k=j+1:length(drifter_data_SVP.time) % find next finite element
                if isfinite(drifter_data_SVP.Latitude(k,i))
                    gap_diff=drifter_data_SVP.time(k)-drifter_data_SVP.time(j);
                    break
                end
            end
            if days(gap_diff)>30
                gap30(i)=j;
                break
            end
        end
    end
end
for i=1:length(drifter_data_SVP.IdBuoy)
    if isfinite(gap30(i))
        drifter_data_SVP.gap(gap30(i):end,i)=1;
    end
end

clear gap30 i j k gap_diff 
%% Save combined drifter dataset or directly use structure for the computations

save([data_folder+ "drifter_data_SVP_6h.mat"],'drifter_data_SVP','-v7.3');

%% Without filter
% no filt

drifter_data_SVP_nofilt=struct;
drifter_data_SVP_nofilt.time=drifter_time;
drifter_data_SVP_nofilt.IdBuoy=[drifter_data_GDP.IdBuoy drifter_data_EGC.IdBuoy'];
drifter_data_SVP_nofilt.Program=[drifter_data_GDP.Program repmat("EGC-DrIFT",length(drifter_data_EGC.IdBuoy),1)'];
drifter_data_SVP_nofilt.Longitude=[drifter_data_GDP.Longitude_raw drifter_data_EGC.Longitude_raw];
drifter_data_SVP_nofilt.Latitude=[drifter_data_GDP.Latitude_raw drifter_data_EGC.Latitude_raw];
drifter_data_SVP_nofilt.u=[drifter_data_GDP.u_raw drifter_data_EGC.u_raw];
drifter_data_SVP_nofilt.v=[drifter_data_GDP.v_raw drifter_data_EGC.v_raw];
drifter_data_SVP_nofilt.SST=[drifter_data_GDP.SST drifter_data_EGC.SST];
drifter_data_SVP_nofilt.undrogued=[drifter_data_GDP.undrogued drifter_data_EGC.undrogued];

save([data_folder + "drifter_data_SVP_6h_nofilt.mat"],'drifter_data_SVP_nofilt','-v7.3');


clear drifter_data_SVP drifter_data_EGC drifter_data_GDP drifter_time drifter_data_SVP_nofilt