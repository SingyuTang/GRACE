%% 将2017年前和2017年后的grid_data数据合到一起
%% GRACE
clear;clc;
cat_data_path='G:\GRACE_processing\hbpy2002_2021\grid_data_721_1440.mat';
grid_data1=load('G:\GRACE_processing\hbpy2002_2017\grid_data_721_1440.mat');
grid_data2=load('G:\GRACE_processing\hbpy2018_2021\grid_data_721_1440.mat');
grid_data=cat(3,grid_data1.grid_data,grid_data2.grid_data);
str_year=cat(2,grid_data1.str_year,grid_data2.str_year);
str_month=cat(2,grid_data1.str_month,grid_data2.str_month);
time=cat(1,grid_data1.time,grid_data2.time);
save(cat_data_path,'grid_data','str_year','str_month','time');
display('save successfully');

