% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% September 2022; Last revision: 19/09/2022

function [four_points] = f_p_bx(four_points,xy)

    four_points(1,:) = four_points(1,:) + xy(1);
    four_points(2,:) = four_points(2,:) + xy(2);

end