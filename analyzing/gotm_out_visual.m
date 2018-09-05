
%% READ the Variables from Output

clear

% path
GOTM_root = '~/Documents/GitLab/GOTM_dev/';
run_dir = 'run/OCSPapa_SMCLT_20100616-20171005_1800';
% run_dir = 'run/OCSPapa_SMCLT_20120701-20131201_1800_Z';
cd ([GOTM_root,run_dir])

% simulation info
nsave = 6;
dt = 1800;
turb_method = 'SMCLT';

% general plot specification info
spec_info.timeformat = 'mmm/yyyy';
spec_info.save_switch = 1;

% load
SMCLT_long = read_gotm_out('gotm_out.nc',2);

% read variables
time = SMCLT_long.time;
date = SMCLT_long.date;
dateVec = datevec(char(date));
z = mean(SMCLT_long.z,2);
zi = mean(SMCLT_long.zi,2);
h = mean(SMCLT_long.h,2);
int_total = SMCLT_long.int_total;
int_heat = SMCLT_long.int_heat;
int_swr = SMCLT_long.int_swr;


sst = SMCLT_long.sst;
sst_obs = SMCLT_long.sst_obs;
temp = SMCLT_long.temp;
temp_obs = SMCLT_long.temp_obs;
sst_from_prof = temp(128,:)';

buoy = SMCLT_long.buoy;
NN = SMCLT_long.NN;
rho = SMCLT_long.rho;


%% Heat Content

%---- Plot integrated heat infor from observation -------------------------
figure('position', [0, 0, 900, 300])

line(time,int_total./10^(6),'LineWidth',3,'Color',[.2 .6 .7])
line(time,int_heat./10^(6),'LineWidth',.8,'Color',[.8 .2 .2])
line(time,int_swr./10^(6),'LineWidth',.8,'Color',[.3 .2 .5])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')

% mark the net heat taken by the water column from surface measurement
line([time(end) time(end)],[0 int_total(end)/10^(6)],'Color',...
    [.2 .2 .2],'LineStyle','-','LineWidth',4);
text(time(end-7000),-int_total(end)/10^6,...
    ['net heat into the ocean $\sim$ ', num2str(round(int_total(end)/10^(6))),...
    ' $MJ/m^{2}$'],'fontname','computer modern','Interpreter','latex','fontsize',15)

% figure specification
spec_info.lgd_switch = 1;
spec_info.lgd_label = {'total heat exchange','surface heat flux',...
    'short wave radiation'};
spec_info.x_time = 1;
spec_info.ylabel = 'integrated heat ($MJ/m^{2}$)';
spec_info.save_path = './figs/int_heat';

line_annotate(time,spec_info)
%--------------------------------------------------------------------------


%---- Calculation of heat content and temporal derivative -----------------

% observation only goes down to 200m, so we will focus on the upper 200m
% specific heat capacity - gsw_cp0, from GSW toolbox

% depth z index 22 ~ upper 201.4027m
HC = sum(rho(22:end,:).*(temp(22:end,:)+273.15).*h(22:end,:)*gsw_cp0); %[J/m^2]
HC_delta = HC(end) - HC(1);
HC_t = gradient(HC,dt*nsave); %[W/m^2]


% from observation
HC_obs = sum(rho(22:end,:).*(temp_obs(22:end,:)+273.15).*h(22:end,:)*gsw_cp0);
HC_delta_obs = HC_obs(end) - HC_obs(1);
HC_t_obs = gradient(HC_obs,dt*nsave);

% from surface heat info
HC_surface = int_total+HC(1);
HC_t_surface = gradient(int_total,dt*nsave);

HC_error = 100*(int_total(end) - HC_delta)/int_total(end); % in percent
%--------------------------------------------------------------------------


%------ Heat content time series ------------------------------------------
figure('position', [0, 0, 900, 300])

line(time,HC./10^(6),'LineWidth',.3,'Color',[.7 .4 .6])
line(time,HC_surface./10^(6),'LineWidth',.3,'Color',[.1 .6 .7])
line(time,HC_obs./10^(6),'LineWidth',.05,'Color',[.4 .8 .6])
line(time,ones(size(time))*HC(1)/10^(6),'LineWidth',.9,'Color',[.3 .3 .3],'LineStyle','--')

