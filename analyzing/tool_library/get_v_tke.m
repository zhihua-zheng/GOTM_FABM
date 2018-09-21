function w_w = get_v_tke(model_par, u_w, v_w, theta_w, out)

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
%  u_w - turbulent x-momentum flux [m^2/s^2]
%  v_w - turbulent y-momentum flux [m^2/s^2]
%  theta_w - turbulent heat flux [K*m/s]
%  out - A struct containing all the model output from GOTM
%
% OUTPUT:
%
%  w_w - vertical turbulent kinetic energy (vTKE), vertical velocity
%       fluctuation variance [m^2/s^2]
%
% AUTHOR:
%  September 16 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%


%% Note 

% 1. After applying rescale of l/q according to Ozmidov scale, some l/q is
%    still too large, causing negative vTKE, tracing back to very small
%    buoyancy frequency.
% 2. Not all the negative values of vTKE are due to l/q > 0.53/N. Found 3
%    points except initial column. index = (1223, 1224, 8447). the middle
%    one is the minimum of w_w.

%% Read relevant variables
q2 = 2*out.tke; 
q = sqrt(q2); % turbulent velocity scale [m/s]

rescale_r = model_par.rescale_r;
dt = model_par.dt;
nsave = model_par.nsave;
A1 = model_par.A1;
B1 = model_par.B1;
g = 9.81;

% divided by (-rho_0) to get thermal expanison coefficient (positive)
alpha = - model_par.dtr0/model_par.rho_0; 

%% Deal with staggered grid

% This interpolation approach may need to be modified in future

Zi = out.zi;
Ti = repmat(out.time',size(Zi,1),1);
Z = out.z;
T = repmat(out.time',size(Z,1),1);

u_stokes = interp2(T,Z,out.u_stokes,Ti,Zi,'linear');
v_stokes = interp2(T,Z,out.v_stokes,Ti,Zi,'linear');

%% Rescale l/q under stable stratification

L = out.L;
NN_stable = out.NN; % buoyancy frequency
NN_stable(NN_stable<0) = NaN;
N = sqrt(NN_stable);
N = interp2(T,Z,N,Ti,Zi,'linear');

N(N==0) = NaN;

l_over_q = L./q; % time scale for turbulence
r_Ozm = 0.53./N; % time scale cooresponding to Ozmidov length scale 

% replace the large values of l/q with r_Ozm
if rescale_r
    l_over_q(l_over_q > r_Ozm) = r_Ozm(l_over_q > r_Ozm);
end

%% Stokes shear
[~, uStokes_z] = gradient(u_stokes,dt*nsave,out.z);
[~, vStokes_z] = gradient(v_stokes,dt*nsave,out.z);

%% Computation

w_w = q2*(1-6*A1/B1)/3 + (6*A1*l_over_q).*(alpha*g*theta_w - ...
    u_w.*uStokes_z - v_w.*vStokes_z);


end