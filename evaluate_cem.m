% --------------------------------------------------------
% MDP Tracking
% Copyright (c) 2015 CVGL Stanford
% Licensed under The MIT License [see LICENSE for details]
% Written by Yu Xiang
% --------------------------------------------------------

%%
function evaluate_cem(param)

resDir = fullfile('Results',filesep);   %find the tracking results.setting the name by person

dataDir = fullfile('Sequences',param.yearseq,'train',filesep);
evaluateTracking(param.seqmap, resDir, dataDir);

% resDir = fullfile('Results',filesep);   %find the tracking results.setting the name by person
% 
% dataDir = fullfile('Sequences',param.yearseq,'test',filesep);
% evaluateTracking(param.seqmap, resDir, dataDir);

end