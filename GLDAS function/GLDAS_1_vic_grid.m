%%读取GLDAS数据存储为mat格式，计算出的等效水高单位为mm
% 保存数据格式为东经：西经，南纬：北纬格式
% 数据保存为grid_land,grid_soil
clc;
clear;
datadir='G:\Data\GLDAS\GLDAS_VIC10_M.2.1_200001_202102\';%指定批量数据所在的文件夹
save_dir='G:\result\GLDAS\VIC\grid_GLDAS_VIC_10_200001_202102.mat';
filelist=dir([datadir,'*.nc4']);%指定批量数据的类型
%a=filelist(1).name;%%查看你要读取的文件的编号。filelist(1).name在window下为第一个标号数据
%b=filelist(2).name;%查看你要读取的文件的编号。filelist(2).name在window下为第二个标号数据
k=length(filelist);
for s=1:k
     %b=s+201802;
     filename=[datadir,filelist(s).name];
     ncid=netcdf.open(filename,'NC_NOWRITE');
     file_name{s,1}=filelist(s).name;%%查看你要读取的文件的编号。filelist(1).name在window下为第一个标号数据
     %ncdisp('D:\MATLAB\toolbox\nctoolbox\data\GLDAS_NOAH025_3H.A20170801.0000.021.nc4');%可有可无
     %ncid=netcdf.open('D:\MATLAB\toolbox\nctoolbox\data\GLDAS_NOAH025_3H.A20170801.0000.021.nc4','NOWRITE');%可有可无
     info=ncinfo(filename);
     time(s,1)=str2double(filename(62:67));  %获取nc文件时间
     
     SoilData1=ncread(filename,'SoilMoi0_30cm_inst');
     SoilData1(isnan(SoilData1))=0;
     SoilData2=ncread(filename,'SoilMoi_depth2_inst');
     SoilData2(isnan(SoilData2))=0;
     SoilData3=ncread(filename,'SoilMoi_depth3_inst');
     SoilData3(isnan(SoilData3))=0;
     
     SoilData= SoilData1+SoilData2+SoilData3;
     %Soil1q{s}=interp2(X,Y,Soil1Data,39.4256,-112.8449,'cubic'); %插值指定点位土壤水分值
          
     SWEData= ncread(filename,'SWE_inst');%读入变量雪水当量SWE_inst-kg m-2
     SWEData(isnan(SWEData))=0;
    % SWEq{s}=interp2(X,Y,SWEData,39.4256,-112.8449,'cubic'); %插值指定点位雪水当量值
     
     CanopIntData= ncread(filename,'CanopInt_inst');%读入变量冠层水CanopInt_inst-kg m-2
     CanopIntData(isnan(CanopIntData))=0;
    % CanopIntq{s}=interp2(X,Y,CanopIntData,39.4256,-112.8449,'cubic'); %插值指定点位冠层水值
     
    soil_aa=SoilData;    % soilwater
    land_aa=soil_aa+SWEData+CanopIntData;
    soil_bb(:,:,s)=soil_aa';
    land_bb(:,:,s)=land_aa';     
    netcdf.close(ncid);
end

soil_mean=mean(soil_bb,3);
land_mean=mean(land_bb,3);

%%扣除背景场

for j =1:k
    soil_cc(:,:,j)=(soil_bb(:,:,j)-soil_mean); %单位为mm
    land_cc(:,:,j)=(land_bb(:,:,j)-land_mean);
    
end
%% 补全南纬60-90度，值设为0
lat=-89.5:1:89.5;
lat=lat';
lon=(0.5:1:359.5)';
a=zeros(30,360);
for i=1:k
    soil_dd(:,:,i)=[a;soil_cc(:,:,i)];
    land_dd(:,:,i)=[a;land_cc(:,:,i)];
        
end

%%将GLDAS原始数据-180-180转为0-360
for i=1:k
    soil_ee=soil_dd(:,1:180,i);
    grid_soil(:,:,i)=[soil_dd(:,181:360,i) soil_ee];
    land_ee=land_dd(:,1:180,i);
    grid_land(:,:,i)=[land_dd(:,181:360,i) land_ee];
end

%% 从time中获取int_year和int_month
int_year=floor(time/100);
int_month=time-int_year*100;

%%存储土壤水soil、陆地水land、时间time、文件名file_name、经度lon、纬度lat
save(save_dir,'grid_soil');
save(save_dir,'grid_land','-append');
save(save_dir,'int_year','-append');
save(save_dir,'int_month','-append');
save(save_dir,'file_name','-append');
save(save_dir,'lat','-append');
save(save_dir,'lon','-append');
save(save_dir,'time','-append');

clear
clc
disp(['Save successfully.']);
