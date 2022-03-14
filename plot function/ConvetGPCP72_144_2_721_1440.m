function ConvetGPCP72_144_2_721_1440(filepath,savepath)
%   将read_GPCP4Precip(datadir,savedir)函数读取的mat文件转化为grid_data类型（721*1440，东经：西经；北纬：南纬），采用方法为立方插值（'cubic'）
%   filepath：read_GPCP4Precip函数读取出的降雨数据所保存的mat文件的文件路径
%   savepath：转化后721*1440mat文件的保存路径（grid_data类型（721*1440，东经：西经；北纬：南纬））
% filepath='G:\Data\GPCP_Precip_mat\GCPC_72_144_2.5_2002.mat';
% savepath='G:\Data\GPCP_Precip_mat\GCPC_721_1440_2.5_2002.mat';
load(filepath);
lon_interp=0:0.25:359.75;
lat_interp=[90:-0.25:-90]';
for i=1:length(time)
lon=longitude(i,:);
lat=latitude(i,:)';
p1=PrecipData(:,:,i);
% p1_col=reshape(p1,[],1);
[LON,LAT]=meshgrid(lon,lat);
[LON_interp,LAT_interp]=meshgrid(lon_interp,lat_interp);
p1_interp=interp2(lon,lat,p1,lon_interp,lat_interp,'cubic');
% f1=figure;
% surf(LON,LAT,p1);
% f2=figure;
% meshz(LON,LAT,p1);
% f3=figure;
% meshz(LON_interp,LAT_interp,p1_interp);
p1_interp(isnan(p1_interp)==1)=0;
precip(:,:,i)=p1_interp;
end
clear lon lat LON LAT PrecipData;
lon=lon_interp;
lat=lat_interp;
LON=LON_interp;
LAT=LAT_interp;
PrecipData=precip;
save(savepath,'PrecipData','time','lon','lat','LON','LAT','int_month','int_year');
display(strcat(savepath,'has saved successfully'));