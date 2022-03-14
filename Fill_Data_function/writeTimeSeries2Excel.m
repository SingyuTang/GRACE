%将时间序列保存为excel文件
clear;clc;
filepath='G:\GRACE_processing\bj\time_series_grace_2002_2017_bj_original.mat';
savepath='G:\GRACE_processing\bj\time_series_grace_2002_2017_bj_original.xls';
load(filepath);
time_series_save=cat(2,time,time_series*100);
title={'时间','等效水高(cm)'};
xlswrite(savepath,title,1,'A1');
xlswrite(savepath,time_series_save,1,'A2');
display('xls has saved successfully');
