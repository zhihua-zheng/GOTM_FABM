%% tke_sub

% Subroutine to ananlyze TKE components from GOTM simulation output

% Zhihua Zheng, UW-APL, Sep. 22 2018

%% ----- specify model parameters -----------------------------------------
model_par.dtr0 = -0.2; % derivative of density w.r.t. temperature
model_par.A1 = 0.92;
model_par.B1 = 16.6;
model_par.rho_0 = 1027; % reference density of seawater
model_par.dt = dt;
model_par.nsave = nsave;
model_par.rescale_r = 1;

%% ----- computation ------------------------------------------------------
% compute turbulent fluxes 
[u_w, v_w, theta_w] = get_turb_flux(model_par,out);

% compute components of TKE
tke_comps = get_tke_com(model_par,u_w,v_w,theta_w,out);
tke_comps(tke_comps<0) = NaN;

% water-side friction velocity square
u_star2 = sqrt(out.tx.^2 + out.ty.^2);

% normalize TKE components by water-side friction velocity
tke_comps_n = tke_comps./(repmat(u_star2',length(zi),1,3));

%% ----- plot -------------------------------------------------------------
spec_info.ylabel = 'depth ($$m$$)';
spec_info.clim = [0 nanmax(nanmax(nanmax(tke_comps_n)))];
spec_info.clabel = '$$\overline{w^{\prime}w^{\prime}}/u_{*}^{2}$$';
spec_info.color = 'speed';
spec_info.plot_method = 3;
spec_info.ylim = [zi(1), 0];
spec_info.save = 0;
spec_info.save_path = './figs/ww_norm';

% z-direction TKE
plot_time_depth(time,zi,tke_comps_n(:,:,3),spec_info)

% x-direction TKE
spec_info.clabel = '$$\overline{u^{\prime}u^{\prime}}/u_{*}^{2}$$';
spec_info.save_path = './figs/uu_norm';
plot_time_depth(time,zi,tke_comps_n(:,:,1),spec_info)

% y-direction TKE
spec_info.clabel = '$$\overline{v^{\prime}v^{\prime}}/u_{*}^{2}$$';
spec_info.save_path = './figs/vv_norm';
plot_time_depth(time,zi,tke_comps_n(:,:,2),spec_info)
