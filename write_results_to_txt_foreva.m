
%%

results = load(strcat(param.outpath,'cmot_',param.use_ILDA,'_',param.yearseq,param.seq,'_tracking_results.mat'));
% results = load(strcat(param.outpath,'cmot_','_',param.yearseq,param.seq,'_tracking_results.mat'));

cpos = results.all_mot.cpos;

lpos = results.all_mot.lpos;
% fprintf('%d\n',size(lpos{1}));%see the size of coordinate of left_top corner in frame1
lab = results.all_mot.lab;
size = results.all_mot.size;
num =1;

%default
eva_fr = frame_end;

% ETH-Pedcross2
% eva_fr = 830;

for fr = 1:eva_fr
    fprintf('fr:%d\n',fr); %show the numbers of frames
    l_t = lpos{fr};  % left_top corner
    w_h = size{fr}; % the width and height of the target
    label = lab{fr};
    for i = 1:length(label)
        dres.fr(num)= fr;
        dres.id(num) = label(i);
        dres.x(num) = l_t(1,i);
        dres.y(num) = l_t(2,i);
        dres.w(num)= w_h(1,i);
        dres.h(num) = w_h(2,i);
        num = num + 1;
    end
end
num = max(dres.id);

% filename = strcat('/home/qi/projects/changeWorks/CMOT_HCF5/Results/TUD-Stadtmitte.txt');
filename = strcat(param.outpath,param.seq,'.txt');

if exist(filename,'file')
    delete(filename);
end
fid = fopen(filename, 'w');
N = numel(dres.x);
for i = 1:N
%         fprintf(fid, '%d,%d,%f,%f,%f,%f,%d,%d,%d,%d\n', ...
   switch param.yearseq
       case '2DMOT2015'
            fprintf(fid, '%d,%d,%g,%g,%g,%g,%d,%d,%d,%d\n', ...
                dres.fr(i), dres.id(i), dres.x(i), dres.y(i), dres.w(i), dres.h(i), -1, -1, -1, -1);
       case 'MOT16'
            fprintf(fid, '%d,%d,%g,%g,%g,%g,%d,%d,%d,%d\n', ...
                dres.fr(i), dres.id(i), dres.x(i), dres.y(i), dres.w(i), dres.h(i), -1, -1, -1, -1);
        otherwise
        error('Please say your yearseq.')
   end
end
fclose(fid);
