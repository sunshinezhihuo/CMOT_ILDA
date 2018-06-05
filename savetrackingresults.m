%% Save tracking results

%different methods switch        
out_filename = strcat(param.outpath, 'cmot_',param.use_ILDA,'_',param.yearseq,param.seq,'_tracking_results.mat');
% out_filename = strcat(param.outpath, 'cmot_','_',param.yearseq,param.seq,'_tracking_results.mat');
    
if exist(out_filename,'file')
    delete(out_filename);
end

% if exist(out_filename,'file')
%     delete(out_filename);
% end

save(out_filename, 'all_mot');