function sg_calculate_global_search_angle_list_csv(angincr,csvfile,cone_search_type)

if nargin < 3
    cone_search_type = 'complete';
end

angincrold = angincr;
angiter = ceil(180/angincr);
if mod(180,angincr) ~= 0
    angincr = 180/angiter;
    fprintf('180 is not divisible by %.3f, adjusting angular increment to %.3f degrees (%d iterations)!\n',angincrold,angincr,angiter);
end

p(1).angincr = angincr;
p(1).angiter = angiter;
p(1).cone_search_type = cone_search_type;
p(1).phi_angincr = angincr;
p(1).phi_angiter = angiter;
o = struct();
o = calculate_cone_angle_list(p,o,1);

writematrix(o.anglist.', csvfile);

end