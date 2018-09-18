%% gotm_out_visual

% Main program to analyze output data from GOTM simulations

% Zhihua Zheng, UW-APL, Sep. 5 2018


%% General Configuration before Analysis

init_analyze;

%% Heat Content

heat_content;

%% Mixed Layer Depth (diagnosed from TKE threshold, mld_method = 1)

% mixed layer depth data is really bad
mld = out.mld_surf;

% inertial frequency
f_Coriolis = gsw_f(out.lat); % [radian/s]
% inertial period
t_Coriolis = 2*pi/f_Coriolis/3600; % [hour]

if mld_smooth
    % filter length (~ 3 inertial periods)
    filter_length = 3*t_Coriolis;
    win_size = ceil(filter_length*3600/(nsave*dt));
    b = (1/win_size)*ones(1,win_size);
    a = 1;
    mld = filter(b,a,mld);
end


figure('position', [0, 0, 900, 300])
line(time,-mld,'LineWidth',.4,'Color',[.2 .6 .9])

spec_info.grid_on = 1;
spec_info.x_time = 1;
spec_info.lgd = 0;
spec_info.ylabel = 'mixed layer depth (m)';
spec_info.save = 1;
spec_info.save_path = './figs/mld';

line_annotate(time,spec_info)

%% Inertial Currents

u = out.u;
v = out.v;
u_stokes = out.u_stokes;
v_stokes = out.v_stokes;

