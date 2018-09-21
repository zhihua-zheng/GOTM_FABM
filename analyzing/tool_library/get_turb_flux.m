function [u_w, v_w, theta_w] = get_turb_flux(model_par, out)

% get_turb_flux
%==========================================================================
%
% USAGE:
%  [u_w, v_w, theta_w] = get_turb_flux()

%
% DESCRIPTION:
%  Compute the turbulent momentum flux and turbulent heat flux using output
%  from GOTM simulation
%
% INPUT:
%
%  model_par - A struct containing parameters used in the model
%  out - A struct containing all the model output from GOTM
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

dt = model_par.dt;
nsave = model_par.nsave;

%% Deal with staggered grid

% This interpolation approach may need to be modified in future

Zi = out.zi;
Ti = repmat(out.time',size(Zi,1),1);
Z = out.z;
T = repmat(out.time',size(Z,1),1);

u = interp2(T,Z,out.u,Ti,Zi,'linear');
v = interp2(T,Z,out.v,Ti,Zi,'linear');
u_stokes = interp2(T,Z,out.u_stokes,Ti,Zi,'linear');
v_stokes = interp2(T,Z,out.v_stokes,Ti,Zi,'linear');
temp = interp2(T,Z,out.temp,Ti,Zi,'linear');

%% Eulerian shear
[~, u_z] = gradient(u,dt*nsave,out.z);
[~, v_z] = gradient(v,dt*nsave,out.z);

%% Stokes shear
[~, uStokes_z] = gradient(u_stokes,dt*nsave,out.z);
[~, vStokes_z] = gradient(v_stokes,dt*nsave,out.z);

%% Temperature gradient
[~, temp_z] = gradient(temp,dt*nsave,out.z);

%% Computation
u_w = -(out.nu_m.*u_z + out.nu_cl.*uStokes_z);
v_w = -(out.nu_m.*v_z + out.nu_cl.*vStokes_z);
theta_w = -(out.nu_h.*temp_z);

end
