function [u_w, v_w, theta_w] = get_turb_flux(out, rotate_w)

% get_turb_flux
%==========================================================================
%
% USAGE:
%  [u_w, v_w, theta_w] = get_turb_flux(model_par, out, rotate_w)

%
% DESCRIPTION:
%  Compute the turbulent momentum flux and turbulent heat flux using output
%  from GOTM simulation
%
% INPUT:
%
%  model_par - A struct containing parameters used in the model
%  out - A struct containing all the model output from GOTM
%  rotate_w - 1 or 0 (1 represents rotating current according to wind to 
%    get downwind and crosswind component)
% 
% OUTPUT:
%
%  u_w - turbulent x-momentum flux [m^2/s^2]
%  v_w - turbulent y-momentum flux [m^2/s^2]
%  theta_w - turbulent heat flux [K*m/s]
%
% AUTHOR:
%  September 16 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%

%% TO-DO

% 1. check if the velocity and temprature output are averaged quantities
%    - Using these output as averaged quantities is ok!

%% Note

% 1. cmue1 = sqrt(2)*Sm ... 
% 2. num = cmue1*sqrt(tke)*L = Sm*sqrt(2*tke)*L = Sm*q*L ...

%% Read relevant variables

z = mean(out.z,2);
temp = out.temp;

% sacrifice data at both end of z-direction, staggered grid
nu_m = out.nu_m(2:end-1,:);
nu_h = out.nu_h(2:end-1,:);
nu_cl = out.nu_cl(2:end-1,:);

%% Rotation of coordinate

% The interpolation approach has been changed to use center_diff instead
    
if rotate_w
    
     new_vec = rotate_coor(out);
     
     u = new_vec.u;
     v = new_vec.v;
     u_stokes = new_vec.u_stokes;
     v_stokes = new_vec.v_stokes;
else
    u = out.u;
    v = out.v;
    u_stokes = out.u_stokes;
    v_stokes = out.v_stokes;
end

%% Eulerian shear
u_z = center_diff(u,z,1);
v_z = center_diff(v,z,1);

%% Stokes shear
uStokes_z = center_diff(u_stokes,z,1);
vStokes_z = center_diff(v_stokes,z,1);

%% Temperature gradient
temp_z = center_diff(temp,z,1);

%% Computation
u_w = -(nu_m.*u_z + nu_cl.*uStokes_z);
v_w = -(nu_m.*v_z + nu_cl.*vStokes_z);
theta_w = -(nu_h.*temp_z);

end