% find where the mixed layer depth is in variable z
ml_mask = out.z >= -repmat(mld',length(z),1);  

% u(u>1 | u<-1) = 0;
% v(v>1 | v<-1) = 0;
u_surf = u(end,:);
v_surf = v(end,:);
cur_surf = complex(u_surf,v_surf);
cur = complex(u,v);

% average current in mixed layer
cur_a = zeros(size(time));
for j = 1:length(time)
     
     tmp = cur(:,j);
     cur_a(j) = mean(tmp(ml_mask(:,j)));
     
     % fill the outlier with average value
%      tmp(abs(tmp)>=1) = cur_a(j);
%      cur(:,j) = tmp;
end

cur_a(ml_mask(end,:) == 0) = 0; % avoid NaN when mld is 0

% temporal evolution of current vector vertex

hodogram(time, cur_a)
  
%------- FFT power spectral density estimate ------------------------------

% f = (1/(nsave*dt))*(0:(n/2))/n; % frequency domain
% 
% p_u_surf = abs((fft(u_surf,n))/n);
% loglog(f,p_u_surf(1:n/2+1))
%--------------------------------------------------------------------------


%------- Welch's power spectral density estimate --------------------------

cur_a = cur_a - mean(cur_a);
 
% the next power of 2 greater than signal length - FFT transfrom length
n = 2^nextpow2(length(cur_a));

[p_cur, f] = pwelch(cur_a,[],[],n,24*3600/(nsave*dt)); % f in cycle/day

rotary_spec(f,p_cur,24/t_Coriolis,1)
%--------------------------------------------------------------------------


%--- use jLab functions ---------------------------------------------------

% psi = sleptap(length(cur_a),16); 
% [f,spp,snn] = mspec(3/24,cur_a,psi);
% plot(f/2/pi,[snn spp]),xlim([f(2) f(end)]/2/pi),xlog,ylog

%--------------------------------------------------------------------------

% spec_info.save = 0;
% plot_time_depth(time,z,abs(cur),spec_info)

%% Turbulence Statistics

eps = out.eps;
u_star = out.u_taus; % waterside friction velocity

%----- specify model parameters -------------------------------------------
model_par.dtr0 = -0.2; % d_rho/d_theta
model_par.A1 = 0.92;
model_par.B1 = 16.6;
model_par.rho_0 = 1027;
model_par.dt = dt;
model_par.nsave = nsave;
%--------------------------------------------------------------------------
 
% compute turbulent fluxes
[u_w, v_w, theta_w] = get_turb_flux(model_par,out);

% compute variance of vertical turbulent velocity
w_w = get_v_tke(model_par,u_w,v_w,theta_w,out); 

%% Eddy Diffusivity

% index = find(dateVec(:,1)==2011 & dateVec(:,2)==8 & dateVec(:,3)==5);

D_e = out.D_e;
nu_m = out.nu_m;
nu_h = out.nu_h;
nu_s = out.nu_s;

figure('position', [0, 0, 400, 600])
semilogx(De_keps_pick,z,'LineWidth',.4,'Color',[.8 .7 .2])

% hold on
% semilogx(nu_h_keps_pick,zi,'LineWidth',.4,'Color',[.1 .7 .2])
% same the the turbulent diffusivity for salt

hold on
semilogx(nu_m_keps_pick,zi,'LineWidth',.4,'Color',[.9 .4 .8])
% very different than eddy diffusivity and the turbulent diffusivity for salt

hold on
semilogx(nu_s_keps_pick,zi,'LineWidth',.4,'Color',[.4 .3 .5])
% similar to eddy diffusivity

% hold on
% semilogx(De_kpp_pick,z,'LineWidth',.4,'Color',[.4 .2 .8])

  hold off
  box on
  lgd = legend('eddy diffusivity','$\nu_{m}$','$\nu_{s}$','Location','best');
  % lgd = legend('$k-\varepsilon$','KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('depth (m)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('eddy diffusivity ($$m^{2}/s$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'YLim',[-100 0],'XLim',[10^(-8) .1],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')

  export_fig ('./figs/keps_diffusivity_comparison_2011','-pdf','-transparent','-painters')
  % export_fig ('./figs/eddy_diffusivity_comparison_2011','-pdf','-transparent','-painters')

%% Mis-fit for Monthly Mean Temperature

load(ows_papa_2011_obs.mat); % load observation record of monthly profile
tprof_keps = ones(250,24)*NaN;
tprof_kpp = ones(250,24)*NaN;

m = 1;
for i = 2011:2012

    for j = 1:12

        index = find(dateVec(:,1)==i & dateVec(:,2)==j);
        tprof_keps(:,m) = mean(temp_keps(:,index),2);
        tprof_kpp(:,m) = mean(temp_kpp(:,index),2);
        m = m + 1;
    end

end
tprof_keps = tprof_keps(:,3:15);
tprof_kpp = tprof_kpp(:,3:15);

% interpolate the output averages into the observation depth
tprof_keps_depth = ones(size(tprof_2011))*NaN;
tprof_kpp_depth = ones(size(tprof_2011))*NaN;

for i = 1:13

    tprof_keps_depth(:,i) = interp1(z,tprof_keps(:,i),depth_t);
    tprof_kpp_depth(:,i)= interp1(z,tprof_kpp(:,i),depth_t);
end

diff_keps = tprof_keps_depth - tprof_2011;
diff_kpp = tprof_kpp_depth - tprof_2011;

mis_rms_keps = rms(diff_keps,2);
mis_rms_kpp = rms(diff_kpp,2);

figure('position', [0, 0, 400, 700])
line(mis_rms_keps,depth_t,'LineWidth',1,'Color',[.8 .7 .2])
line(mis_rms_kpp,depth_t,'LineWidth',1,'Color',[.4 .2 .8])
  box on
  lgd = legend('$k-\varepsilon$','KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('depth (m)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('temperature misfit rms ($$^{\circ}C$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')

  export_fig ('./figs/t_misfit_2011','-pdf','-transparent','-painters')

% temporal evolution of mistfit for upper 100m (shallow)
diff_keps_shallow = rms(diff_keps(1:18,:));
diff_kpp_shallow = rms(diff_kpp(1:18,:));

figure('position', [0, 0, 700, 400])
line(time_obs,diff_keps_shallow,'LineWidth',1,'Color',[.8 .7 .2])
line(time_obs,diff_kpp_shallow,'LineWidth',1,'Color',[.4 .2 .8])
  box on
  datetick('x','mmm')
  lgd = legend('$k-\varepsilon$','KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('upper 100m temperature misfit rms ($$^{\circ}C$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')

  export_fig ('./figs/t_misfit_time_2011','-pdf','-transparent','-painters')

%% Evolution of Temperature Profile (prediction and observation)

temp = out.temp;
temp_obs = out.temp_obs;

% model prediction
spec_info.ylabel = 'depth ($$m$$)';
spec_info.clim = [];
spec_info.clabel = 'potential temperature ($$^{\circ}C$$)';
spec_info.color = 'haline';
spec_info.ylim = [zi(1), 0];
spec_info.save = 1;
spec_info.save_path = './figs/temp';

plot_time_depth(time,z,temp,spec_info)

% observation
spec_info.clim = [min(min(temp)) max(max(temp))];
spec_info.clabel = 'obs. potential temperature ($$^{\circ}C$$)';
spec_info.color = 'matter';
spec_info.save = 1;
spec_info.save_path = './figs/temp_obs';

plot_time_depth(time,z,temp_obs,spec_info)

% prediction - observation
spec_info.clim = 'symmetric';
spec_info.clabel = 'temperature diffence ($$^{\circ}C$$)';
spec_info.color = 'curl';
spec_info.save = 0;
spec_info.save_path = './figs/temp_diff';

plot_time_depth(time,z,temp-temp_obs,spec_info)


%% SST

sst = out.sst;
sst_obs = out.sst_obs;
sst_from_prof = temp(128,:)';

figure('position', [0, 0, 900, 300])
line(time,sst_from_prof,'LineWidth',.8,'Color',[.6 .4 .2])
line(time,sst_obs,'LineWidth',.8,'Color',[.3 .6 .4])

spec_info.grid_on = 0;
spec_info.x_time = 1;
spec_info.lgd = 1;
spec_info.lgd_label = {'SMCLT','observation'};
spec_info.ylabel = 'sea surface temperature ($$^{\circ}C$$)';
spec_info.save = 1;
spec_info.save_path = './figs/sst';

line_annotate(time,spec_info)


%% length scale

spec_info.clim = [];
spec_info.color = 'tempo';
spec_info.save = 0;
spec_info.save_path = './figs/length';
spec_info.clabel = 'length scale ($$m$$)';
spec_info.ylabel = 'depth (m)';
spec_info.ylim = [zi(1) 0];

plot_time_depth(time,zi,out.L,spec_info)

hold on 
line(time,-mld,'LineWidth',.1,'Color',[.3 .2 .1],'LineStyle','--')

set(gca(),'LooseInset', get(gca(),'TightInset')); % no blank edge
saveas(gcf, spec_info.save_path, 'epsc');

% clean the white lines in the patch
epsclean([spec_info.save_path,'.eps'],'closeGaps',true) 


