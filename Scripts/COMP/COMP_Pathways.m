%% Pathways

% Define the 5 sections and 10 boxes used to identify pathways
%% Now making it more legible by keeping only 1 decimal. Will need to check for possible changes

trap_DS=[  -61.99  -56.01  -55.9991  -61.98  -61.99
   66.64   66.99   66.80   66.48   66.64];

trap_NorthLsh_1=[ -64.80  -62.48  -62.26  -64.68  -64.80
   60.30   61.50   61.33   60.17   60.30];
trap_NorthLsh_2=[  -62.48  -60.06  -60.14  -62.26  -62.48
   61.48   61.39   61.21  61.33   61.48];

trap_MidLsh_1=[ -60.49  -58.33  -58.19  -60.34  -60.49
   55.49   56.22   56.12   55.39   55.49];
trap_MidLsh_2=[ -58.33  -57.19  -57.05  -58.19  -58.33
   56.22  56.58   56.45   56.12   56.22];

trap_SouthLsh_1=[ -55.88  -52.85  -52.77  -55.81  -55.88
   52.10   52.76   52.60   52   52.10];
trap_SouthLsh_2=[ -52.85  -50.34  -50.22  -52.75  -52.85
   52.76   53.28   53.15   52.61   52.76];

trap_NL_1=[  -59.44  -48.66  -48.63  -59.54  -59.44
   50.85   47.01   46.84   50.72   50.85];
trap_NL_2=[-48.64  -45.49  -45.26  -48.63  -48.64
   47.01   47.30   47.17   46.85   47.01];
trap_NL_3=[  -45.49  -44.95  -44.64  -45.28  -45.49
   47.30   49.91   49.89   47.17   47.30];

trap_boxes=cat(3,trap_DS,trap_NorthLsh_1,trap_NorthLsh_2,trap_MidLsh_1,trap_MidLsh_2,trap_SouthLsh_1,trap_SouthLsh_2,trap_NL_1,trap_NL_2,trap_NL_3);

% Indicate which box corresponds to which section
trap_section=[1 2 2 3 3 4 4 5 5 5];


% Identify Which drifters goes through the boxes, when they enter and leave

trapped_enter=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_time_enter=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_leave=zeros(size(trap_boxes,3),size(drift_lon,2));
trapped_time_leave=zeros(size(trap_boxes,3),size(drift_lon,2));

for i=1:size(trap_boxes,3)
    trapped_enter(i,:)=sum(inpolygon(drift_lon,drift_lat,trap_boxes(1,:,i),trap_boxes(2,:,i)))>0;
    trapped_leave(i,:)=sum(inpolygon(drift_lon,drift_lat,trap_boxes(1,:,i),trap_boxes(2,:,i)))>0;
    for j=1:size(drift_lon,2)
        if trapped_enter(i,j)>0
      trapped_time_enter(i,j)=find(inpolygon(drift_lon(:,j),drift_lat(:,j),trap_boxes(1,:,i),trap_boxes(2,:,i)),1,'first');
      trapped_time_leave(i,j)=find(inpolygon(drift_lon(:,j),drift_lat(:,j),trap_boxes(1,:,i),trap_boxes(2,:,i)),1,'last');
        end
    end
end


