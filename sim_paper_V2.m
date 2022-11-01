% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% September 2022; Last revision: 14/09/2022

% The speed of the mass is divided over 2. Otherwise, it would hit bearing 1.
% Search for 'SPEED CHANGED'.

close all;
clear all;
clc;

shift = 500 + 1000*225/360;

distance     = 30;
plot_video   = 1;
record_video = 1;

%%%%%%%%%%%% Loading Pulleys %%%%%%%%%%%%

load('different_envelopes/square_0.mat');
for i = 1:1000
    square_0{i} = all_data_for_perimeter{i}{1};
end
for i = 1:1000
    square_0{i+1000} = all_data_for_perimeter{i}{1};
end

load('different_envelopes/egg_real_2_0.mat');
for i = 1:1000
    oval_0{i} = all_data_for_perimeter{i}{1};
end
for i = 1:1000
    oval_0{i+1000} = all_data_for_perimeter{i}{1};
end

% We rotate the second pulley 135 degrees:

angle    = 0;
rotation = [cos(angle) -sin(angle); sin(angle) cos(angle)];
for i =1:2000
    oval_0{i} = oval_0{i} * rotation;
end

%%%%%%%%%%%% Loading Variables %%%%%%%%%%%%

load('./dudw_comparable/square_0.mat');
data_square_0 = dudw_comparable;
data_square_0_other = circshift(data_square_0,shift);
load('./dudw_comparable/square_80.mat');
data_square_80 = dudw_comparable;
data_square_80_other = circshift(data_square_80,shift);

load('./dudw_comparable/egg_real_2_0.mat');
data_oval_0 = dudw_comparable;
data_oval_0_other = circshift(data_oval_0,shift);
load('./dudw_comparable/egg_real_2_80.mat');
data_oval_80 = dudw_comparable;
data_oval_80_other = circshift(data_oval_80,shift);

load('belt_deformations/square_0.mat');
L_2_0 = data_regarding_belt{2};
L_3_0 = data_regarding_belt{3};
L_2_cont_0 = data_regarding_belt{7};
L_3_cont_0 = data_regarding_belt{8};
L_3_0 = circshift(L_3_0,1000*225/360);
L_3_cont_0 = circshift(L_3_cont_0,1000*225/360);

L_2_cont_0 = [L_2_cont_0 L_2_cont_0];
L_3_cont_0 = [L_3_cont_0 L_3_cont_0];

theta = -225; % With a 90, we rotate 90 counterclockwise.
R     = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%
val_corr = 18;
L_3_cont_0 = circshift(L_3_cont_0,-val_corr);
theta_corr = (val_corr/1000)*360;
R_CORRECTION = [cosd(theta_corr) -sind(theta_corr); sind(theta_corr) cosd(theta_corr)];
%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%
for i = 1:length(L_3_cont_0)
    
    aux = L_3_cont_0{i};
    aux = R_CORRECTION*aux';
    aux_2(2*i-1:2*i) = R*aux;
    aux_2(2*i-1:2*i) = aux_2(2*i-1:2*i) + [distance 0];
    
    aux_3 = L_2_cont_0{i};
    aux_4(2*i-1:2*i) = aux_3 + [distance 0];
    
end
L_3_cont_0 = aux_2;
L_2_cont_0 = aux_4;

load('belt_deformations/square_80.mat');
L_2_80 = data_regarding_belt{2};
L_3_80 = data_regarding_belt{3};
L_3_80 = circshift(L_3_80,1000*225/360);

load('belt_deformations/egg_real_2_0.mat');
L_4_0 = data_regarding_belt{2};
L_5_0 = data_regarding_belt{3};
L_4_cont_0 = data_regarding_belt{7};
L_5_cont_0 = data_regarding_belt{8};
L_5_0 = circshift(L_5_0,1000*225/360);
L_4_cont_0 = circshift(L_4_cont_0,1000*135/360);
L_5_cont_0 = circshift(L_5_cont_0,1000*(135+225)/360);

L_4_cont_0 = [L_4_cont_0 L_4_cont_0];
L_5_cont_0 = [L_5_cont_0 L_5_cont_0];

theta = -135; % With a 90, we rotate 90 counterclockwise.
R     = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%
val_corr = 18;
L_5_cont_0 = circshift(L_5_cont_0,-val_corr);
theta_corr = (val_corr/1000)*360;
R_CORRECTION = [cosd(theta_corr) -sind(theta_corr); sind(theta_corr) cosd(theta_corr)];
%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%%%%%%%%%%%
for i = 1:length(L_4_cont_0)
    
    aux = L_4_cont_0{i};
    aux_2(2*i-1:2*i) = R*aux';
    aux_2(2*i-1:2*i) = aux_2(2*i-1:2*i) + [distance -distance*sqrt(2)];
    
    aux_3 = L_5_cont_0{i};
    aux_3 = R_CORRECTION*aux_3';
    aux_4(2*i-1:2*i) = aux_3' + [distance -distance*sqrt(2)];
    