% mark the deviation from surface heat input
line([time(end) time(end)],[HC(1)/10^(6) HC_surface(end)./10^(6)],...
    'Color',[.6 .1 .3],'LineStyle','-','LineWidth',3);
text(time(end-2200),HC(end)/10^(6),...
    ['$\sim$ ',num2str(round(HC_error,2)),'$\%$'],'color',[.6 .1 .3],...
    'fontname','computer modern','Interpreter','latex','fontsize',13)

% mark the heat content change relative to observation
line([time(end) time(end)],[HC(1)/10^(6) HC(end)/10^(6)],'Color',...
    [.1 .1 .1],'LineStyle','-','LineWidth',3);
text(time(end-7000),HC(8800)/10^(6),[turb_method,...
    ' heat content change $\sim$ ',num2str(round((HC_delta-HC_delta_obs)/10^(6))),...
    ' $MJ/m^{2}$'],'Color',[.1 .1 .1],'fontname','computer modern',...
    'Interpreter','latex','fontsize',13)
  
% figure specification
spec_info.lgd_label = {[turb_method,' HC'],'surface heat exchange','obs. HC'};
spec_info.ylabel = 'heat content ($MJ/m^{2}$)';
spec_info.save_switch = 1;
spec_info.save_path = './figs/HC';

line_annotate(time,spec_info)  
%--------------------------------------------------------------------------


%------- Plot temporal variation of heat content --------------------------
figure('position', [0, 0, 900, 300])

line(time,HC_t_surface,'LineWidth',1,'Color','k')
line(time,HC_t,'LineWidth',1,'Color',[.4 .9 .7])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.5 .5 .5],'LineStyle',':')
 
% figure specification
spec_info.lgd_label = {'surface heat exchange rate',...
    ['$\partial_{t}HC$ in ',turb_method]};
spec_info.ylabel = 'temporal heat variation ($W/m^{2}$)';
spec_info.save_path = './figs/HC_t_surf';

line_annotate(time,spec_info)

%--------
figure('position', [0, 0, 900, 300])

line(time,HC_t_obs,'LineWidth',1,'Color','k')
line(time,HC_t,'LineWidth',1,'Color',[.4 .9 .7])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.5 .5 .5],'LineStyle',':')

spec_info.lgd_label = {'$\partial_{t}HC$ in obs.', ...
    ['$\partial_{t}HC$ in ',turb_method]};
spec_info.ylabel = 'temporal heat variation ($W/m^{2}$)';
spec_info.save_path = './figs/HC_t_obs';

line_annotate(time,spec_info)

%% Mixed Layer Depth

% mixed layer depth data is really bad
mld = SMCLT_long.mld_surf;

% filter, 5 day smoothing (~ 8 inertial periods)
win_size = 5*24*3600/(nsave*dt);
b = (1/win_size)*ones(1,win_size);
a = 1;

mld_filter = filter(b,a,mld);

figure('position', [0, 0, 900, 300])
line(time,mld_filter,'LineWidth',.4,'Color',[.2 .6 .9])
axis ij

spec_info.lgd_switch = 0;
spec_info.ylabel = 'mixed layer depth (m)';
spec_info.save_path = './figs/mld';

line_annotate(time,spec_info)

%% Inertial Currents

u = SMCLT_long.u;
v = SMCLT_long.v;

% inertial frequency
f_Coriolis = gsw_f(SMCLT_long.lat); % [radian/s]
% inertial period
t_Coriolis = 2*pi/f_Coriolis/3600; % [hour]

