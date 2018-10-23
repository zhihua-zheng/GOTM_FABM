function phi = angle_h15(out, rotate_w)

% spf
%==========================================================================
%
% USAGE:
%  phi = = angle_h15(out)
%
% DESCRIPTION:
%  Compute the angle of surface unit vector in SMClT closure model 
%  (see Harcourt 2015)
%
% INPUT:
%
%  out - A struct containing all the model output from GOTM
%  rotata_w - 1 or 0 (1 represents rotating current according to wind to 
%    get downwind and crosswind component)
%
% OUTPUT:
%
%  phi - angle of horizontal unit vector s used in SMCLT, positive as the 
%        as it rotates clockwisely from true North.
%
% AUTHOR:
%  October 22 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%

%% Read relevant variables
z = mean(out.z,2);

%% Rotation of coordinate
if rotate_w
    
     new_vec = rotate_coor(out);

     u_stokes = new_vec.u_stokes;
     v_stokes = new_vec.v_stokes;
else
    u_stokes = out.u_stokes;
    v_stokes = out.v_stokes;
end

%% Stokes shear
uStokes_z = center_diff(u_stokes,z,1);
vStokes_z = center_diff(v_stokes,z,1);

%% Turbulence fluxes
[u_w, v_w, ~] = get_turb_flux(out,rotate_w);

%% Computation

% phiS = atan2(u_stokes,v_stokes);
phiS = atan2(CL_weight(out,uStokes_z,rotate_w),...
    CL_weight(out,vStokes_z,rotate_w));

delta_phiTau = atan2(CL_weight(out,u_w,rotate_w),...
    CL_weight(out,v_w,rotate_w)) - atan2(u_w(end,:),v_w(end,:));

phi = phiS + delta_phiTau;

end
