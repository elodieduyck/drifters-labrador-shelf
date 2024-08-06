%% Map where drifters get in and out
% We identify drifters that cross the shelf boundary as well as whether that is 
% on or off shelf, and where along the shelf it occurs

out_k=[]; % id of drifters that cross off shelf
out_km=[]; % km at which these drifters cross
in_k=[]; % id of drifters that cross on shelf
in_km=[]; % km at which these drifters cross

% temporary values
in_time=[];
out_time=[];

for k=1:size(drift_lon,2)
    % we find crossing times by identifying where the dist_shelf changes
    % sign, and store the drifter id and crossing km. Saved crossing times
    % correspond to the ping just after crossing
    % + to - : Crossing onshore
    in_time_temp=find(dist_shelf(1:end-1,k)>0 & dist_shelf(2:end,k) < 0);
    in_time_temp=in_time_temp(drift_lon(in_time_temp,k)<-42); % avoid issues with polygon limits;
    in_km=[in_km;shelf_km_drift(in_time_temp,k)];
    in_time=[in_time; in_time_temp];
    % - to + : Crossing offshore
    out_time_temp=find(dist_shelf(1:end-1,k)<0 & dist_shelf(2:end,k) > 0);
    out_time_temp=out_time_temp(drift_lon(out_time_temp,k)<-42); % avoid issues with polygon limit;
    out_km=[out_km; shelf_km_drift(out_time_temp,k)];
    out_time=[out_time; out_time_temp];
    if ~isempty(out_time_temp)
        out_k=[out_k; k.*ones(length(out_time_temp),1)]; % Allows to find which drifter is crossing
    end
    if ~isempty(in_time_temp)
        in_k=[in_k; k.*ones(length(in_time_temp),1)];
    end
end

clear k j  in_time_temp out_time_temp
