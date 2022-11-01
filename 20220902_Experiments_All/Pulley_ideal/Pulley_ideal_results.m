close all
clear all

tested_pulley = "Ideal";
filename_40   = "40_ideal_zyx";
filename_80   = "80_ideal_zyx";
filename_120  = "120_ideal_zyx"; 

%%%%%%%% Raw Data speed 40 %%%%%%%%%%%
% Pulley 
T_pulley_40= readtable(filename_40,'Range','B:H');
t_40=table2array(T_pulley_40(:,1));
% Rotation z,y,x
rz_40=table2array(T_pulley_40(:,2));
ry_40=table2array(T_pulley_40(:,3));
rx_40=table2array(T_pulley_40(:,4));
% Position x,y,z
X_p_40=table2array(T_pulley_40(:,5));
Y_p_40=table2array(T_pulley_40(:,7));
Z_p_40=table2array(T_pulley_40(:,6));

% Nozzle
T_nozzle_40= readtable(filename_40,'Range','M:O');
% Position x,y,z
X_n_40=table2array(T_nozzle_40(:,1));
Y_n_40=table2array(T_nozzle_40(:,3));
Z_n_40=table2array(T_nozzle_40(:,2));

%%%%%%%%%%%%%%%%%%%%%% EDIT (BEGINS) %%%%%%%%%%%%%%%%%%%%%%

vector_time   = t_40(31345:42663);
vector_time_1 = vector_time(2517:6119);
vector_time_2 = vector_time(6538:10169);
delta_t       = vector_time_1(500) - vector_time_1(499);

vector_xn   = X_n_40(31345:42663);
vector_xn_1 = vector_xn(2517:6119);
vector_xn_2 = vector_xn(6538:10169);

vector_xp   = X_p_40(31345:42663);
vector_xp_1 = vector_xp(2517:6119);
vector_xp_2 = vector_xp(6538:10169);

vector_zn   = Z_n_40(31345:42663);
vector_zn_1 = vector_zn(2517:6119);
vector_zn_2 = vector_zn(6538:10169);

vector_zp   = Z_p_40(31345:42663);
vector_zp_1 = vector_zp(2517:6119);
vector_zp_2 = vector_zp(6538:10169);

vector_yn   = Y_n_40(31345:42663);
vector_yn_1 = vector_yn(2517:6119);
vector_yn_2 = vector_yn(6538:10169);

vector_yp   = Y_p_40(31345:42663);
vector_yp_1 = vector_yp(2517:6119);
vector_yp_2 = vector_yp(6538:10169);

vector_rot_y   = ry_40(31345:42663);
vector_rot_y_1 = vector_rot_y(2517:6119); % Anticlockwise
vector_rot_y_2 = vector_rot_y(6538:10169); % Clockwise

% We might still need to correct the Z inclination.

for i = 1:length(vector_xn_1)
    if isnan(vector_xn(i))
        nan_1(i) = 1;
    else
        nan_1(i) = 0;
    end
end

for i = 1:length(vector_xn_2)
    if isnan(vector_xn_2(i))
        nan_2(i) = 1;
    else
        nan_2(i) = 0;
    end
end

if 1==0

    for i= 1:size(vector_rot_y_1)
        dist_pulley_nuzzle_x_1(i) = ...
            sqrt((vector_xn_1(i)-vector_xp_1(i))^2 + (vector_yn_1(i)-vector_yp_1(i))^2);
    end
    for i= 1:size(vector_rot_y_2)
        dist_pulley_nuzzle_x_2(i) = ...
            sqrt((vector_xn_2(i)-vector_xp_2(i))^2 + (vector_yn_2(i)-vector_yp_2(i))^2);
    end

