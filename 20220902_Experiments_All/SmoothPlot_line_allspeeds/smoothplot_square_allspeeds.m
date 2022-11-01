close all
clear all
%%%%%%%% Derivative %%%%%%%%%%%%
load('dudt_square_40.mat');
load('dudt_square_80.mat');
load('dudt_square_120.mat');


dudt_40_zoom= (dudt_40(58658:62756));
dudt_80_zoom=  (dudt_80(55741:58500));
dudt_120_zoom= (dudt_120(58265:60350));



% Smooth input data
smoothedData_40 = smoothdata(dudt_40_zoom,'lowess','SmoothingFactor',0.9599999999999999); %Change the smooth factor here
smoothedData_80 = smoothdata(dudt_80_zoom,'lowess','SmoothingFactor',0.899999999999999);
smoothedData_120 = smoothdata(dudt_120_zoom,'lowess','SmoothingFactor',0.839999999999999);


% Display results
figure(1)
plot(smoothedData_40,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Squared pulley - speed 40 mm/s");

figure(2)
plot(smoothedData_80,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Squared pulley - speed 80 mm/s");

figure(3)
plot(smoothedData_120,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
title("Squared pulley - speed 120 mm/s");

