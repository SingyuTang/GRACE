%利用bln文件或者与bln文件格式相同的mat文件生成mask，经度范围-180-180（0-180列为西经，181-360列为东经），应用时需转换为0-360
%以适应grid_data文件（经度是0-360,左边为东经，右边为西经,北纬：南纬排列）
%该文件输出格式为-180~180，即左边为西经，右边为东经,上北纬下南纬
function [lg_msk] = make_mask(dir_mask,type,row,col)
%   dir_msk         boundary/mask file
%   type            options: bln, mat
if (strcmp(type,'bln'))%bln文件
    bln_dir=dir_mask;
%%%制作目标区域的mask文件
fid           = fopen(bln_dir,'r');
num_points    = fscanf(fid,'%d',1);
xv            = zeros(num_points,1);
yv            = zeros(num_points,1);
%读取bln文件
for i=1:num_points
    a     = fscanf(fid,'%f %f',[1 2]);
%     xv(i) = a(1)-360; %% jiazhou
    xv(i) = a(1); %% huabei
    yv(i) = a(2);
end

fclose(fid);
lon_min=min(xv);
lon_max=max(xv);
lat_min=min(yv);
lat_max=max(yv);
if row==180 && col==360
    lon=-179.5:179.5; %180*360
    lat=-89.5:89.5;
elseif row==721 && col==1440
    lon=-180:0.25:179.75;%721*1440
    lat=-90:0.25:90;
elseif row==720 && col==1440
    lon = -180:0.25:179.75; %720*1440
    lat = -89.875:0.25:89.875;
elseif row==360 && col==720
    lon=0.25:0.5:359.75; %360*720
    lat=-89.75:0.5:89.75;
elseif row==361 && col==720
    lon=0.25:0.5:359.75; %361*720
    lat=-90:0.5:90;
elseif row==181 && col==360
    lon=0:360; %181*360
    lat=-90:1:90;
end
jj=size(lat,2); ii=size(lon,2);
lg_msk = zeros(jj,ii);
for j=1:jj
    for i=1:ii
        if lon(i)>=lon_min && lon(i)<=lon_max && lat(j)>=lat_min && lat(j)<=lat_max
            in =inpolygon(lon(i),lat(j),xv,yv);
            if in==1
                lg_msk(j,i) = 1;
            end
        end
    end
end
lg_msk=flipud(lg_msk);
end
if (strcmp(type,'mat'))%mat文件
    mat_dir=dir_mask;
    region=load(mat_dir);
    num_points=region.Boundary(1,1);
    region.Boundary(1,:)=[];
    xv=region.Boundary(:,1);
    yv=region.Boundary(:,2);
    lon_min=min(xv);
    lon_max=max(xv);
    lat_min=min(yv);
    lat_max=max(yv);
    if row==180 && col==360
        lon=-179.5:179.5; %180*360
        lat=-89.5:89.5;
    elseif row==721 && col==1440
        lon=-180:0.25:179.75;%721*1440
        lat=-90:0.25:90;
    elseif row==720 && col==1440
        lon = -180:0.25:179.75; %720*1440
        lat = -89.875:0.25:89.875;
    elseif row==360 && col==720
        lon=0.25:0.5:359.75; %360*720
        lat=-89.75:0.5:89.75;
    elseif row==361 && col==720
        lon=0.25:0.5:359.75; %361*720
        lat=-90:0.5:90;
    elseif row==181 && col==360
        lon=0:360; %181*360
        lat=-90:1:90;
    end
jj=size(lat,2); ii=size(lon,2);
lg_msk = zeros(jj,ii);
for j=1:jj
    for i=1:ii
        if lon(i)>=lon_min && lon(i)<=lon_max && lat(j)>=lat_min && lat(j)<=lat_max
            in =inpolygon(lon(i),lat(j),xv,yv);
            if in==1
                lg_msk(j,i) = 1;
            end
        end
    end
end
lg_msk=flipud(lg_msk);%上下翻转
end