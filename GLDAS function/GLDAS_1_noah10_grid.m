%%读取GLDAS数据存储为mat格式，计算出的等效水高单位为mm
% 保存数据格式为东经：西经，南纬：北纬格式
% 数据保存为grid_land,grid_soil
clc;
clear;
datadir='G:\Data\GLDAS\GLDAS_NOAH10_M.2.1__200001_202102\';%指定批量数据所在的文件夹
save_dir='G:\result\GLDAS\NOAH10\grid_GLDAS_NOAH10_10_200001_202102.mat'; %GLDAS_NOAH_10_200201_201812_grid
filelist=dir([datadir,'*.nc4']);%指定批量数据的类型
k=length(filelist);
for s=1:k
     filename=[datadir,filelist(s).name];
     ncid=netcdf.open(filename,'NC_NOWRITE');
     file_name{s,1}=filelist(s).name;%%查看你要读取的文件的编号。filelist(1).name在window下为第一个标号数据
     info=ncinfo(filename);
     time(s,1)=str2double(filename(65:70));  %获取nc文件时间
     
     Soil1Data= ncread(filename,'SoilMoi0_10cm_inst'); %读入变量SoilMoi0_10cm_inst-kg m-2
     Soil1Data(isnan(Soil1Data))=0;
     
     Soil2Data= ncread(filename,'SoilMoi10_40cm_inst'); %读入变量SoilMoi10_40cm_inst-kg m-2
     Soil2Data(isnan(Soil2Data))=0;
     
     Soil3Data= ncread(filename,'SoilMoi40_100cm_inst'); %读入变量SoilMoi40_100cm_inst-kg m-2
     Soil3Data(isnan(Soil3Data))=0;

     Soil4Data= ncread(filename,'SoilMoi100_200cm_inst'); %读入变量SoilMoi100_200cm_inst-kg m-2
     Soil4Data(isnan(Soil4Data))=0;
     
     SWEData= ncread(filename,'SWE_inst');%读入变量雪水当量SWE_inst-kg m-2
     SWEData(isnan(SWEData))=0;
     
     CanopIntData= ncread(filename,'CanopInt_inst');%读入变量冠层水CanopInt_inst-kg m-2
     CanopIntData(isnan(CanopIntData))=0;
     
     QsData= ncread(filename,'Qs_acc');%读入变量地表径流Qs_acc-kg m-2
     QsData(isnan(QsData))=0;
     
    soil_aa=Soil1Data+Soil2Data+Soil3Data+Soil4Data;    % soilwater
    land_aa=soil_aa+SWEData+CanopIntData+QsData;
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
%%补全南纬60-90度，值设为0
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

%%从time中获取int_year和int_month
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