% If more than one box of the section was crossed, need to check crossing
% times to define which boxes the drifters entered and left the section
% from. We also need to pay extra attention that if the drifter circulated
% several times over the shelf, only one of these is taken into account
for i=2:max(trap_section) % section 1 only has 1 box
    nb_box=find(trap_section==i); % which boxes belong to this section
        for k=1:size(drift_lon,2) % go through all the drifters, for both when they entered and left boxes
            if sum(trapped_enter(nb_box,k))>1 
                nb_box_trapped=nb_box(trapped_enter(nb_box,k)>0); % which boxes were crossed?
                % Choose the box that was entered first, while making sure
                % the drifter comes from upstream
                time_previous_serie=max(trapped_time_enter(1:min(nb_box)-1,j));
                if time_previous_serie ~=0
                    [~,idmin]=min(trapped_time_enter(nb_box_trapped(trapped_time_enter(nb_box_trapped,k)>time_previous_serie),k));
                else
                    [~,idmin]=min(trapped_time_enter(nb_box_trapped,k));
                end
                trapped_enter(nb_box_trapped,k)=0;
                trapped_enter(nb_box_trapped(idmin),k)=1;
            end
            if sum(trapped_leave(nb_box,k))>1 % If more than one box of the section was crossed, need to check crossing times
                nb_box_trapped=nb_box(trapped_leave(nb_box,k)>0);
                time_next_serie=trapped_time_leave(max(nb_box)+1:end,k);
                time_next_serie=min(time_next_serie(time_next_serie~=0));
                % Choose the box that left last, while making sure
                % the drifter continues downstream
                if time_next_serie ~=0
                    [~,idmax]=max(trapped_time_leave(nb_box_trapped(trapped_time_leave(nb_box_trapped,k)<time_next_serie),k));
                else
                    [~,idmax]=max(trapped_time_leave(nb_box_trapped,k));
                end
                trapped_leave(nb_box_trapped,k)=0;
                trapped_leave(nb_box_trapped(idmax),k)=1;
            end
        end
end
trapped_time_enter(trapped_enter==0)=0;
trapped_time_leave(trapped_leave==0)=0;


% Build table summarizing the pathways
id_res=1;
res=table;
res.origin=nan;
res.fate=nan;
res.originnb=nan;
res.originid=cell(1,1);
res.fatenb=nan;
res.fateid=cell(1,1);
res.pathnb=nan;
res.pathid=cell(1,1);
res.speedall=cell(1,1);
res.speed=nan;
warning('off','MATLAB:table:RowsAddedExistingVars') % do not display warning that when we add rows 
% we are not assigning values to all variables and that variables are extended with default values when not assigned
for i=1:length(trap_boxes)
    traps_totest=find(trap_section>trap_section(i));
    fill_nb=length(traps_totest);
    res.origin(id_res:id_res+fill_nb-1)=i;
    res.originnb(id_res:id_res+fill_nb-1)=sum(trapped_enter(i,:));
    res.originid(id_res:id_res+fill_nb-1)={find(trapped_enter(i,:))};
    for j=1:length(traps_totest)
        % How many arrive in trap?
        res.fate(id_res+j-1)=traps_totest(j);
        res.fatenb(id_res+j-1)=sum(trapped_enter(traps_totest(j),:));
        res.fateid(id_res+j-1)={find(trapped_enter(traps_totest(j),:))};
        % How many went from origin to fate box
        res.pathnb(id_res+j-1)=sum(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)); % using first crossed box for fate and last crossed box for origin
        res.pathid(id_res+j-1)={find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))};
        % Median time from one trap to the next
        res.speedall(id_res+j-1)={hours(trapped_time_enter(traps_totest(j),find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)))-trapped_time_leave(i,find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))))*6};
        res.speed(id_res+j-1)=days(hours(median(trapped_time_enter(traps_totest(j),find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:)))-trapped_time_leave(i,find(trapped_enter(traps_totest(j),:) & trapped_leave(i,:))))*6));
    end
    id_res=id_res+fill_nb;
end

% Number of drifter used in pathways method
total_drift=[];
for i=1:39
total_drift=[total_drift cell2mat(res.pathid(i))];
end
sprintf('Number of drifters used in method: %d',length(unique(total_drift)))

clear time_next_serie time_previous_serie nb_box_trapped nb_box i j k fill_nb idmin idmax id_res traps_totest trapped_enter trapped_leave
clear trap_DS trap_NorthLsh_1 trap_NorthLsh_2 trap_MidLsh_1 trap_MidLsh_2 trap_SouthLsh_1 trap_SouthLsh_2 trap_NL_1 trap_NL_2 trap_NL_3 