end
L_4_cont_0 = aux_2;
L_5_cont_0 = aux_4;

load('belt_deformations/egg_real_2_80.mat');
L_4_80 = data_regarding_belt{2};
L_5_80 = data_regarding_belt{3};
L_5_80 = circshift(L_5_80,1000*225/360);

%%%%%%%%%%%% Simulation %%%%%%%%%%%%

slack = [1.1 1.4 1.1 1.1 1.1 1.1];

t  = linspace(0,10,2000);
dt = (t(2) - t(1))*200;

accelerate_v4_flag = 0;
size_plots         = 2;
factor             = 1; % How much time faster?
factor             = factor / 2;

v_2 = [data_square_0 data_square_0];
v_3 = [data_square_0_other data_square_0_other];

v_4 = [data_oval_0 data_oval_0];
% We accelerate v_4:
if accelerate_v4_flag
    v_4_aux = [v_4 v_4];
    for i = 1:2000
        j = 2*i;
        v_4(i) = sum(v_4_aux(j-1:j))*factor;
    end
end
v_5 = [data_oval_0_other data_oval_0_other];

L_1 = ones(1,2000)*distance*sqrt(2)*0.9; % 90% of maximum length.
L_2 = [L_2_0 L_2_0];
L_3 = [L_3_0 L_3_0];
L_4 = [L_4_0 L_4_0];
L_5 = [L_5_0 L_5_0];
L_6 = distance*sqrt(2) - L_1(1);

E_1 = L_1 * slack(1);
E_2 = L_2(1) * slack(2);
E_3 = L_3(1) * slack(3);
E_4 = L_4(1) * slack(4);
E_5 = L_5(1) * slack(5);
E_6 = L_6 * slack(6);

vr_3 = zeros(1,length(t));
vr_1 = zeros(1,length(t));
x    = zeros(1,length(t));
rot_b1 = zeros(1,length(t));
rot_b3 = zeros(1,length(t));
rot_b5 = zeros(1,length(t));
vr_5   = zeros(1,length(t));
v_3_star = zeros(1,length(t));

f4 = zeros(1,2000);
f3 = zeros(1,2000);
f2 = zeros(1,2000);
f1 = zeros(1,2000);

% Looking for jumpting times for L_3 and L_4:
j_t_2 = [];
j_t_3 = [];
j_t_4 = [];
j_d_2 = [];
j_d_3 = [];
j_d_4 = [];
for i = 1:1999
    if L_2(i+1) < L_2(i)
        j_t_2(end+1) = i;
        j_d_2(end+1) = L_2(i) - L_2(i+1);
    end
    if L_3(i+1) > L_3(i)
        j_t_3(end+1) = i;
        j_d_3(end+1) = L_3(i+1) - L_3(i);
    end
    if L_4(i+1) < L_4(i)
        j_t_4(end+1) = i;
        j_d_4(end+1) = L_4(i) - L_4(i+1);
    end
end

figure; 
hold on;
xlim([-10 distance+distance/sqrt(2)+10]);
ylim([-10-distance*sqrt(2) 10]);
pbaspect([1 1 1]);
viscircles([0 0],8,'color',[0 0.4470 0.7410]);
plot(0,0,'p','MarkerFaceColor',[0.9290 0.6940 0.1250],'MarkerSize',10,'MarkerEdgeColor','blue');
viscircles([0 -distance*sqrt(2)],8,'color',[0 0.4470 0.7410]);
plot(0,-distance*sqrt(2),'p','MarkerFaceColor',[0.9290 0.6940 0.1250],'MarkerSize',...
    10,'MarkerEdgeColor','blue');
viscircles([distance+distance/sqrt(2) -distance/sqrt(2)],8,'color',[0 0.4470 0.7410]);
plot(distance+distance/sqrt(2),-distance/sqrt(2),...
    'p','MarkerFaceColor',[0.9290 0.6940 0.1250],'MarkerSize',10,'MarkerEdgeColor','blue');
plot(distance,0,...
    'p','MarkerFaceColor',[0.9290 0.6940 0.1250],'MarkerSize',10,'MarkerEdgeColor','blue');
plot(distance,-distance*sqrt(2),...
    'p','MarkerFaceColor',[0.9290 0.6940 0.1250],'MarkerSize',10,'MarkerEdgeColor','blue');
box on;
grid minor;

control_vars = [0 0 0 0 0]; % E1/L1 ... E5/L5.