else

    x_mean_pulley_1 = mean(vector_xp_1(~isnan(vector_xp_1)));
    x_mean_pulley_2 = mean(vector_xp_2(~isnan(vector_xp_2)));
    y_mean_pulley_1 = mean(vector_yp_1(~isnan(vector_yp_1)));
    y_mean_pulley_2 = mean(vector_yp_2(~isnan(vector_yp_2)));

    for i= 1:size(vector_rot_y_1)
        dist_pulley_nuzzle_x_1(i) = ...
            sqrt((vector_xn_1(i)-x_mean_pulley_1)^2 + (vector_yn_1(i)-y_mean_pulley_1)^2);
    end
    for i= 1:size(vector_rot_y_2)
        dist_pulley_nuzzle_x_2(i) = ...
            sqrt((vector_xn_2(i)-x_mean_pulley_2)^2 + (vector_yn_2(i)-y_mean_pulley_2)^2);
    end

end

grad_x_1 = gradient(dist_pulley_nuzzle_x_1)/delta_t;
grad_x_2 = gradient(dist_pulley_nuzzle_x_2)/delta_t;

delta_x_1 = (dist_pulley_nuzzle_x_1(2:end) - dist_pulley_nuzzle_x_1(1:end-1)) ./...
    (vector_time_1(2:end) - vector_time_1(1:end-1))';
delta_x_2 = (dist_pulley_nuzzle_x_2(2:end) - dist_pulley_nuzzle_x_2(1:end-1)) ./...
    (vector_time_2(2:end) - vector_time_2(1:end-1))';

% close all;

smooth_factor = 0.995;
dudw_x_1_smooth  = smoothdata(grad_x_1,'lowess',...
    'SmoothingFactor',smooth_factor);
dudw_x_2_smooth  = smoothdata(grad_x_2,'lowess',...
    'SmoothingFactor',smooth_factor);
smooth_factor = 0.5;
dudw_z_1_smooth  = smoothdata(vector_zn_1,'lowess',...
    'SmoothingFactor',smooth_factor);
dudw_z_2_smooth  = smoothdata(vector_zn_2,'lowess',...
    'SmoothingFactor',smooth_factor);

plot(grad_x_1);
hold on;
plot(dudw_x_1_smooth);
plot(dudw_z_1_smooth);

figure;
plot(grad_x_2);
hold on;
plot(dudw_x_2_smooth);
plot(dudw_z_2_smooth);

for i = 0:199
    aux(i+1) = mean(grad_x_1(1+i*18:18+i*18));
end

%%%%%%%%%%%%%%%%%%%%%% EDIT (ENDS) %%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Raw Data speed 80 %%%%%%%%%%%
% Pulley 
T_pulley_80= readtable(filename_80,'Range','B:H');
t_80=table2array(T_pulley_80(:,1));
% Rotation z,y,x
rz_80=table2array(T_pulley_80(:,2));
ry_80=table2array(T_pulley_80(:,3));
rx_80=table2array(T_pulley_80(:,4));
% Position x,y,z
X_p_80=table2array(T_pulley_80(:,5));
Y_p_80=table2array(T_pulley_80(:,7));
Z_p_80=table2array(T_pulley_80(:,6));


% Nozzle
T_nozzle_80= readtable(filename_80,'Range','M:O');
% Position x,y,z
X_n_80=table2array(T_nozzle_80(:,1));
Y_n_80=table2array(T_nozzle_80(:,3));
Z_n_80=table2array(T_nozzle_80(:,2));


%%%%%%%% Raw Data speed 120 %%%%%%%%%%%
% Pulley 
T_pulley_120= readtable(filename_120,'Range','B:H');
t_120=table2array(T_pulley_120(:,1));
% Rotation z,y,x
rz_120=table2array(T_pulley_120(:,2));
ry_120=table2array(T_pulley_120(:,3));
rx_120=table2array(T_pulley_120(:,4));
% Position x,y,z
X_p_120=table2array(T_pulley_120(:,5));
Y_p_120=table2array(T_pulley_120(:,7));
Z_p_120=table2array(T_pulley_120(:,6));


% Nozzle
T_nozzle_120= readtable(filename_120,'Range','M:O');
% Position x,y,z
X_n_120=table2array(T_nozzle_120(:,1));
Y_n_120=table2array(T_nozzle_120(:,3));
Z_n_120=table2array(T_nozzle_120(:,2));

