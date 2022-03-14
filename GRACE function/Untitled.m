
[plot_region]=gmt_grid2series(grid_data,'G:\Data\msk_file\huabei_msk_720_1440.mat','mask',89.875);
plot(time,plot_region*100,'-s');
xlabel('Year');
ylabel('Equivalent water height (cm)');
title('EWH in the Beijing from GRACE');