mass_x = [-10 -8 -6];
mass_y = [-distance*sqrt(2) * 0.8];
mass_d = distance*sqrt(2) * 0.05;

cont = 0;

four_points_b1 = [-2.5 -2.5 2.5 2.5; -2.5 2.5 -2.5 2.5];
four_points_b3 = four_points_b1;
four_points_b5 = four_points_b1;

for i = 2:length(t)

    if E_4(i-1) <= L_4(i-1) || control_vars(4)
        E_4(i)          = L_4(i);
        vr_3(i)         = v_4(i);
        control_vars(4) = 1;
        f4(i)           = 4;
    else
        if sum(j_t_4 == i) == 1
            E_4(i) = E_4(i-1) - j_d_4(j_t_4 == i);
        else
            E_4(i) = E_4(i-1);
        end
    end

    if E_3(i-1) <= L_3(i-1)
        v_3_star(i) = vr_3(i) - v_3(i);
        f3(i)       = 3;
        if v_3_star(i) < 0
            v_3_star(i) = 0;
            f3(i)       = 0;
        end
    else
        v_3_star(i) = 0;
    end
    E_3(i) = E_3(i-1) + dt*(v_3_star(i) - vr_3(i));
    if sum(j_t_3 == i) == 1
        E_3(i) = E_3(i) + j_d_3(j_t_3 == i);
    end

    if E_2(i-1) <= L_2(i-1) || control_vars(2)
        E_2(i)  = L_2(i);
        vr_1(i) = v_2(i) + v_3_star(i);
        control_vars(2) = 1;
        f2(i)           = 2;
    else
        E_2(i) = E_2(i-1) - dt*v_3_star(i);
        if sum(j_t_2 == i) == 1
            E_2(i) = E_2(i-1) - j_d_2(j_t_2 == i);
        end
    end
    
    E_1(i) = E_1(i-1) - dt*vr_1(i);
    if E_1(i) <= L_1(i)
        x(i)   = x(i-1) + dt*vr_1(i);
        vr_5(i) = x(i)-x(i-1);
        E_1(i) = E_1(i-1) - dt*vr_1(i);
        L_1(i) = E_1(i);
        f1(i)  = 1;
        mass_y = mass_y + dt*vr_1(i)/2.5; % SPEED CHANGED.
    end
    