%centering
% offset_x_40 = abs(X_n_40(1) - X_p_40(1));
% offset_x_80 = abs(X_n_80(1) - X_p_80(1));
% offset_x_120 = abs(X_n_120(1) - X_p_120(1));
% offset_y_40 = abs(Y_n_40(1) - Y_p_40(1));
% offset_y_80 = abs(Y_n_80(1) - Y_p_80(1));
% offset_y_120 = abs(Y_n_120(1) - Y_p_120(1));
 
X_p_40=X_p_40-X_p_40(1);
X_p_80=X_p_80-X_p_80(1);
X_p_120=X_p_120-X_p_120(1);

Y_p_40=-(Y_p_40 -Y_p_40(1));
Y_p_80=-(Y_p_80 -Y_p_80(1));
Y_p_120=-(Y_p_120 -Y_p_120(1)) ;

X_n_40=X_n_40-X_n_40(1);
X_n_80=X_n_80-X_n_80(1);
X_n_120=X_n_120-X_n_120(1);

Y_n_40=-(Y_n_40 - Y_n_40(1));
Y_n_80=-(Y_n_80 - Y_n_80(1));
Y_n_120=-(Y_n_120 - Y_n_120(1));

%%
%%%%%%%% Displacement %%%%%%%%%

for i= 1:size(X_n_40)-1
    d_nozzle_pulley_40(i)=sqrt((X_n_40(i)-X_p_40(i))^2+(Y_n_40(i)-Y_p_40(i))^2+((Z_n_40(i)-Z_n_40(1))-(Z_p_40(i)-Z_p_40(1)))^2);
end

for i= 1:size(X_n_80)-1
    d_nozzle_pulley_80(i)=sqrt((X_n_80(i)-X_p_80(i))^2+(Y_n_80(i)-Y_p_80(i))^2+((Z_n_80(i)-Z_n_80(1))-(Z_p_80(i)-Z_p_80(1)))^2);
end

for i= 1:size(X_n_120)-1
    d_nozzle_pulley_120(i)=sqrt((X_n_120(i)-X_p_120(i))^2+(Y_n_120(i)-Y_p_120(i))^2+((Z_n_120(i)-Z_n_120(1))-(Z_p_120(i)-Z_p_120(1)))^2);
end

%%%%%%%% Derivative %%%%%%%%%%%%
dudt_40= gradient (d_nozzle_pulley_40(:));
dudt_80= gradient (d_nozzle_pulley_80(:));
dudt_120= gradient (d_nozzle_pulley_120(:));

dudt_40_zoom = (dudt_40(73790:77990));
dudt_80_zoom =  (dudt_80(62200:64694));
dudt_120_zoom = (dudt_120(61645:63952));

%%%%%%%% Plots %%%%%%%%%%%%

figure(1)
tiledlayout(3,3);
% Speed 40
nexttile
plot(X_n_40,'b--');
title('X axis - speed 40'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Y_n_40,'b--');
title('Y axis'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Z_n_40,'b--');
title('Z axis'); 
xlabel('Time'); 
ylabel('d (mm)');

% Speed 80
nexttile
plot(X_n_80,'b--');
title('X axis - speed 80'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Y_n_80,'b--');
title('Y axis'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Z_n_80,'b--');
title('Z axis'); 
xlabel('Time'); 
ylabel('d (mm)');

