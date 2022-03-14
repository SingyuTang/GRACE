%绘制2002-2021年华北平原地下水(cm)和陆地水储量(单位m，需转化为cm）
clear;clc;
tws_filepath='G:\GRACE_processing\hbpy2002_2021\time_series_grace.mat';
gw_filepath='G:\GRACE_processing\hbpy2002_2021\time_series_hbpy_gw.mat';
tws=load(tws_filepath);
gw=load(gw_filepath);
plot(tws.time,tws.time_series*100,'-s');
hold on;
plot(gw.time,gw.time_series,'-s');
xlabel('Year');
ylabel('Equivalent water height (cm)');
title('华北平原陆地水和地下水储量变化图');
legend('TWS','GW');

