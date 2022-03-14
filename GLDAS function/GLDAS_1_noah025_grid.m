%%读取GLDAS数据存储为mat格式，计算出的等效水高单位为mm
clc;
clear;
datadir='G:\Data\GLDAS\GLDAS_NOAH025_M.2.1__200001_202111\';%指定批量数据所在的文件夹
save_dir='G:\GRACE_processing\hbpy2002_2021\grid_GLDAS_NOAH025_025_200001_202111.mat';
filelist=dir([datadir,'*.nc4']);%指定批量数据的类型
%a=filelist(1).name;%%查看你要读取的文件的编号。filelist(1).name在window下为第一个标号数据
%b=filelist(2).name;%查看你要读取的文件的编号。filelist(2).name在window下为第二个标号数据
k=length(filelist);
for s=1:k
     filename=[datadir,filelist(s).name];
     ncid=netcdf.open(filename,'NC_NOWRITE');
     file_name{s,1}=filelist(s).name;%%查看你要读取的文件的编号。filelist(1).name在window下为第一个标号数据
     %ncdisp('D:\MATLAB\toolbox\nctoolbox\data\GLDAS_NOAH025_3H.A20170801.0000.021.nc4');%可有可无
     %ncid=netcdf.open('D:\MATLAB\toolbox\nctoolbox\data\GLDAS_NOAH025_3H.A20170801.0000.021.nc4','NOWRITE');%可有可无
     info=ncinfo(filename);
     time(s,1)=str2double(filename(67:72));  %获取nc文件时间
     %ncdisp('D:\MATLAB\toolbox\nctoolbox\data\GLDAS_NOAH025_3H.A20170801.0000.021.nc4'); %可有可无
     %LonData{s}     = ncread(filename,'lon'); %读入变量lon经度
     %LatData{s}     = ncread(filename,'lat'); %读入变量lat纬度
     %lon = ncread(filename,'lon'); %读入变量lon经度
     %lat = ncread(filename,'lat'); %读入变量lat纬度
     %Lon=LonData{1,length(LonData)};
     %Lat=LatData{1,length(LatData)};
     %    [lat,lon] = meshgrid(LatData,LonData);
     %    lat=lat';
     %    lon=lon';
     Soil1Data= ncread(filename,'SoilMoi0_10cm_inst'); %读入变量SoilMoi0_10cm_inst-kg m-2
     Soil1Data(isnan(Soil1Data))=0;
     %Soil1q{s}=interp2(X,Y,Soil1Data,39.4256,-112.8449,'cubic'); %插值指定点位土壤水分值
     
     Soil2Data= ncread(filename,'SoilMoi10_40cm_inst'); %读入变量SoilMoi10_40cm_inst-kg m-2
     Soil2Data(isnan(Soil2Data))=0;

     %Soil2q{s}=interp2(X,Y,Soil2Data,39.4256,-112.8449,'cubic'); %插值指定点位土壤水分值
     
     Soil3Data= ncread(filename,'SoilMoi40_100cm_inst'); %读入变量SoilMoi40_100cm_inst-kg m-2
     Soil3Data(isnan(Soil3Data))=0;

    % Soil3q{s}=interp2(X,Y,Soil3Data,39.4256,-112.8449,'cubic'); %插值指定点位土壤水分值
     
     Soil4Data= ncread(filename,'SoilMoi100_200cm_inst'); %读入变量SoilMoi100_200cm_inst-kg m-2
     Soil4Data(isnan(Soil4Data))=0;
     %Soil4q{s}=interp2(X,Y,Soil4Data,39.4256,-112.8449,'cubic'); %插值指定点位土壤水分值
     
     SWEData= ncread(filename,'SWE_inst');%读入变量雪水当量SWE_inst-kg m-2
     SWEData(isnan(SWEData))=0;
    % SWEq{s}=interp2(X,Y,SWEData,39.4256,-112.8449,'cubic'); %插值指定点位雪水当量值
     
     CanopIntData= ncread(filename,'CanopInt_inst');%读入变量冠层水CanopInt_inst-kg m-2
     CanopIntData(isnan(CanopIntData))=0;
    % CanopIntq{s}=interp2(X,Y,CanopIntData,39.4256,-112.8449,'cubic'); %插值指定点位冠层水值
     
     QsData= ncread(filename,'Qs_acc');%读入变量地表径流Qs_acc-kg m-2
     QsData(isnan(QsData))=0;
    % Qsq{s}=interp2(X,Y,QsData,39.4256,-112.8449,'cubic'); %插值指定点位地表径流值
     
    soil_aa=Soil1Data+Soil2Data+Soil3Data+Soil4Data;    % soilwater
    land_aa=soil_aa+SWEData+CanopIntData+QsData;
    soil_bb(:,:,s)=soil_aa';
    land_bb(:,:,s)=land_aa';     
    netcdf.close(ncid);
    pause(3);
end

soil_mean=mean(soil_bb,3);
land_mean=mean(land_bb,3);

%%扣除背景场

for j =1:k
    soil_cc(:,:,j)=(soil_bb(:,:,j)-soil_mean); %单位为mm
    land_cc(:,:,j)=(land_bb(:,:,j)-land_mean);
    
end

%补全南纬60-90度
lat=(-89.875:0.25:89.875)';
lon=(0.125:0.25:359.875)';
a=zeros(120,1440);

for i=1:k
    soil_dd(:,:,i)=[a;soil_cc(:,:,i)];
    land_dd(:,:,i)=[a;land_cc(:,:,i)];
        
end

clear soil_aa soil_bb soil_cc land_aa land_bb land_cc soil_mean land_mean;

%%将GLDAS原始数据-180-180（西经：东经）转为0-360（东经：西经）
for i=1:k
    grid_soil(:,:,i)=mask_convert(soil_dd(:,:,i));
    grid_land(:,:,i)=mask_convert(land_dd(:,:,i));
end

%%从time中获取int_year和int_month
int_year=floor(time/100);
int_month=time-int_year*100;

%%存储土壤水soil、陆地水land、时间time、文件名file_name、经度lon、纬度lat
save(save_dir,'grid_soil','-v7.3');
save(save_dir,'grid_land','-append');
save(save_dir,'int_year','-append');
save(save_dir,'int_month','-append');
save(save_dir,'file_name','-append');
save(save_dir,'lat','-append');
save(save_dir,'lon','-append');
save(save_dir,'time','-append');

% clear
% clc
disp(['Save successfully.']);
