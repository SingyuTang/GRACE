% 绘制华北地区水资源变化时序图,选择不同模型
clear;clc;
addpath('G:\Auxiliary function\GLDAS function\');
msk_hbpy='G:\Data\msk_file\huabei_msk.mat';%grid_data格式

%计算GLDAS 陆表水变化和土壤水变化时间序列，单位mm

GLDAS_get_time_series('G:\result\GLDAS\CLM\grid_swenson_300_025_land_GLDAS_CLM_10_200204_201608.mat',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_clm_land','GLDAS');
GLDAS_get_time_series('G:\result\GLDAS\CLM\grid_swenson_300_025_soil_GLDAS_CLM_10_200204_201608.mat',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_clm_soil','GLDAS');

GLDAS_get_time_series('G:\result\GLDAS\MOSAIC\grid_swenson_300_025_land_GLDAS_MOSAIC_10_200204_201812',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_mosaic_land','GLDAS');
GLDAS_get_time_series('G:\result\GLDAS\MOSAIC\grid_swenson_300_025_soil_GLDAS_MOSAIC_10_200204_201812',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_mosaic_soil','GLDAS');

GLDAS_get_time_series('G:\result\GLDAS\NOAH10\grid_swenson_300_025_land_GLDAS_NOAH10_10_200001_202102',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_noah10_land','GLDAS');
GLDAS_get_time_series('G:\result\GLDAS\NOAH10\grid_swenson_300_025_soil_GLDAS_NOAH10_10_200001_202102',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_noah10_soil','GLDAS');

GLDAS_get_time_series('G:\result\GLDAS\VIC\grid_swenson_300_025_land_GLDAS_VIC_10_200001_202102',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_vic_land','GLDAS');
GLDAS_get_time_series('G:\result\GLDAS\VIC\grid_swenson_300_025_soil_GLDAS_VIC_10_200001_202102',...
    msk_hbpy,'mask','G:\result\time series\GLDAS\time_series_vic_soil','GLDAS');


%计算陆地水变化时间序列，单位m
GLDAS_get_time_series('G:\result\GRACE\grid_data',...
    msk_hbpy,'mask','G:\result\time series\GRACE\time_series_TWS','GRACE');

%计算地下水变化时间序列，单位cm
[time_series_clm_gw]=get_time_series('G:\result\GW\grid_gw month\grace_gldas_gw_clm_2002_2015',...
    msk_hbpy,'mask','G:\result\time series\GW\time_series_clm_gw_hbpy','month');
[time_series_mosaic_gw]=get_time_series('G:\result\GW\grid_gw month\grace_gldas_gw_mosaic_2002_2015',...
    msk_hbpy,'mask','G:\result\time series\GW\time_series_moaic_gw_hbpy','month');
[time_series_noah10_gw]=get_time_series('G:\result\GW\grid_gw month\grace_gldas_gw_noah10_2002_2015',...
    msk_hbpy,'mask','G:\result\time series\GW\time_series_noah10_gw_hbpy','month');
[time_series_vic_gw]=get_time_series('G:\result\GW\grid_gw month\grace_gldas_gw_vic_2002_2015',...
    msk_hbpy,'mask','G:\result\time series\GW\time_series_vic_gw_hbpy','month');
%绘制时间序列图
plot_time_series('G:\result\time series\GW\time_series_clm_gw_hbpy',...
    'month','等效水高(cm)','华北地区地下水变化时间序列','GRACE-CLM','month');

%% 计算并绘制北京市的地下水时间序列，单位cm
clear;clc;
bj_msk_name='G:\Data\msk_file\bj_msk_720_1440.mat';
%先把北京的gw由721行改为720行（与lg_msk同）
load('G:\result\GW\grid_gw month_025\grace_gldas_gw_noah025_2002_2015.mat');
grid_data_720=grid_data_721_2_720(grid_data);
clear grid_data;
grid_data=grid_data_720;
save('G:\result\GW\grid_gw month_025\grace_gldas_gw_720_1440_noah025_2002_2015.mat',...
    'grid_data','str_year','str_month','time');
disp('save grid data successfully');
%计算北京地下水变化时间序列
time_series_clm_bj=get_time_series('G:\result\GW\grid_gw month_025\grace_gldas_gw_720_1440_noah025_2002_2015',...
    bj_msk_name,'mask','G:\result\time series\GW\time_series_noah025_gw_bj','month');

%计算北京陆地水变化时间序列
%先把北京的TWS由721行改为720行（与lg_msk同）
clear;clc;
bj_msk_name='G:\Data\msk_file\bj_msk_720_1440.mat';
load('G:\result\GRACE\GRACE025\grid_data_025_leakagefree.mat');
grid_data_720=grid_data_721_2_720(grid_data);
clear grid_data;
grid_data=grid_data_720;
save('G:\result\GRACE\GRACE025\grid_data_025_720_1440_leakagefree',...
    'grid_data','str_year','str_month','time');%保存grid_data数据
GLDAS_get_time_series('G:\result\GRACE\GRACE025\grid_data_025_720_1440_leakagefree',...
    bj_msk_name,'mask','G:\result\time series\GRACE\time_series_TWS_bj_720_1440_leakagefree','GRACE');%保存time_series数据

%计算北京地表水变化时间序列
clear;clc;
bj_msk_name='G:\Data\msk_file\bj_msk_720_1440.mat';
load('G:\result\GLDAS\NOAH025\grid_swenson_300_land_GLDAS_NOAH025_025_200001_202102.mat');
grid_data_720=grid_data_721_2_720(grid_data);
clear grid_data;
grid_data=grid_data_720;
save('G:\result\GLDAS\NOAH025\grid_swenson_300_land__NOAH025_720_1440_200001_202102.mat',...
    'grid_data','int_year','int_month','time');
GLDAS_get_time_series('G:\result\GLDAS\NOAH025\grid_swenson_300_land__NOAH025_720_1440_200001_202102.mat',...
    bj_msk_name,'mask','G:\result\time series\GLDAS\time_series_land_bj_720_1440','GLDAS');

%计算北京土壤水变化时间序列
clear;clc;
bj_msk_name='G:\Data\msk_file\bj_msk_720_1440.mat';
load('G:\result\GLDAS\NOAH025\grid_swenson_300_soil_GLDAS_NOAH025_025_200001_202102.mat');
grid_data_720=grid_data_721_2_720(grid_data);
clear grid_data;
grid_data=grid_data_720;
save('G:\result\GLDAS\NOAH025\grid_swenson_300_soil__NOAH025_720_1440_200001_202102.mat',...
    'grid_data','int_year','int_month','time');
GLDAS_get_time_series('G:\result\GLDAS\NOAH025\grid_swenson_300_soil__NOAH025_720_1440_200001_202102.mat',...
    bj_msk_name,'mask','G:\result\time series\GLDAS\time_series_soil_bj_720_1440','GLDAS');

%plot
plot_time_series('G:\result\time series\GW\time_series_noah025_gw_bj',...
     'month','等效水高(cm)','北京市地下水变化时间序列','GRACE-NOAH025','month');

plot_time_series('G:\result\time series\GRACE\time_series_TWS_bj_720_1440_leakagefree',...
     'month','等效水高(m)','北京市陆地水变化时间序列','GRACE','month');
 
plot_time_series('G:\result\time series\GLDAS\time_series_land_bj_720_1440',...
     'month','等效水高(mm)','北京市地表水变化时间序列','G','month');

 