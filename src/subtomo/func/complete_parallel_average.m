function complete_parallel_average(p,o,s,idx)
%% complete_parallel_average
% A function to count the number of completed cores for the parallel
% average and write the completion file. 
%
% WW 07-2018

  
%% Wait for alignment to finish
    
% Wait until align completion
wait_for_them([p(idx).rootdir,'/',o.commdir],'sg_p_avg',o.n_cores_p_avg,s.wait_time);


%% Complete parallel averaging

% Compile time
compile_subtomo_timings(p,o,idx,'p_avg');

% Update param file
disp([s.cn,' Parallel averaging complete! Updataing parameter file...']);
[p,idx] = update_subtomo_param(s ,p(idx).rootdir, s.paramfilename, p(idx).iteration, p(idx).subtomo_mode, 'p_avg');



% Write completion file
system(['rm -f ',p(idx).rootdir,'/',o.commdir,'/sg_p_avg*']);    % Prevents overrun at next iteration...
system(['rm -f ',p(idx).rootdir,'/',o.commdir,'/sg_f_avg*']);    % Prevents overrun at next step...
system(['rm -f ',p(idx).rootdir,'/',o.commdir,'/complete_stopgap_f_avg']);    % Prevents overrun at next step...
system(['touch ',p(idx).rootdir,'/',o.commdir,'/complete_stopgap_p_avg']);
disp([s.cn,'Parallel averaging complete!!!']);
                        
