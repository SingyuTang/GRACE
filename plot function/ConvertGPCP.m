clear;clc;
filepath1='G:\Data\GPCP_Precip_mat\GCPC_72_144_2.5_';
year=num2str([2002:1:2021]');
savepath1='G:\Data\GPCP_Precip_mat\GCPC_721_1440_025_';
for i=1:length(year)
    filepath=strcat(filepath1,year(i,:),'.mat');
    savepath=strcat(savepath1,year(i,:),'.mat');
    ConvetGPCP72_144_2_721_1440(filepath,savepath);
end
