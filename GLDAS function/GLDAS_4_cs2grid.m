%%球谐系数转格网文件
function GLDAS_4cs2grid(cs_readname,grid_savename_land,grid_savename_soil,type)
%cs_readname:高斯滤波处理后的cs矩阵的完整保存路径
%grid_savename_land:将滤波处理后的cs矩阵转化为grid_data格式矩阵，land water的存储路径
%保存为grid_data,int_year,int_month,time,destrip_method,radius_filter,type
%grid_savename_soil:将滤波处理后的cs矩阵转化为grid_data格式矩阵，soil water的存储路径
%保存为grid_data,int_year,int_month,time,destrip_method,radius_filter,type
%type=1;  %grid's interval, options: 0.25, 0.5 or 1 degree

cs=load(cs_readname);
save_dir1=grid_savename_land;
save_dir2=grid_savename_soil;

cs_land=cs.cs_land;
cs_soil=cs.cs_soil;
time=cs.time;
int_year=cs.int_year;
int_month=cs.int_month;

radius_filter=0;  % Radius of Gaussian smoothing, unit: km
destrip_method='NONE';  %NONE, SWENSON, CHAMBERS2007,CHAMBERS2012, CHENP3M6, CHENP4M6, DUAN
[m,~]=size(time);
time=[];
for i=1:m
    time(i,1)=int_year(i,1)+int_month(i,1)/12;
    
end

grid_land=gmt_cs2grid(cs_land,radius_filter,type,destrip_method);
grid_soil=gmt_cs2grid(cs_soil,radius_filter,type,destrip_method);



grid_data=grid_land;
save(save_dir1,'grid_data','-v7.3');
save(save_dir1,'int_year','-append');
save(save_dir1,'int_month','-append');
save(save_dir1,'time','-append');
save(save_dir1,'destrip_method','-append');
save(save_dir1,'radius_filter','-append');
save(save_dir1,'type','-append');

grid_data=grid_soil;
save(save_dir2,'grid_data','-v7.3');
save(save_dir2,'int_year','-append');
save(save_dir2,'int_month','-append');
save(save_dir2,'time','-append');
save(save_dir2,'destrip_method','-append');
save(save_dir2,'radius_filter','-append');
save(save_dir2,'type','-append');

% clear
% clc
disp(['Save GLDAS_cs2grid.mat successfully.']);
