%%将GLDAS格网转为球谐系数(cs_soil,cs_land)
function GLDAS_2_grid2cs(grid_readname,cs_savename)
%grid_readname,第一步计算出来的grid（包含grid_soil,grid_land)所在的完整路径
%cs_savename,转化为cs矩阵（cs_soil,cs_land）所保存的路径
save_dir=cs_savename;
grid_data=load(grid_readname);
soil_water=grid_data.grid_soil;
land_water=grid_data.grid_land;
%load('D:\MATLAB2014b\R2014b\toolbox\GRACE\GLDAS_jiazhou\jiazhou_original.mat');
%[~,~,num_file]=size(soil_water);
%全球格网只留下加州区域

% for i=1:num_file
%     soilwater(:,:,i)=soil_water(:,:,i).*lg_msk;
%     landwater(:,:,i)=land_water(:,:,i).*lg_msk;
% end

cs_soil=gmt_grid2cs(soil_water,60);
cs_land=gmt_grid2cs(land_water,60);

%%扣除背景场
% soil_mean=mean(soil_tem);
% land_mean=mean(land_tem);
% 
% for j =1:num_file
%     cs_soil(j,:,:)=(soil_tem(j,:,:)-soil_mean);
%     cs_land(j,:,:)=(land_tem(j,:,:)-land_mean);
%     
% end

int_year=grid_data.int_year;
int_month=grid_data.int_month;
time=grid_data.time;
lat=grid_data.lat;
lon=grid_data.lon;

save(save_dir,'cs_soil');
save(save_dir,'cs_land','-append');
save(save_dir,'int_year','-append');
save(save_dir,'int_month','-append');
save(save_dir,'time','-append');
save(save_dir,'lat','-append');
save(save_dir,'lon','-append');

clear;
clc;
disp(['Save cs_gldas.mat successfully.']);


