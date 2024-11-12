% Figure 7 is built from the res table: 

% Compute the amount of drifters that went through box a and b, and which fraction 
% of all drifters that flowed between box a and the section box b this
% corresponds to
box_a_name="trap_NLsh_sh";
box_b_name="trap_NL_fp";
box_a=find(trap_boxes_names==box_a_name);
box_b=find(trap_boxes_names==box_b_name);

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

sprintf("Number of drifters from box %s to box %s : %d ",box_a_name,box_b_name,nb_path)
sprintf("Percentage of drifters from box %s to section %d crossing box %s : %1.1f percent",box_a_name,trap_section(box_b), box_b_name,frac_path*100)
sprintf("Median travel time from box %s to box %s : %1.1f days",box_a_name, box_b_name,speed_path_median)


