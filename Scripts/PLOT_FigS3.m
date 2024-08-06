% Figure S4 is built from the res table in the same way as figure 7: 

box_a=7;
box_b=10;

% Compute amount and fraction of drifters that flowed between box a and 
% the section of box b that went through box b

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
