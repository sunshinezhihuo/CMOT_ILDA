function [ISO] = mot_non_associated(detections, Y_set, ISO,st_fr,en_fr)
%% Copyright (C) 2014 Seung-Hwan Bae
%% All rights reserved.


for i=st_fr:en_fr
    iso_idx = find(Y_set(i).iso_idx == 1);
    
    ISO.meas(i).x = detections(i).x(iso_idx);
    ISO.meas(i).y = detections(i).y(iso_idx);
    ISO.meas(i).w = detections(i).w(iso_idx);
    ISO.meas(i).h = detections(i).h(iso_idx);

%     lx = detections(i).x(iso_idx);
%     ly = detections(i).y(iso_idx);
%     w = detections(i).w(iso_idx);
%     h = detections(i).h(iso_idx);
%     [cx,cy] = LeftToCenter(lx,ly,h,w);
%     ISO.meas(i).x =cx;
%     ISO.meas(i).y =cy;
%     ISO.meas(i).w =w;
%     ISO.meas(i).h =h;
    
end




end