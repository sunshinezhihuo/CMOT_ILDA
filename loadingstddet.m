%%
%by Qi
function loadingstddet(param)
% clear;clc;
%%loading std detections.txt

data_det_std_path = strcat('./Sequences/',param.yearseq,param.datatype,param.seq,'/det/');

seq_name = 'det.txt';
det_name = strcat(data_det_std_path,seq_name); 
data = load(det_name);
%%
%form CMOT detections struct

fr_end = data(end,1);
for i = 1:fr_end
    ind = find(data(:,1) == i);
%     x{i} = data(ind,3);
%     y{i} = data(ind,4);
%     w{i} = data(ind,5);
%     h{i} = data(ind,6);

    w{i} = data(ind,5);
    h{i} = data(ind,6);
    x{i} = data(ind,3) + round(w{i}/2);
    y{i} = data(ind,4) + round(h{i}/2);
    
    detscore{i} =  data(ind,7);
       
end
detections = struct('x',x,'y',y,'w',w,'h',h,'detscore',detscore);

%% save det.txt to *.mat

out_filename = strcat(param.detpath, param.yearseq,param.seq,'.mat');
if exist(out_filename,'file')
    delete(out_filename);
end
save(out_filename, 'detections');
%%
% the next step is loading cmot detections(.mat)


