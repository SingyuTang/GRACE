clear;clc;
addpath('G:\Auxiliary function\mask function');
%所需文件路径
TRMM_name='G:\Data\TRMM\3B43\';%降水数据
msk_720_1440_name='G:\Data\msk_file\bj_msk_720_1440.mat';%lg_msk文件
time_series_gwname='G:\result\time series\GW\time_series_noah025_gw_bj.mat';%地下水数据
TWS_name='G:\result\time series\GRACE\time_series_TWS_bj_720_1440_leakagefree';%陆地水
land_name='G:\result\time series\GLDAS\time_series_land_bj_720_1440';%地表水
soil_name='G:\result\time series\GLDAS\time_series_soil_bj_720_1440';%土壤水
natidata_name='G:\国家统计局数据\地下水年数据\natudata_bj.mat';%地下水实测数据（年）


[precipitation,time_p,str_pyear,str_pmonth]=read_TRMM_3B43(TRMM_name);%降水量（mm）
% [precipitation,time,str_year,str_month]=read_TRMM_3B43('G:\Data\TRMM\3B43\');
precipitation=precipitation*24*30;%东经：西经，南纬：北纬格式
% save(savename_TRMM,'precipitation','str_year','str_month','time','-v7.3');
k=size(precipitation,3);
pr=zeros(size(precipitation));
for i=1:k
    pr_tmp=mask_convert_NS(precipitation(:,:,i));%交换南北纬,hdf文件为南纬：北纬排列
    pr(:,:,i)=pr_tmp;
end
precipitation=pr;

 %%
 %实测数据
% read_naturaldata('G:\国家统计局数据\北京','G:\国家统计局数据\地下水年数据\natudata_bj.mat');
Sbeijing=16410;     %km^2
[time_series_nati,time_nati]=get_natidata_series(Sbeijing,natidata_name);

%% 绘制降水时序图

msk=load(msk_720_1440_name);
lg_msk=msk.lg_msk;%东经：西经，北纬：南纬排列
time_series_prec=gmt_grid2series(precipitation,msk_720_1440_name,'mask',89.5);
ts=load(time_series_gwname);%地下水，cm
time_series_gw=ts.time_series;
time_gw=ts.time;
time_p02=time_p';
time_p02=time_p02(49:216,:);%2002~2015年的数据
time_series_p02=time_series_prec(49:216.);



ts_TWS=load(TWS_name);
ts_land=load(land_name);
ts_soil=load(soil_name);
time_series_TWS=ts_TWS.time_series;
time_series_land=ts_land.time_series;
time_series_soil=ts_soil.time_series;
TWS_time=ts_TWS.time;
land_time=ts_land.time;
soil_time=ts_soil.time;
%

 f=figure;
 yyaxis right%控制右纵轴
 bar(time_p02,time_series_p02);%绘柱状图
 title('北京地下水储量与降雨量发展趋势');
 xlabel('年');
 ylabel('降雨量(mm)');
 yyaxis left%控制左纵轴
 hold on;

 plot(time_gw,time_series_gw,'-s','color','r','marker','none');%绘折线图
 plot(TWS_time,time_series_TWS*100,'-s','color','b','marker','none');
 plot(land_time,time_series_land/10,'-s','color','g','marker','none');
 plot(soil_time,time_series_soil/10,'-s','color','k','marker','none');
 plot(time_nati,time_series_nati);
%  grid on;
 legend('underground water','land water','surface water','soil water','national data');
 ylabel('等效水高(cm)');
 axis([2002 2016 -10 20]);
 set(gca,'XTick',[2002:1:2016]);
 

