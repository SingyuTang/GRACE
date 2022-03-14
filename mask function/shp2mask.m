%利用shp文件生成lg_msk(mask文件)，经度范围-180-180（0-180列为西经，181-360列为东经）,运用时需转换为0-360（1-180列为东经，181-360列为西经）
function lg_msk=shp2mask(shp,boundary_savename,row,col)
%shp:shapefile
%boundary_savename:边界点的坐标文件，与bln格式相同
%row,col：制作的掩膜数据的行列数
%X为经度(正为东经，负为西经)，Y为纬度(正为北纬，负为南纬）
lon_lat=[shp.X',shp.Y'];
[m,n]=find(isnan(lon_lat));
lon_lat(m,:)=[];
a=length(lon_lat);
mat_tmp=zeros(a+1,2);
mat_tmp(1,1)=a;
mat_tmp(1,2)=nan;
Boundary=[mat_tmp(1,:); lon_lat];%必须命名为Boundary，保存的文件名以地区命名
% save('G:\Auxiliary function\result\boundary\beijing.mat','Boundary');
save(boundary_savename,'Boundary');
disp('save boundary point successfully');
%读取边界经纬度信息(.mat文件)，第一行为个数，第一列为经度，第二列为纬度，bln文件暂时未能生成
[lg_msk] = make_mask(boundary_savename,'mat',row,col);
