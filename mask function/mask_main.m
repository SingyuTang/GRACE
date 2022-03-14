%% 制作掩膜数据(mask)
% % % % % % % %
clear;clc;
shp_China_name='G:\区划\省.shp';
% shp=shaperead(shp_China_name);
% %北京、天津、河北、山东、河南、安徽、江苏的边界文件（.mat文件，与bln格式相同）
% boundary_bj_dir='G:\Auxiliary function\result\boundary\beijing.mat';
% boundary_tj_dir='G:\Auxiliary function\result\boundary\tianjin.mat';
% boundary_hb_dir='G:\Auxiliary function\result\boundary\hebei.mat';
% boundary_sd_dir='G:\Auxiliary function\result\boundary\shandong.mat';
% boundary_hn_dir='G:\Auxiliary function\result\boundary\henan.mat';
% boundary_ah_dir='G:\Auxiliary function\result\boundary\anhui.mat';
% boundary_js_dir='G:\Auxiliary function\result\boundary\jiangsu.mat';


%华北平原一般通常是包括北京、天津、河北、山东、河南、安徽、江苏这7省市
%由shp文件生成mat文件,制作其对应的mask
shp_beijing=shp(1);
shp_tianjin=shp(2);
shp_hebei=shp(3);
shp_shandong=shp(16);
shp_henan=shp(17);
shp_anhui=shp(13);
shp_jiangsu=shp(11);
%xx_msk为掩膜数据，由shp2mask输出的格式都为西经：东经格式
bj_msk=shp2mask(shp_beijing,boundary_bj_dir,720,1440);
tj_msk=shp2mask(shp_tianjin,boundary_tj_dir,720,1440);
hb_msk=shp2mask(shp_hebei,boundary_hb_dir,720,1440);
sd_msk=shp2mask(shp_shandong,boundary_sd_dir,720,1440);
hn_msk=shp2mask(shp_henan,boundary_hn_dir,720,1440);
ah_msk=shp2mask(shp_anhui,boundary_ah_dir,720,1440);
js_msk=shp2mask(shp_jiangsu,boundary_js_dir,720,1440);
%制作华北地区的mask
hbpy_msk_720_1440=bj_msk+tj_msk+hb_msk+sd_msk+hn_msk+ah_msk+js_msk;%制作华北平原掩膜数据(mask)并保存
lg_msk=mask_convert(hbpy_msk_720_1440);%转换为0-360格式，必须保证与grid_data格式相同
save_dir_hbpymsk='G:\Auxiliary function\result\msk_file\huabei_msk_720_1440.mat';
save(save_dir_hbpymsk,'lg_msk');
disp('save successfully');
clear;clc;

%制作北京的mask
clear;clc;
shp_China_name='G:\区划\省.shp';
shp=shaperead(shp_China_name);
shp_beijing=shp(1);
boundary_bj_dir='G:\Data\boundary\beijing.mat';
bj_msk_180_360=shp2mask(shp_beijing,boundary_bj_dir,180,360);
lg_msk=mask_convert(bj_msk_180_360);%转换为0-360格式，必须保证与grid_data格式相同
savedir_bj_msk='G:\Data\msk_file\bj_msk_180_360.mat';
save(savedir_bj_msk,'lg_msk');
disp('save successfully');