%     vr_3
%     vr_1

    rot_b1(i) = rot_b1(i-1) + vr_1(i)/8;
    rot_b3(i) = rot_b3(i-1) + vr_3(i)/8;
    rot_b5(i) = rot_b5(i-1) + vr_5(i)/8;
    rotation_b1 = [cos(rot_b1(i)) -sin(rot_b1(i)); sin(rot_b1(i)) cos(rot_b1(i))];
    rotation_b3 = [cos(rot_b3(i)) -sin(rot_b3(i)); sin(rot_b3(i)) cos(rot_b3(i))];
    rotation_b5 = [cos(rot_b5(i)) -sin(rot_b5(i)); sin(rot_b5(i)) cos(rot_b5(i))];
    plot_four_points_b1 = four_points_b1' * rotation_b1;
    plot_four_points_b3 = four_points_b3' * rotation_b3;
    plot_four_points_b5 = four_points_b5' * rotation_b5;
    plot_four_points_b1 = f_p_bx(plot_four_points_b1',[0 0]);
    plot_four_points_b3 = f_p_bx(plot_four_points_b3',[30+30/sqrt(2) -30/sqrt(2)]);
    plot_four_points_b5 = f_p_bx(plot_four_points_b5',[0 -30*sqrt(2)]);
        
    %%%%%%%%%%%%%%%%%% Plotting (STARTS) %%%%%%%%%%%%%%%%%%
    
    if plot_video
    
    B_1_n  = [0,8]; % Bearing 1 north.
    B_1_w = [-8,0]; % Bearing 1 west.
    B_3_ne  = [distance+distance/sqrt(2)+sqrt(32),-distance/sqrt(2)+sqrt(32)]; % Bearing 3 north-east.
    B_3_se  = [distance+distance/sqrt(2)+sqrt(32),-distance/sqrt(2)-sqrt(32)]; % Bearing 3 south-east.
    B_5_s  = [0,-distance*sqrt(2)-8]; % Bearing 5 south.
    B_5_w = [-8,-distance*sqrt(2)]; % Bearing 5 west.
    
    try
        delete(contact_2);
        delete(contact_3);
        delete(contact_4);
        delete(contact_5);
        delete(line_1);
        delete(line_2);
        delete(line_3);
        delete(line_4);
        delete(line_5);
        delete(line_6);
        delete(square);
        delete(oval);
        delete(mass_plot);
        delete(four_b1);
        delete(four_b3);
        delete(four_b5);
        mass_x_plot = [];
        mass_y_plot = [];
    end
    
    [mass_x_plot,mass_y_plot] = mass(mass_x,mass_y,mass_d);
    
    mass_plot = plot(mass_x_plot,mass_y_plot,'LineWidth',2,'color',[0 0.4470 0.7410]);
    
    color_line_5 = [0.4660 0.6740 0.1880];
    color_line_6 = [0.4660 0.6740 0.1880];
    if E_4(i-1) <= L_4(i-1)
        color_line_4 = [0.8500 0.3250 0.0980];
    else
        color_line_4 = [0.4660 0.6740 0.1880];
    end
    if E_3(i-1) <= L_3(i-1)
        color_line_3 = [0.8500 0.3250 0.0980];
    else
        color_line_3 = [0.4660 0.6740 0.1880];
    end
    if E_2(i-1) <= L_2(i-1)
        color_line_2 = [0.8500 0.3250 0.0980];
    else
        color_line_2 = [0.4660 0.6740 0.1880];
    end
    if E_1(i-1) <= L_1(i-1)
        color_line_1 = [0.8500 0.3250 0.0980];
        color_line_6 = [0.8500 0.3250 0.0980];
    else
        color_line_1 = [0.4660 0.6740 0.1880];
    end
    if v_3_star(i) ~= 0
        color_line_1 = 'red';
        color_line_2 = 'red';
        color_line_3 = 'red';
        color_line_4 = 'red';
    end

    contact_2 = plot(L_2_cont_0(2*i-1),L_2_cont_0(2*i),'o','MarkerSize',5,'color','r');
    contact_3 = plot(L_3_cont_0(2*i-1),L_3_cont_0(2*i),'o','MarkerSize',5,'color','b');
    
    contact_4 = plot(L_4_cont_0(2*i-1),L_4_cont_0(2*i),'o','MarkerSize',5,'color','r');
    contact_5 = plot(L_5_cont_0(2*i-1),L_5_cont_0(2*i),'o','MarkerSize',5,'color','b');
    
    line_1 = plot([B_1_w(1) mass_x(2)],[B_1_w(2) mass_y],...
        'LineWidth',2,'color',color_line_1);
    line_2 = plot([B_1_n(1) L_2_cont_0(2*i-1)],[B_1_n(2) L_2_cont_0(2*i)],...
        'LineWidth',2,'color',color_line_2);
    line_3 = plot([B_3_ne(1) L_3_cont_0(2*i-1)],[B_3_ne(2) L_3_cont_0(2*i)],...
        'LineWidth',2,'color',color_line_3);
    line_4 = plot([B_3_se(1) L_4_cont_0(2*i-1)],[B_3_se(2) L_4_cont_0(2*i)],...
        'LineWidth',2,'color',color_line_4);
    line_5 = plot([B_5_s(1) L_5_cont_0(2*i-1)],[B_5_s(2) L_5_cont_0(2*i)],...
        'LineWidth',2,'color',color_line_5);
    line_6 = plot([B_5_w(1) mass_x(2)],[B_5_w(2) mass_y-mass_d],...
        'LineWidth',2,'color',color_line_6);
    
    square = plot(square_0{i}(:,1)+distance,square_0{i}(:,2),...
        'color',[0.8500 0.3250 0.0980],'LineWidth',2);
    oval   = plot(oval_0{i}(:,1)+distance,oval_0{i}(:,2)-distance*sqrt(2),...
        'color',[0.8500 0.3250 0.0980],'LineWidth',2);
    
    four_b1 = plot(plot_four_points_b1(1,:),plot_four_points_b1(2,:),'ob');
    four_b3 = plot(plot_four_points_b3(1,:),plot_four_points_b3(2,:),'ob');
    four_b5 = plot(plot_four_points_b5(1,:),plot_four_points_b5(2,:),'ob');
    
    pause(0.001);
    
    if record_video
        video_step = 2;
        if mod(i,video_step)==0
            cont = cont + 1;
            G(cont)=getframe(gcf);
            pause(0.001);
        end
    end
    
    end
    
	%%%%%%%%%%%%%%%%%% Plotting (ENDS) %%%%%%%%%%%%%%%%%%
    
end

if record_video
    % Create the video writer with 1 FPS
    writerObj = VideoWriter('video');
    writerObj.FrameRate = 20;
    % Set the seconds per image
    % Open the video writer
    open(writerObj);
    % Write the frames to the video
    for i=1:length(G)
        % Convert the image to a frame
        frame = G(i) ;    
        writeVideo(writerObj, frame);
    end
    % Close the writer object
    close(writerObj);
end