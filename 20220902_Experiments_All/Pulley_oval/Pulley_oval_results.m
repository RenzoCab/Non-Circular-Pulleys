close all
clear all

tested_pulley = "Oval";
filename_40   = "40_oval_zyx";
filename_80   = "80_oval_zyx";
filename_120  = "120_oval_zyx";

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

vector_time   = t_40(17024:31344);
vector_time_1 = vector_time(1428:5030);
vector_time_2 = vector_time(5716:9347);
delta_t       = vector_time_1(500) - vector_time_1(499);

vector_xn   = X_n_40(17024:31344);
vector_xn_1 = vector_xn(1428:5030);
vector_xn_2 = vector_xn(5716:9347);

vector_xp   = X_p_40(17024:31344);
vector_xp_1 = vector_xp(1428:5030);
vector_xp_2 = vector_xp(5716:9347);

vector_yn   = Y_n_40(17024:31344);
vector_yn_1 = vector_yn(1428:5030);
vector_yn_2 = vector_yn(5716:9347);

vector_pn   = Y_p_40(17024:31344);
vector_pn_1 = vector_pn(1428:5030);
vector_pn_2 = vector_pn(5716:9347);

vector_rot_y   = ry_40(17024:31344);
vector_rot_y_1 = vector_rot_y(1428:5030); % Anticlockwise
vector_rot_y_2 = vector_rot_y(5716:9347); % Clockwise

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

for i= 1:size(vector_rot_y_1)
    dist_pulley_nuzzle_x_1(i) = ...
        sqrt((vector_xn_1(i)-vector_xp_1(i))^2 + (vector_yn_1(i)-vector_pn_1(i))^2);
end
for i= 1:size(vector_rot_y_2)
    dist_pulley_nuzzle_x_2(i) = ...
        sqrt((vector_xn_2(i)-vector_xp_2(i))^2 + (vector_yn_2(i)-vector_pn_2(i))^2);
end

grad_x_1 = gradient(dist_pulley_nuzzle_x_1)/delta_t;
grad_x_2 = gradient(dist_pulley_nuzzle_x_2)/delta_t;

delta_x_1 = (dist_pulley_nuzzle_x_1(2:end) - dist_pulley_nuzzle_x_1(1:end-1)) ./...
    (vector_time_1(2:end) - vector_time_1(1:end-1))';
delta_x_2 = (dist_pulley_nuzzle_x_2(2:end) - dist_pulley_nuzzle_x_2(1:end-1)) ./...
    (vector_time_2(2:end) - vector_time_2(1:end-1))';

smooth_factor = 0.92;
dudw_x_1_smooth  = smoothdata(grad_x_1,'lowess',...
    'SmoothingFactor',smooth_factor);
dudw_x_2_smooth  = smoothdata(grad_x_2,'lowess',...
    'SmoothingFactor',smooth_factor);

plot(grad_x_1);
hold on;
plot(dudw_x_1_smooth);

figure;
plot(grad_x_2);
hold on;
plot(dudw_x_2_smooth);

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

% Centering

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
%%


%%%%%%%% Derivative %%%%%%%%%%%%
dudt_40= gradient (d_nozzle_pulley_40(:));
dudt_80= gradient (d_nozzle_pulley_80(:));
dudt_120= gradient (d_nozzle_pulley_120(:));

dudt_40_zoom = (dudt_40(58530:62690));
dudt_80_zoom =  (dudt_80(55545:58288));
dudt_120_zoom = (dudt_120(57410:59473));

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


figure(2)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_40(58470:66813),'b--');
title(strcat('Displacement at speed 40 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_40(58470:66813),'b*-');
title('Rotaion (Yaw)'); 
xlabel('Time'); 
ylabel('degrees');

nexttile
plot(dudt_40(58470:66813));
title('Displacement derivative - speed 40');

figure(3)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_80(55667:61024),'b--');
title(strcat('Displacement at speed 80 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_80(55667:61024),'b*-');
title('Rotaion (Yaw)'); 
xlabel('Time'); 
ylabel('degrees');

nexttile
plot(dudt_80(55667:61024));
title('Displacement derivative - speed 80');

figure(4)
tiledlayout(3,1);

nexttile
plot(d_nozzle_pulley_120(57469:61468),'b--');
title(strcat('Displacement at speed 120 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_120(57469:61468),'b*-');
title('Rotaion (Yaw)'); 
xlabel('Time'); 
ylabel('degrees');

nexttile
plot(dudt_120(57469:61468));
title('Displacement derivative - speed 120');



figure(5)
tiledlayout(3,1);
nexttile
plot(d_nozzle_pulley_40(58530:62690),'b--');
title(strcat('Displacement at speed 40 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_40(58530:62690),'b*-');
title('Nozzle rotation'); 
xlabel('Time'); 
ylabel('degrees');

% Smooth input data
smoothedData1 = smoothdata(dudt_40_zoom,...
    'lowess','SmoothingFactor',0.899999999999999);

% Display results
nexttile
plot(smoothedData1,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
yticks(0:0.02:0.08);
ylim([0 0.08]);
savefig('oval_40.fig')

figure(6)
tiledlayout(3,1);
nexttile
plot(d_nozzle_pulley_80(55545:58288),'b--');
title(strcat('Displacement at speed 80 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');

nexttile
plot(ry_80(55545:58288),'b*-');
title('Nozzle rotation'); 
xlabel('Time'); 
ylabel('degrees');

% Smooth input data
smoothedData2 = smoothdata(dudt_80_zoom,...
    'lowess','SmoothingFactor',0.899999999999999);

% Display results
nexttile
plot(smoothedData2,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
ylim([0 0.08]);
savefig('oval_80.fig')



figure(7)
tiledlayout(3,1);
nexttile

plot(d_nozzle_pulley_120(57410:59473),('b--'));
title(strcat('Displacement at speed 120 - ', tested_pulley)); 
xlabel('Time'); 
ylabel('d (mm)');


nexttile
plot(ry_120(57410:59473),'b*-');
title('Nozzle rotation'); 
xlabel('Time'); 
ylabel('degrees');

% Smooth input data
smoothedData3 = smoothdata(dudt_120_zoom,...
    'lowess','SmoothingFactor',0.839999999999999);

% Display results
nexttile
plot(smoothedData3,'Color',[0 114 189]/255,'LineWidth',1.5,...
    'DisplayName','Smoothed data')
ylim([0 0.08]);
savefig('oval_120.fig')



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
ylim([0 230])

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
ylim([0 230])

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
ylim([0 230])


% Save derivatives
save("dudt_oval_40.mat", "dudt_40");
save("dudt_oval_80.mat", "dudt_80");
save("dudt_oval_120.mat", "dudt_120");