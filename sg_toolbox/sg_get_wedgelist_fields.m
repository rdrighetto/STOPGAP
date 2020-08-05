function wedgelist_fields = sg_get_wedgelist_fields()
%% get_motl_fields
% A function to return stopgap motivelist fields, types, and whether they 
% are single values or arrays.
%
% WW 05-2018

wedgelist_fields = {'tomo_num',      'num',    'single';...
                    'pixelsize',     'num',    'single';...
                    'tomo_x',        'num',    'single';...
                    'tomo_y',        'num',    'single';...
                    'tomo_z',        'num',    'single';...
                    'z_shift',       'num',    'single';...
                    'tilt_angle',    'num',    'array';...
                    'defocus',       'num',    'array';...
                    'defocus1',      'num',    'array';...
                    'defocus2',      'num',    'array';...
                    'astig_ang',     'num',    'array';...
                    'pshift',        'num',    'array';...
                    'exposure',      'num',    'array';...
                    'voltage',       'num',    'single';...
                    'amp_contrast',  'num',    'single';...
                    'cs',            'num',    'single';...
                    };
