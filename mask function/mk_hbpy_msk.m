%制作华北平原掩膜文件lg_msk，生成的为北纬：南纬，东经：西经格式
clear;clc;
shp_name='G:\GRACE_processing\bj\beijing.shp';
% boundary_hbpy720_1440='G:\GRACE_processing\bj\bj_bound720.mat';
boundary_hbpy721_1440='G:\GRACE_processing\bj\bj_bound721.mat';
savedir_bj_msk='G:\GRACE_processing\bj\bj_msk_721_1440.mat';

shp=shaperead(shp_name);
% hbpy_msk720=shp2mask(shp,boundary_hbpy720_1440,720,1440);
hbpy_msk721=shp2mask(shp,boundary_hbpy721_1440,721,1440);
lg_msk=mask_convert(hbpy_msk721);
save(savedir_bj_msk,'lg_msk');
disp('save successfully');