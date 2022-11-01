close all
clear all
%%%%%%%% Derivative %%%%%%%%%%%%
load('dudt_rec_40.mat');
load('dudt_rec_80.mat');
load('dudt_rec_120.mat');


dudt_40_zoom = (dudt_40(56740:60811));
dudt_80_zoom = (dudt_80(47733:50452));
dudt_120_zoom = (dudt_120(59373:61426));




% Smooth input data
smoothedData_40 = smoothdata(dudt_40_zoom,'lowess','SmoothingFactor',0.86);  %Change the smooth factor here
smoothedData_80 = smoothdata(dudt_80_zoom,'lowess','SmoothingFactor',0.83);
smoothedData_120 = smoothdata(dudt_120_zoom,'lowess','SmoothingFactor',0.81);


% Display results
figure(1)
plot(smoothedData_40,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Rectangular pulley - speed 40 mm/s");

figure(2)
plot(smoothedData_80,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Rectangular pulley - speed 80 mm/s");

figure(3)
plot(smoothedData_120,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Rectangular pulley - speed 120 mm/s");

