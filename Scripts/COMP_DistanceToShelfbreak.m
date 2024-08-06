%% Compute distance between drifters and shelf boundary
% This script computes the minimum distance between drifters and the
% shelf boundary at any time
% dist_shelf is the minimum distance of a drifter to the shelf at a given
% time in km
% shelf_km_drift is the point of the shelf that is closest to the drifter
% at that time, given in km from the shelf boundary starting point
[lonmin, lonmax, latmin, latmax]=deal(-70, -20, 40, 70);

dist_shelf=nan(size(drift_lon));
dist_shelf_temp=nan(length(pts_shelf),1);
shelf_km_drift=nan(size(drift_lon));

f=waitbar(0,"Computing dist shelf");

for k=1:size(drift_lon,2)
    waitb=waitbar(k/size(drift_lon,2),f);
    for j=1:length(drift_time) 
         if drift_lon(j,k) < lonmax && drift_lon(j,k) > lonmin && drift_lat(j,k) < latmax && drift_lat(j,k) > latmin   
            for i=1:length(pts_shelf)
                dist_shelf_temp(i)=m_lldist([drift_lon(j,k);pts_shelf(1,i)'],[drift_lat(j,k);pts_shelf(2,i)']);
            end
            [nb,id]=min(dist_shelf_temp);
            shelf_km_drift(j,k)=shelf_km(id);

            % Check if the drifter is on or off the shelf for the sign of
            % dist_shelf
            if inpolygon(drift_lon(j,k),drift_lat(j,k),shelf_poly(1,:),shelf_poly(2,:)) % off-shelf
                dist_shelf(j,k)=nb;
            else % on-shelf
                dist_shelf(j,k)=-nb;
            end
         end
    end  
end
close(waitb)

clear dist_shelf_temp nb id f waitb
