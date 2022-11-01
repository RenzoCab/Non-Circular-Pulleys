close all
clear all
%%%%%%%% Derivative %%%%%%%%%%%%
load('dudt_tri_40.mat');
load('dudt_tri_80.mat');
load('dudt_tri_120.mat');


dudt_40_zoom = (dudt_40(52224:56318));
dudt_80_zoom = (dudt_80(57246:60030));
dudt_120_zoom = (dudt_120(57190:59251));



% Smooth input data
smoothedData_40 = smoothdata(dudt_40_zoom,'lowess','SmoothingFactor',0.99); %Change the smooth factor here
smoothedData_80 = smoothdata(dudt_80_zoom,'lowess','SmoothingFactor',0.9399999999999999);
smoothedData_120 = smoothdata(dudt_120_zoom,'lowess','SmoothingFactor',0.9499999999999999);


% Display results
figure(1)
plot(smoothedData_40,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Triangular pulley - speed 40 mm/s");

figure(2)
plot(smoothedData_80,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Triangular pulley - speed 80 mm/s");

figure(3)
plot(smoothedData_120,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Triangular pulley - speed 120 mm/s");

