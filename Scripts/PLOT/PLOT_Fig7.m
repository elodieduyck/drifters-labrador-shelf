% Figure 7 is built from the res table: 

% Compute the amount of drifters that went through box a and b, and which fraction 
% of all drifters that flowed between box a and the section box b this
% corresponds to
box_a=3;
box_b=9;

% Number of drifters from box_a crossing the section of box_b
boxes_section=find(trap_section==trap_section(box_b));

nb_path_section=0;
for i=boxes_section
    nb_path_section=nb_path_section+res.pathnb(res.origin==box_a & res.fate==i);
end

% Number of drifters from box_a crossing box_b
nb_path=res.pathnb(res.origin==box_a & res.fate==box_b)

% Fraction of drifters crossing box b
frac_path=nb_path/nb_path_section;


% Compute median travel time
speed_path_all=res.speedall(res.origin==box_a & res.fate==box_b);
speed_path_median=days(median(vertcat(speed_path_all{:})));

sprintf("Number of drifters from box %d to box %d : %d ",box_a,box_b,nb_path)
sprintf("Percentage of drifters from box %d to section %d crossing box %d : %1.1f percent",box_a,trap_section(box_b), box_b,frac_path*100)
sprintf("Median travel time from box %d to box %d : %1.1f days",box_a, box_b,speed_path_median)


