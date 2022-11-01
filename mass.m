% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% September 2022; Last revision: 19/09/2022

function [points_x,points_y] = mass(mass_x,mass_y,mass_d)

    points_x = [mass_x(1) mass_x(2) mass_x(3) mass_x(3) mass_x(2) mass_x(1) mass_x(1)];
    points_y = [mass_y mass_y mass_y...
        mass_y-mass_d mass_y-mass_d mass_y-mass_d mass_y];

end