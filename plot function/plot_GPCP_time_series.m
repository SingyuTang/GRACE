%   根据转化后的GPCP中的降水数据（721*1440，mm/d）和lg_msk生成时间序列并绘制条形图
% function plot_GPCP_time_series(GPCP_filepath,lg_msk_path)
clear;clc;
GPCP_dir_025='G:\Data\GPCP_Precip_mat\GCPC_721_1440\';
lg_msk_path='G:\GRACE_processing\hbpy_msk_720_1440.mat';
savepath_sum_precipition='G:\Data\GPCP_Precip_mat\GCPC_720_1440_025_mm_d_200201_202112.mat';

%% 计算日降水量并保存
filelists=dir(GPCP_dir_025);
filename_1=fullfile(GPCP_dir_025,filelists(3).name);%先提出第一个数据，后面直接在该基础上拼接
load(filename_1);
precipitation=PrecipData;
sum_int_year=int_year;
sum_int_month=int_month;
sum_time=time;
for i=4:length(filelists)
    filename=fullfile(GPCP_dir_025,filelists(i).name);
    load(filename);%load 后的PrecipData单位为mm/day
    precipitation=cat(3,precipitation,PrecipData);%拼接所有年份的降水数据
    sum_int_year=cat(1,sum_int_year,int_year);
    sum_int_month=cat(1,sum_int_month,int_month);
    sum_time=cat(1,sum_time,time);
end
clear int_month int_year time PrecipData;
int_year=sum_int_year;
int_month=sum_int_month;
time=sum_time;
PrecipData=precipitation;
save(savepath_sum_precipition,'PrecipData','time','int_month','int_year','lat','LAT','lon','LON');
%% 绘图
pre_load=load(savepath_sum_precipition);
time_series=gmt_grid2series(pre_load.PrecipData*30,lg_msk_path,'mask',90);
 f=figure;
 yyaxis right%控制右纵轴
 bar(pre_load.time,time_series);%绘柱状图
 title('华北降雨量发展趋势—GCPC-720-1440');
 xlabel('年');
 ylabel('降雨量(mm)');

