%% sg_motl_batch_spline
% A function to batch generate motivelists for a set of splines. 
%
% The input folder should contain a subfolder for each tomogram; each
% folder should be named after the tomogram number. Within each folder
% there should be a set of .cmm file containing tube centers, as picked
% from chimera's volume tracer. Each .cmm file should be named
% [root_name]_[tomo_num]_[obj_number].cmm. Radii can be supplied as a 
% single value or using a three column text file with columns tomo number,
% tube number and radius.
% 
% Points can also be thresholded with respect to tomogram boundaries.
%
% WW 11-2020

%% Inputs

% Input folder
metadata_folder = 'filaments/featureA/';

% Center root name
tracer_root = 'featureA';
tracer_type = 'txt';    % txt or cmm

% Reconstruction list
rlist_name = 'recons_list.txt';

% Distances
dist = 2;    % Distance along filament axis

% Order in Z
order_z = 0;

% Phi angle assignment ('rand' = random, or [offset,rotation] in degrees)
phi_angle_type = 'rand';


% Tomogram dir
tomo_dir = '/fs/pool/pool-engel/201022_Jans_cells_2/bin4_novactf/';
digits = 1;
padding = 10;    % Size of the edge boundary for thresholding; any centers within the boundary are removed.

% Output name
output_name = 'filaments-spline_motl_1.star';


%% Initialize

% Read reconstructin list
rlist = dlmread(rlist_name);
n_tomos = numel(rlist);


% Initialize cell array
motl_cell = cell(n_tomos,1);

      
% Parse numeric format for tomogram names
nfmt = ['%0',num2str(digits),'i'];


%% Generate motls for each tube

for i = 1:n_tomos
    
    % Determine number of tracer files
    tr_dir = dir([metadata_folder,'/',num2str(rlist(i),['%0',num2str(digits),'i']),'/',tracer_root,'_*.',tracer_type]);
    
    % Read tracer
    switch tracer_type
        case 'txt'
            tr = dlmread([metadata_folder,'/',num2str(rlist(i),['%0',num2str(digits),'i']),'/',tr_dir.name]);
            tr_idx = unique(tr(:,1));
            n_tr = numel(tr_idx);
        case 'cmm'
            tr = sg_cmm_read([metadata_folder,'/',tracer_root,'_',num2str(rad_array(j,1)),'_',num2str(rad_array(j,2)),'.cmm']);
    end    

    tomo_cell = cell(n_tr,1);
    
    for j = 1:n_tr

        % Parse points
        switch tracer_type
            case 'txt'
                p_idx = tr(:,1) == tr_idx(j);
                points = tr(p_idx,2:4);
        end

        % Order in Z
        if order_z == 1
            points = sortrows(points,3);
        end
        
        % Add a check for single points clicked by accident in IMOD:
        if size(points,1) <= 1
            continue
        end

        % Get spline positions
        [positions,eulers] = sg_motl_generate_spline_function(points',dist,phi_angle_type);
        n_pos = size(positions,2);
        
        
           
        

        % Parse positions
        x = round(positions(1,:));
        y = round(positions(2,:));
        z = round(positions(3,:));
        x_shift = positions(1,:) - x;
        y_shift = positions(2,:) - y;
        z_shift = positions(3,:) - z;

        % Generate motivelist
        temp_motl = sg_initialize_motl(n_pos);
        temp_motl = sg_motl_fill_field(temp_motl,'tomo_num',rlist(i));
        temp_motl = sg_motl_fill_field(temp_motl,'object',tr_idx(j));
        temp_motl = sg_motl_fill_field(temp_motl,'orig_x',x);
        temp_motl = sg_motl_fill_field(temp_motl,'orig_y',y);
        temp_motl = sg_motl_fill_field(temp_motl,'orig_z',z);
        temp_motl = sg_motl_fill_field(temp_motl,'x_shift',x_shift);
        temp_motl = sg_motl_fill_field(temp_motl,'y_shift',y_shift);
        temp_motl = sg_motl_fill_field(temp_motl,'z_shift',z_shift);
        temp_motl = sg_motl_fill_field(temp_motl,'phi',eulers(1,:));
        temp_motl = sg_motl_fill_field(temp_motl,'psi',eulers(2,:));
        temp_motl = sg_motl_fill_field(temp_motl,'the',eulers(3,:));

        % Threshold list
        % tomo_name = [tomo_dir,'/',num2str(rad_array(j,1),nfmt),'.rec'];
        tomo_name = [tomo_dir,'/',num2str(rlist(i),nfmt),'.rec'];
        temp_motl = sg_motl_check_tomo_edges(tomo_name,temp_motl,padding);

        % Store motl
        tomo_cell{j} = temp_motl;
    end
    
    motl_cell{i} = cat(1,tomo_cell{:});
end

%% Generate complete motl

% Concatenate full motl
motl = cat(1,motl_cell{:});
n_motl = numel(motl);

% Fill subtomo number      
motl = sg_motl_fill_field(motl,'motl_idx',1:n_motl);
motl = sg_motl_fill_field(motl,'subtomo_num',1:n_motl);
motl = sg_motl_fill_field(motl,'halfset','A');
motl = sg_motl_fill_field(motl,'score',0);
motl = sg_motl_fill_field(motl,'class',1);

% Write output
sg_motl_write(output_name,motl);








