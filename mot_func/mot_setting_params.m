%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.

%% Get image lists 
%% Get image lists 
%change---data-----sets-------to-----evaluate-----------
%=============2DMOT2015==============================
%% train
% TUD-Stadtmitte      179
% TUD-Campus          71
% PETS09-S2L1         795
% ETH-Bahnhof        1000
% ETH-Sunnyday        354
% ETH-Pedcross2   ..... 840 837==830
% ADL-Rundle-6        525
% ADL-Rundle-8        654
% KITTI-13            340
% KITTI-17            145
% Venice-2            600
%%
param.yearseq = '2DMOT2015';
param.seq = 'Venice-2';
param.seqmap = 'c2-train.txt';
%=============MOT16==================================
%% train
% MOT16-02
% MOT16-04
% MOT16-05
% MOT16-09
% MOT16-10
% MOT16-11
% MOT16-13
%%
% param.yearseq = 'MOT16';
% param.seq = 'MOT16-13';
% param.seqmap = 'c5-train.txt';
%=============MOT16===================================
%-------------------------------------
param.detpath = './MyDets/';
param.outpath = './Results/';

param.datatype = '/train/';   %train

img_path = strcat('./Sequences/',param.yearseq,param.datatype,param.seq,'/img1/');
img_List = dir(strcat(img_path,'*.jpg'));

% img_path = './Sequences/ETH_Bahnhof/';
% % img_path = '.\Sequences\ETH_Bahnhof\';
% img_List = dir(strcat(img_path,'*.png'));

%% Common parameter
param.label(1,:) = zeros(1,10000);      % �� 10000�� �ΰ�?  ID
param.show_scan = 4;                    
param.new_thr = param.show_scan + 1;    % Temporal window size for tracklet initialization
param.obs_thr = 0.4;           % Threshold for local and global association 
param.type_thr = 0.5;          % Threshold for changing a tracklet type
param.pos_var = diag([30^2 75^2]);      % Covariance used for motion affinity evalutation
param.alpha = 0.25;                     % alpha ?

%% Tracklet confidence 
param.lambda = 1.2;                   % lambda ?
param.atten = 0.85;
param.init_prob = 0.75;                 % Initial confidence 

%% Appearance Model 
param.tmplsize = [64, 32];                           % template size (height, width)
param.Bin = 48;                                      % # of Histogram Bin // HSV Color histogram?
param.vecsize = param.tmplsize(1)*param.tmplsize(2); 
param.subregion = 1;                                
param.subvec = param.vecsize/param.subregion ;       
param.color.type = 'HSV';                            % RGB or HSV



%% Motion model  
% kalman filter parameter
param.Ts = 1; % Frame rates

Ts = param.Ts;
F1 = [1 Ts;0 1];  
Fz = zeros(2,2); 
param.F = [F1 Fz;Fz F1]; % F matrix: state transition matrix 

% Dynamic model covariance
q= 0.05; 

Q1 = [Ts^4 Ts^2;Ts^2 Ts]*q^2;
param.Q = [Q1 Fz;Fz Q1]; 

% Initial Error Covariance
ppp = 5;
param.P = diag([ppp ppp ppp ppp]'); 
param.H = [1 0 0 0;0 0 1 0]; % H matrix: measurement model
param.R = 0.1*eye(2); % Measurement model covariance


%% ILDA parameters
param.use_ILDA = 0; % 1:ILDA, 0: No-ILDA // script �ۿ� �ٽ� ���ϰ� �Ǿ�����
ILDA.n_update = 0;  
ILDA.eigenThreshold = 0.01; 
ILDA.up_ratio = 3;  
ILDA.duration = 5;
ILDA.feat_data = [];
ILDA.feat_label = [];
