%% Robust Online Multi-Object Tracking based on Tracklet Confidence 
% and Online Discriminative Appearance Learning (CVPR2014)
% Last updated date: 2014. 07. 27
% Copyright (C) 2014 Seung-Hwan Bae
% All rights reserved.
%%
clc;
clear all
base = [pwd, '/'];
addpath(genpath(base));

mot_setting_params; % setting parameters

disp('Loading detections...');
% data_path = './Det/';
% seq_name = 'ETH_Bahnhof_Demo_Det.mat';
% file_name = strcat(data_path,seq_name); 
% load(file_name); 
%% loading detection results 

if ~exist(param.detpath);mkdir(param.detpath);end;

detfilename = strcat(param.detpath,param.yearseq,param.seq,'.mat');
if exist(detfilename,'file')
    delete(detfilename);
end
loadingstddet(param); %change .txt to .mat, perform once is ok
loadcmotdet;

% load detections [x,y,w,h] (left top?=>center position) / score�� �� ����...? ground-truth �ΰ�? ���� �Ǵ°�?


% 1:ILDA, 0: No-ILDA (faster)
% To use ILDA, refer to README.

% param.use_ILDA = 1; 
param.use_ILDA = 0;

frame_start = 1;
if length(img_List) > 10
    frame_end = length(detections);
else
    frame_end = 10;    
end

All_Eval = [];
cct = 0;
Trk = []; 
Trk_sets = []; 
all_mot =[];

%% Initiailization Tracklet
tstart1 = tic;
init_frame = frame_start + param.show_scan;

for i=1:init_frame
    Obs_grap(i).iso_idx = ones(size(detections(i).x));
    Obs_grap(i).child = []; 
    Obs_grap(i).iso_child =[];
end


[Obs_grap] = mot_pre_association(detections,Obs_grap,frame_start,init_frame);
st_fr = 1;
en_fr = init_frame;

for fr = 1:init_frame
    filename = strcat(img_path,img_List(fr).name);
    rgbimg = imread(filename);
    init_img_set{fr} = rgbimg;
end

[Trk,param,Obs_grap] = MOT_Initialization_Tracklets(init_img_set,Trk,detections,param,...
            Obs_grap,init_frame);
        
%% Tracking 
disp('Tracking objects...');   
% loading pictures
for fr = init_frame+1:frame_end
    % load an image
    filename = strcat(img_path,img_List(fr).name);
    rgbimg = imread(filename);
    init_img_set{fr} = rgbimg;

    % Local Association // confidence �� ���� tracklets�� ���� local association ����
    [Trk, Obs_grap, Obs_info] = MOT_Local_Association(Trk, detections, Obs_grap, param, ILDA, fr, rgbimg);
    
    
    % Global Association // Local association �̿��� low conf tracklets�� ���� global association ����
    [Trk, Obs_grap] = MOT_Global_Association(Trk, Obs_grap, Obs_info, param, ILDA, fr);
    
    
    % Tracklet Confidence Update // In the paper, confidence�� ���� update�ȴٰ� ��, ��ͺ��� ������Ʈ �ص� ��� �����?
    [Trk] = MOT_Confidence_Update(Trk,param,fr, param.lambda); % equation 2�� ���� �� ��� update.
    [Trk] = MOT_Type_Update(rgbimg,Trk,param.type_thr,fr); % What is the type?
    
    
    % Tracklet State Update & Tracklet Model Update
    [Trk] = MOT_State_Update(Trk, param, fr);
    
    
    % New Tracklet Generation 
    [Trk, param, Obs_grap] = MOT_Generation_Tracklets(init_img_set,Trk,detections,param,...
    Obs_grap,fr);

    % Incremental subspace learning
    if param.use_ILDA % IF not ILDA , �ʱ��� LDA�� ������ ���.
        [ILDA] = MOT_Online_Appearance_Learning(rgbimg, img_path, img_List, fr, Trk, param, ILDA);
    end
    
    
    % Tracking Results
    [Trk_sets] = MOT_Tracking_Results(Trk,Trk_sets,fr);
    disp([sprintf('Tracking:Frame_%04d',fr)]);
end

%%
disp('Tracking done...');
TotalTime = toc(tstart1);
% AverageTime = TotalTime/(frame_start + frame_end);
AverageTime = TotalTime/(frame_end - frame_start + 1);
fps = (frame_end - frame_start + 1)/TotalTime;
%% Draw Tracking Results
% out_path = '.\Results\ETH_Bahnhof\';
% out_path = './Results/ETH_Bahnhof/';
out_path = strcat(param.outpath,param.yearseq,'_',param.seq,'/');

DrawOption.isdraw = 1;
DrawOption.iswrite = 1;
DrawOption.new_thr = param.new_thr;

% Box colors indicate the confidences of tracked objects
% High (Red)-> Low (Blue)
[all_mot] = MOT_Draw_Tracking(Trk_sets, out_path, img_path, img_List, DrawOption); 
close all;
disp([sprintf('Average running time:%.3f(sec/frame)', AverageTime)]);
disp([sprintf('Frame rate:%.3f(frame/sec)', fps)]);
%% Save tracking results
% save tracking results to .mat
savetrackingresults;

%% Evaluate
% .mat==>.txt https://motchallenge.net/instructions/
write_results_to_txt_foreva;    

%%
%evaluate
evaluate_cem(param);
% out_path = './Results/';
% % out_path = '.\Results\';
% out_filename = strcat(out_path, 'cmot_tracking_results.mat');
% save(out_filename, 'all_mot');