% find where the mixed layer depth is in variable z
ml_mask = SMCLT_long.z >= -repmat(mld_filter',length(z),1);  

% u(u>1 | u<-1) = 0;
% v(v>1 | v<-1) = 0;
u_surf = u(end,:);
v_surf = v(end,:);
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


figure('position', [0, 0, 500, 400])
% plot(cur_a,'Color',[.5 .6 .7],'LineStyle','--','LineWidth',.8)
cmocean('phase')
scatter(real(cur_a),imag(cur_a),5,time,'filled')
colorbar('EastOutside')

%------- FFT power spectral density estimate ------------------------------

% f = (1/(nsave*dt))*(0:(n/2))/n; % frequency domain
% 
% p_u_surf = abs((fft(u_surf,n))/n);
% loglog(f,p_u_surf(1:n/2+1))
%--------------------------------------------------------------------------


%------- Welch?s power spectral density estimate --------------------------
cur_a = cur_a - mean(cur_a);
% FFT transform length - next power of two greater than the signal length
n = 2^nextpow2(length(time));
[p_cur, f] = pwelch(cur_a,[],[],n,24*3600/(nsave*dt)); % f in cycle/day
figure('position', [0, 0, 600, 300])

% counter-clockwise, negative
loglog(f(1:n/2),p_cur(1:n/2),'Color',[.1 .6 .7],'LineStyle','-','LineWidth',.3) 
hold on

% clockwise, positive
loglog(f(1:n/2),flip(p_cur(n/2+1:end)),'Color',[.9 .4 .6],'LineStyle','-','LineWidth',.3) 
hold on

% mark inertial frequency
loglog([24/t_Coriolis 24/t_Coriolis],[.001*min(p_cur) 100*max(p_cur)],...
    'Color',[.4 .5 .5],'LineStyle','-.','LineWidth',.3);
hold off

spec_info.x_time = 0;
spec_info.xlabel = 'frequency (cycle per day)';
spec_info.ylabel = 'PSD ($$(m/s)^2/cpd$$)';
spec_info.lgd_switch = 1;
spec_info.lgd_label = {'counter clockwise', 'clockwise'};
spec_info.save_path = './figs/cur_spec';

line_annotate(f(1:n/2),spec_info)
%--------------------------------------------------------------------------


%--- use jLab functions ---------------------------------------------------

% psi = sleptap(length(cur_a),16); 
% [f,spp,snn] = mspec(3/24,cur_a,psi);
% plot(f/2/pi,[snn spp]),xlim([f(2) f(end)]/2/pi),xlog,ylog

%--------------------------------------------------------------------------

% spec_info.save_switch = 0;
% plot_time_depth(time,z,abs(cur),spec_info)

%% Turbulence Statistics

tke = SMCLT_long.tke;
eps = SMCLT_long.eps;

uu = SMCLT_long.uu;
vv = SMCLT_long.vv;
ww = SMCLT_long.ww; 

u_star = SMCLT_long.u_taus; % waterside friction velocity

%% Eddy Diffusivity

% index = find(dateVec(:,1)==2011 & dateVec(:,2)==8 & dateVec(:,3)==5);

D_e = SMCLT_long.D_e;
nu_m = SMCLT_long.nu_m;
nu_h = SMCLT_long.nu_h;
nu_s = SMCLT_long.nu_s;

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

%% SST

figure('position', [0, 0, 900, 300])
line(time,sst_from_prof,'LineWidth',.8,'Color',[.8 .7 .2])
line(time,sst_obs,'LineWidth',.8,'Color',[.3 .6 .4])

spec_info.x_time = 1;
spec_info.lgd_switch = 1;
spec_info.lgd_label = {'SMCLT','observation'};
spec_info.ylabel = 'sea surface temperature ($$^{\circ}C$$)';
spec_info.save_path = './figs/sst';

line_annotate(time,spec_info)


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

spec_info.ylabel = 'depth ($$m$$)';
spec_info.clabel = 'potential temperature ($$^{\circ}C$$)';
spec_info.color = 'matter';
spec_info.ylim = [-300, 0];
spec_info.save_path = './figs/temp';
plot_time_depth(time,z,temp,spec_info)

spec_info.clabel = 'obs. potential temperature ($$^{\circ}C$$)';
spec_info.save_path = './figs/temp_obs';
plot_time_depth(time,z,temp_obs,spec_info)


% hold on
% [T, Z] = meshgrid(time,zi);
% contour(T,Z,L,[100 100],'LineWidth',5)


%% length scale

L = SMCLT_long.L;

spec_info.color = 'deep';
spec_info.save_path = './figs/length';
spec_info.clabel = 'length scale ($$m$$)';
spec_info.ylabel = 'depth (m)';
spec_info.ylim = [-150 0];

plot_time_depth(time,zi,L,spec_info)

hold on 
line(time,-mld_filter,'LineWidth',.08,'Color',[.3 .2 .1],'LineStyle',':')

set(gca(),'LooseInset', get(gca(),'TightInset')); % no blank edge
saveas(gcf, spec_info.save_path, 'epsc');
% [x,y] = find(L>100);
