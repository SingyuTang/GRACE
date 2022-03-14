function [LON,LAT]=c11cmn2grid(c11cmn)
%将边界生成矩阵经纬网格网
% c11cmn=[-89.5 89.5 0.5 359.5];
lat1=c11cmn(1);
lat2=c11cmn(2);
lon1=c11cmn(3);
lon2=c11cmn(4);
lat=lat1:1:lat2;
lon=lon1:1:lon2;
[LON,LAT]=meshgrid(lon,lat);
end