% Speed 120
nexttile
plot(X_n_120,'b--');
title('X axis - speed 120'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Y_n_120,'b--');
title('Y axis'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(Z_n_120,'b--');
title('Z axis'); 
xlabel('Time'); 
ylabel('d (mm)');

%%%%%%%%%%%%%%% figure 2 %%%%%%%%%%%%%%%
figure(2)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_40(73750:82162),'b--');
title('Displacement at speed 40'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_40(73750:82162),'b*-');
title('Displacement at speed 40'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(dudt_40(73750:82162));
title('Displacement derivative at speed 40'); 
xlabel('Time'); 
ylabel('d (mm)');

%%%%%%%%%%%%%%% figure 3 %%%%%%%%%%%%%%%

figure(3)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_80(62400:67929),'b--');
title('Displacement at speed 80'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_80(62400:67929),'b*-');
title('Rotaion (Yaw)'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(dudt_80(62400:67929));
title('Displacement derivative at speed 80'); 
xlabel('Time'); 
ylabel('d (mm)');

%%%%%%%%%%%%%%% figure 4 %%%%%%%%%%%%%%%

figure(4)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_120(61645:65952),'b--');
title('Displacement at speed 120'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_120(61645:65952),'b*-');
title('Rotaion (Yaw)'); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(dudt_120(61645:65952));
title('Displacement derivative at speed 120'); 
xlabel('Time'); 
ylabel('d (mm)');



figure(5)
tiledlayout(2,1);

nexttile
plot(d_nozzle_pulley_40(73790:77990),'b--');
title('Displacement at speed 40'); 
xlabel('Time'); 
ylabel('d (mm)');


% Smooth input data
smoothedData1 = smoothdata(dudt_40_zoom,'lowess','SmoothingFactor',0.95);

% Display results
nexttile
plot(smoothedData1,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
ylim([-0.05 0.1]);
savefig('ideal_40.fig')


figure(6)
tiledlayout(2,1);

nexttile
plot(d_nozzle_pulley_80(62300:64594),'b--');
title('Displacement at speed 80'); 
xlabel('Time'); 
ylabel('d (mm)');

% Smooth input data
smoothedData2 = smoothdata(dudt_80_zoom,'lowess','SmoothingFactor',0.9);

% Display results
nexttile
plot(smoothedData2,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
ylim([-1 1]);
savefig('ideal_80.fig')


figure(7)
tiledlayout(2,1);

nexttile
plot(d_nozzle_pulley_120(61645:63952),'b--');
title('Displacement at speed 120'); 
xlabel('Time'); 
ylabel('d (mm)');

% Smooth input data
smoothedData3 = smoothdata(dudt_120_zoom,'lowess','SmoothingFactor',0.4);

% Display results
nexttile
plot(smoothedData3,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
ylim([-1 1]);
savefig('ideal_120.fig')

figure (8)
tiledlayout(3,3);
% Speed 40
nexttile
plot(X_n_40,'b--');
title('X axis reading'); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

nexttile
plot(Y_n_40,'b--');
title({'Printing speed 40 mm/s',' Y axis reading'}); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

nexttile
plot(d_nozzle_pulley_40,'b--');
title('Displacement of the X axis'); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

% Speed 80
nexttile
plot(X_n_80,'b--');
title('X axis reading'); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

nexttile
plot(Y_n_80,'b--');
title({'Printing speed 80 mm/s',' Y axis reading'}); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 200])

nexttile
plot(d_nozzle_pulley_80,'b--');
title('Displacement of the X axis'); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

% Speed 120
nexttile
plot(X_n_120,'b--');
title('X axis reading '); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

nexttile
plot(Y_n_120,'b--');
title({'Printing speed 120 mm/s',' Y axis reading'}); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

nexttile
plot(d_nozzle_pulley_120,'b--');
title('Displacement of the X axis'); 
xlabel('Time'); 
ylabel('d (mm)');
ylim([0 210])

% Save derivatives
save("C:\Users\preciaac\Documents\PhD\SelfRepairing_Research\Tracking_experiment\SmoothPlot_ideal_allspeeds\dudt_ideal_40.mat", "dudt_40");
save("C:\Users\preciaac\Documents\PhD\SelfRepairing_Research\Tracking_experiment\SmoothPlot_ideal_allspeeds\dudt_ideal_80.mat", "dudt_80");
save("C:\Users\preciaac\Documents\PhD\SelfRepairing_Research\Tracking_experiment\SmoothPlot_ideal_allspeeds\dudt_ideal_120.mat", "dudt_120");
