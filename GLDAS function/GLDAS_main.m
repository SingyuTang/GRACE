%% 处理GLDAS数据

% %根据GLDAS计算地表水和土壤水
% %% % % % %  % % % % % % % % % % % 
% %处理clm数据
%读取数据,grid格式
% run('GLDAS_1_clm_grid.m');
%grid转为cs格式
GLDAS_2_grid2cs('G:\result\GLDAS\CLM\grid_GLDAS_CLM_10_200204_201608.mat',...
    'G:\result\GLDAS\CLM\cs_GLDAS_CLM_10_200204_201608.mat');
%平滑处理
GLDAS_3_gaussian_filter('G:\result\GLDAS\CLM\cs_GLDAS_CLM_10_200204_201608.mat',...
    'G:\result\GLDAS\CLM\cs_filter300_GLDAS_CLM_10_200204_201608.mat');
%处理完成后转为grid格式
GLDAS_4_cs2grid('G:\result\GLDAS\CLM\cs_filter300_GLDAS_CLM_10_200204_201608.mat',...
    'G:\result\GLDAS\CLM\grid_swenson_300_025_land_GLDAS_CLM_10_200204_201608.mat',...
    'G:\result\GLDAS\CLM\grid_swenson_300_025_soil_GLDAS_CLM_10_200204_201608.mat',1);


% %处理MOSAIC数据
%读取数据,grid格式
% run('GLDAS_1_clm_grid.m');
%grid转为cs格式
GLDAS_2_grid2cs('G:\result\GLDAS\MOSAIC\grid_GLDAS_MOSAIC_10_200204_201812.mat',...
    'G:\result\GLDAS\MOSAIC\cs_GLDAS_MOSAIC_10_200204_201812.mat');
%平滑处理
GLDAS_3_gaussian_filter('G:\result\GLDAS\MOSAIC\cs_GLDAS_MOSAIC_10_200204_201812.mat',...
    'G:\result\GLDAS\MOSAIC\cs_filter300_GLDAS_MOSAIC_10_200204_201812.mat');
%处理完成后转为grid格式
GLDAS_4_cs2grid('G:\result\GLDAS\MOSAIC\cs_filter300_GLDAS_MOSAIC_10_200204_201812.mat',...
    'G:\result\GLDAS\MOSAIC\grid_swenson_300_025_land_GLDAS_MOSAIC_10_200204_201812.mat',...
    'G:\result\GLDAS\MOSAIC\grid_swenson_300_025_soil_GLDAS_MOSAIC_10_200204_201812.mat',1);

% % %处理NOAH10数据
%读取数据,grid格式
% run('GLDAS_1_noah10_grid.m');
%grid转为cs格式
GLDAS_2_grid2cs('G:\result\GLDAS\NOAH10\grid_GLDAS_NOAH10_10_200001_202102.mat',...
    'G:\result\GLDAS\NOAH10\cs_GLDAS_NOAH10_10_200001_202102.mat');
%平滑处理
GLDAS_3_gaussian_filter('G:\result\GLDAS\NOAH10\cs_GLDAS_NOAH10_10_200001_202102.mat',...
    'G:\result\GLDAS\NOAH10\cs_filter300_GLDAS_NOAH10_10_200001_202102.mat');
%处理完成后转为grid格式
GLDAS_4_cs2grid('G:\result\GLDAS\NOAH10\cs_filter300_GLDAS_NOAH10_10_200001_202102.mat',...
    'G:\result\GLDAS\NOAH10\grid_swenson_300_land_GLDAS_NOAH10_10_200001_202102.mat',...
    'G:\result\GLDAS\NOAH10\grid_swenson_300_soil_GLDAS_NOAH10_10_200001_202102.mat',1);

% %处理VIC数据
%读取数据,grid格式
% run('GLDAS_1_vic_grid.m');
GLDAS_2_grid2cs('G:\result\GLDAS\VIC\grid_GLDAS_VIC_10_200001_202102.mat',...
    'G:\result\GLDAS\VIC\cs_GLDAS_VIC_10_200001_202102.mat');
%平滑处理
GLDAS_3_gaussian_filter('G:\result\GLDAS\VIC\cs_GLDAS_VIC_10_200001_202102.mat',...
    'G:\result\GLDAS\VIC\cs_filter300_GLDAS_VIC_10_200001_202102.mat');
%处理完成后转为grid格式
GLDAS_4_cs2grid('G:\result\GLDAS\VIC\cs_filter300_GLDAS_VIC_10_200001_202102.mat',...
    'G:\result\GLDAS\VIC\grid_swenson_300_025_land_GLDAS_VIC_10_200001_202102.mat',...
    'G:\result\GLDAS\VIC\grid_swenson_300_025_soil_GLDAS_VIC_10_200001_202102.mat',1);

%处理NOAH025数据
run('GLDAS_1_noah025_grid.m');
%grid转为cs格式
GLDAS_2_grid2cs('G:\GRACE_processing\hbpy2002_2021\grid_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\cs_GLDAS_NOAH025_025_200001_202111.mat');
%平滑处理
GLDAS_3_gaussian_filter('G:\GRACE_processing\hbpy2002_2021\cs_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\cs_filter300_GLDAS_NOAH025_025_200001_202111.mat');
%处理完成后转为grid格式（721*1440）
GLDAS_4_cs2grid('G:\GRACE_processing\hbpy2002_2021\cs_filter300_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_land_GLDAS_NOAH025_025_200001_202111.mat',...
    'G:\GRACE_processing\hbpy2002_2021\grid_721_1440_swenson_300_soil_GLDAS_NOAH025_025_200001_202111.mat',0.25);
