clc;clear;
addpath('G:\GRACE\GLDAS_fuction');
addpath('G:\Auxiliary function');
addpath('G:\fengweiigg-GRACE_Matlab_Toolbox-61c8064\GRACE_functions');
addpath('G:\fengweiigg-GRACE_Matlab_Toolbox-61c8064\GRACE_functions\simons\');
addpath('G:\fengweiigg-GRACE_Matlab_Toolbox-61c8064');
c11cmn=[-89.5 89.5 -179.5 179.5];

%%  处理GRACE数据  %%
%处理grace数据,批量读取数据，替换C20,C21,C22,S21,S22，替换一阶项，作残差，去条带，移除GIA效应，高斯平滑，保存为cs_gsm_csr_swenson_2002_2015_60degree
% run('GRACE_Matlab_Toolbox_preprocessing.m');
controlfile_path='G:\grace_demo_test\GMT_Control_File_csr_2002_2013.txt';
GRACE_Matlab_Toolbox_preprocessing_core(controlfile_path);
cs_gsm=load('G:\Auxiliary function\result\GRACE\cs_gsm_csr_swenson_2002_2015_60degree.mat');

% %%空间域扣除泄露误差，打开文件为cs_gsm，保存为cs_leakage_oceanremoved_swenson_0km
%   处理陆地数据加载land格网(GUI界面的第二个选项）,移除海洋泄漏至陆地的信号，通常处理陆地数据
%   'ocean', Ocean Leakage Reduction: remove land's leakage effect ,load lg_msk_land_025.mat
%   'land', Land Leakage Reduction: remove ocean's leakage effect, load lg_msk_ocean_025.mat
addpath('G:\fengweiigg-GRACE_Matlab_Toolbox-61c8064\GRACE_data\msk_files');
run('GRACE_Matlab_Toolbox_LeakageReductionSpatial.m');

% % % % % % % % % %
% %%球协合成（cs转为grid），打开文件为上面的cs_gsm_csr_swenson_2002_2015_60degree或cs_leakage_oceanremoved_swenson_0km（cs文件），保存为grid_data
run('GRACE_Matlab_Toolbox_SHGrid.m');

% %%生成时间序列，打开文件为grid_data,保存为time_series(Time series of mass variation in XXX)
% 有时会出错，采用GLDAS_get_time_series.m（gmt_grid2series修改的方法）（data_type选择'GRACE'）
GLDAS_get_time_series('G:\GRACE_processing\hbpy2018_2021\grid_data.mat','G:\GRACE_processing\hbpy_msk_721_1440.mat','mask',...
    'G:\GRACE_processing\hbpy2018_2021\time_series_msk','GRACE');
GLDAS_get_time_series('G:\GRACE_processing\hbpy2002_2021\grid_data_721_1440.mat',...
    'G:\GRACE_processing\bj\bj_msk_721_1440.mat','mask',...
    'G:\GRACE_processing\bj\bj_grace_time_series_200204_202112','GRACE');
run('GRACE_Matlab_Toolbox_Grid2Series.m');
clear;
load('G:\Data\hbpy result\time_series025.mat');
% %绘制时间序列
plot(time,time_series*100,'-s');
xlabel('Year');
ylabel('Equivalent water height (cm)');
title('北京市陆地水储量变化图');

% %% Harmonic analysis
%Do harmonic analysis on time series(对时间序列进行谐波分析）,input:time_series
%Do harmonic analysis in the spatial domain（在空间域进行谐波分析）,input:grid_data, output：trend.mat
run GRACE_Matlab_Toolbox_HarmonicAnalysis.m;
%plot the trend map （Trend map of mass variation from GRACE ）
load('G:\Auxiliary function\result\GRACE\trend');
gmt_grid2map(trend*100,5,'cm/yr','Trend map of mass variations from GRACE')


%% 处理GLDAS数据
run('GLDAS_main.m');
%% 
% %由GRACE,GLDAS数据计算GW(721*1440)
clear;clc;
%华北平原
grace_gldas_gw('G:\GRACE_processing\hbpy2002_2021\grid_data_721_1440.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_land_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_721_1440_JPL06_noah025_200001_202111.mat');

%% 绘制趋势图,grid_data单位是什么，trend单位就是什么
%带入的grid_data为地下水数据，则计算出来的即为地下水的趋势
clear;clc;
% run GRACE_Matlab_Toolbox_HarmonicAnalysis.m;
%选取的gw文件路径例如 % grid_data_clm='G:\Auxiliary function\result\GW\grace_gldas_gw_clm_2002_2015.mat';
% trend_gw_clm=load('G:\Auxiliary function\result\Trend\trend_GW_clm');%gw,cm
% trend_gw_mosaic=load('G:\Auxiliary function\result\Trend\trend_GW_mosaic');%gw,cm
trend_gw_noah10=load('G:\Auxiliary function\result\Trend\trend_GW_noah10');%gw,cm
% trend_gw_vic=load('G:\Auxiliary function\result\Trend\trend_GW_vic');%gw,cm
trend=trend_gw_noah10.trend;
gmt_grid2map(trend,5,'cm/yr','地下水储量等效水高变化趋势图');

%%将721*1440矩阵转为720*1440
GRACE_grid_data=grid_data_721_2_720_vary('G:\GRACE_processing\hbpy2002_2017\grid_data_721_1440.mat',...
    'G:\GRACE_processing\hbpy2002_2017\grid_data_720_1440.mat','GRACE');
GLDAS_LAND=grid_data_721_2_720_vary('G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_land_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_720_1440_swenson_300_land_GLDAS_NOAH025_025_200001_202111.mat','GLDAS');
GLDAS_SOIL=grid_data_721_2_720_vary('G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_soil_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_720_1440_swenson_300_soil_GLDAS_NOAH025_025_200001_202111.mat','GLDAS');
GW=grid_data_721_2_720_vary('G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_721_1440_JPL06_noah025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_720_1440_JPL06_noah025_200001_202111.mat','GW');
Precip=grid_data_721_2_720_vary('G:\Data\GPCP_Precip_mat\GCPC_721_1440_025_mm_d_200201_202112.mat',...
    'G:\Data\GPCP_Precip_mat\GCPC_720_1440_025_mm_d_200201_202112.mat','GCPC');
%% 绘制地下水储量等效水高年变化量时间序列
clear;clc;
plot_time_series('G:\Auxiliary function\result\time_series\year series\time_series_year_clm_hbpy','年','等效水高(cm)','北京地区地下水变化时间序列','GRACE-NOAH025','month');

plot_series('G:\GRACE_processing\hbpy2018_2021\grid_data_720_1440.mat',...
    'G:\GRACE_processing\hbpy2018_2021\grid_720_1440_swenson_300_land_GLDAS_NOAH025_025_201805_202111.mat',...
    'G:\GRACE_processing\hbpy2018_2021\grid_720_1440_swenson_300_soil_GLDAS_NOAH025_025_201805_202111.mat',...
    'G:\GRACE_processing\hbpy2018_2021\grace_gldas_gw_720_1440_JPL06_noah025_201805_202111.mat',...
    'G:\GRACE_processing\hbpy_720_1440.mat',[2018 2022 -10 20],'G:\GRACE_processing\TRMM\precipitation_1998_2019__M_025.mat');
plot_series('G:\GRACE_processing\hbpy2002_2017\grid_data_720_1440.mat',...
    'G:\GRACE_processing\hbpy2002_2017\grid_720_1440_swenson_300_land_GLDAS_NOAH025_025_200201_201712.mat',...
    'G:\GRACE_processing\hbpy2002_2017\grid_720_1440_swenson_300_soil_GLDAS_NOAH025_025_200201_201712.mat',...
    'G:\GRACE_processing\hbpy2002_2017\grace_gldas_gw_720_1440_JPL06_noah025_200201_201712.mat',...
    'G:\GRACE_processing\hbpy_720_1440.mat',[2002 2018 -10 20],'G:\GRACE_processing\TRMM\precipitation_1998_2019__M_025.mat');
%华北2002-2021
plot_series('G:\GRACE_processing\hbpy2002_2021\grid_data_720_1440.mat',...
    'G:\result\GLDAS\NOAH025\grid_swenson_300_land__NOAH025_720_1440_200001_202102.mat',...
    'G:\result\GLDAS\NOAH025\grid_swenson_300_soil__NOAH025_720_1440_200001_202102.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_720_1440_JPL06_noah025_200204_202111.mat',...
    'G:\GRACE_processing\hbpy_msk_720_1440.mat',[2002 2022 -10 20],...
    'G:\Data\GPCP_Precip_mat\GCPC_720_1440_025_mm_d_200201_202112.mat');
%北京2002-2021
plot_series('G:\GRACE_processing\hbpy2002_2021\grid_data_720_1440.mat',...
    'G:\result\GLDAS\NOAH025\grid_swenson_300_land__NOAH025_720_1440_200001_202102.mat',...
    'G:\result\GLDAS\NOAH025\grid_swenson_300_soil__NOAH025_720_1440_200001_202102.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_720_1440_JPL06_noah025_200204_202111.mat',...
    'G:\GRACE_processing\bj\bj_msk_720_1440.mat',[2002 2022 -10 20],...
    'G:\Data\GPCP_Precip_mat\GCPC_720_1440_025_mm_d_200201_202112.mat');
plot_series('G:\GRACE_processing\hbpy2002_2021\grid_data_721_1440.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_land_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_soil_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grace_gldas_gw_721_1440_JPL06_noah025_200001_202111.mat',...
    'G:\GRACE_processing\bj\bj_msk_721_1440.mat',[2000 2022 -10 20],...
    'G:\Data\GPCP_Precip_mat\GCPC_721_1440_025_mm_d_200201_202112.mat');

%% 批量全球绘制地下水空间分布图
clear;clc;
grid_data_dir='G:\result\GW\grid_gw month_025\grace_gldas_gw_noah025_2002_2015';
colorbar_unit='cm';
title_string='全球地下水储量等效水高变化分布图';
type='month';
save_folder='G:\result\plot\map\GW\month gw\NOAH10\';
plot_spatial_distribution(grid_data_dir,colorbar_unit,title_string,save_folder,type);

%% 批量绘制华北平原地区地下水空间分布图
clear;clc;
hbpy_c11cmn=[110 128 45 28];
plot_spatial_distribution('G:\Data\hbpy result\grace_gldas_gw_720_1440_csr05_noah025_2002_2020.mat',...
    'cm','华北地区地下水储量等效水高变化分布图','G:\Data\hbpy result\hbpy GW\','month',hbpy_c11cmn,20);
