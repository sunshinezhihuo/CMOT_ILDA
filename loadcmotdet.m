%%
%loadcmotdet
seq_name = strcat(param.yearseq,param.seq,'.mat');
file_name = strcat(param.detpath,seq_name); 
load(file_name);