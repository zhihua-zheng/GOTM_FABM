% 
% 
% 
% out_my = read_gotm_out('ows_papa_my.nc');
% cur_u_my = mean(out_my.u,2); % time-averaged eastward current profile
% cur_v_my = mean(out_my.v,2); % time-averaged northward current profile
% 
% 
% figure('position', [0, 0, 350, 500])
% plot(cur_u_my.*100,(-249.5:1:-.5))
% hold on 
% plot(cur_v_my.*100,(-249.5:1:-.5))
%   lgd = legend('$\langle U\rangle$', '$\langle V\rangle$','Location','best');
%   set(lgd,'Interpreter','latex','fontsize', 14)
%   ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
%   xlabel('mean flow ($$cm/s$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
%   setDateAxes(gca,...
%       'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
%   
%   export_fig ('./figs/cur_my','-pdf','-transparent','-painters')
%   
% %% winter (date 252-342)
% 
% taux_my = double(out_my.taux);  
% tauy_my = double(out_my.tauy);
% 
% cnum = 15;
% [T, Z] = meshgrid(out_my.time,(-250:1:0));
% CL = [min(min(taux_my)) max(max(taux_my))];
% conts = linspace(CL(1),CL(2),cnum);
% cmocean('balance')
% 
% figure('position', [0, 0, 350, 500])
% contourf(T,Z,taux_my.*10000,conts,'LineWidth',0.01,'LineStyle','none');
% % contourf(tauy_my.*10000,
%   caxis(CL);
%   box on
%   axis ij
%   datetick('x','mmm')
%   % lgd = legend('$\langle wu\rangle$', '$\langle wv\rangle$','Location','best');
%   % set(lgd,'Interpreter','latex','fontsize', 14)
%   
%   ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
%   xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
%   setDateAxes(gca,'XLim',[datenum('June 15, 2009') datenum('April 16, 2018')],...
%       'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
%   
%   h = colorbar('EastOutside');
%   h.Label.String = 'x-momentum turbulent flux $\langle wu\rangle$ ($$m^2/s^2$$)';
%   h.Label.Interpreter = 'latex';
%   h.Label.FontName = 'computer modern';
%   h.Label.FontSize = 14;
%   set(h,'TickLabelInterpreter','latex','fontsize',9);
%   
%   export_fig ('./figs/tur_mom_flux_my','-pdf','-transparent','-painters')
% 
%   
%   
%   
%% READ the Variables from Output

keps_2011 = read_gotm_out('ows_papa_keps_2011.nc',3600,2);
keps_2011_dy = read_gotm_out('ows_papa_keps_2011_dy.nc',3600,2); % daily mean
kpp_2011 = read_gotm_out('ows_papa_kpp_2011.nc',3600,1);
kpp_2011_dy = read_gotm_out('ows_papa_kpp_2011_dy.nc',3600,1); % daily mean

time = double(keps_2011.time);
time_dy = double(keps_2011_dy.time);
date = (keps_2011.date);
date_vec = datevec(char(date)); 
z = mean(double(keps_2011.z),2);
zi = mean(double(keps_2011.zi),2);
int_total = double(keps_2011.int_total);
int_heat = double(keps_2011.int_heat);
int_swr = double(keps_2011.int_swr);

sst_keps = double(keps_2011.sst);
sst_obs_keps = double(keps_2011.sst_obs);
temp_keps = double(keps_2011.temp);
sst_from_prof_keps = temp_keps(250,:)';
mld_keps = double(keps_2011.mld_surf);
mld_keps_dy = double(keps_2011_dy.mld_surf);
buoy_keps = double(keps_2011.buoy);
De_keps = double(keps_2011.D_e);
nu_m = double(keps_2011.nu_m);
nu_h = double(keps_2011.nu_h);
nu_s = double(keps_2011.nu_s);
NN_keps = double(keps_2011.NN);
rho_keps = double(keps_2011.rho);

sst_kpp = double(kpp_2011.sst);
sst_obs_kpp = double(kpp_2011.sst_obs);
temp_kpp = double(kpp_2011.temp);
sst_from_prof_kpp = temp_kpp(250,:)';
mld_kpp = double(kpp_2011.mld_surf);
mld_kpp_dy = double(kpp_2011_dy.mld_surf);
buoy_kpp = double(kpp_2011.buoy);
NN_kpp = double(kpp_2011.NN);
rho_kpp = double(kpp_2011.rho);


%% Heat Content

% integrated heat from observation

figure('position', [0, 0, 1200, 300])
line(time,int_total,'LineWidth',3,'Color',[.2 .6 .7])
line(time,int_heat,'LineWidth',.8,'Color',[.8 .2 .2])
line(time,int_swr,'LineWidth',.8,'Color',[.3 .2 .5])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')

  box on
  datetick('x','mmm')
  lgd = legend('total heat exchange', 'surface heat flux','short wave radiation','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('integrated heat ($J/m^{2}$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/integrated_heat_2011','-pdf','-transparent','-painters')  
  
  
 
% calculation of heat content and temporal derivative

c_p = ones(size(temp_keps))*3850; % specific heat capacity
HC_keps = sum(rho_keps.*c_p.*temp_keps);  
HC_delta_keps = HC_keps(end) - HC_keps(1);
HC_t_keps = gradient(HC_keps,3600);

HC_kpp = sum(rho_kpp.*c_p.*temp_kpp);  
HC_delta_kpp = HC_kpp(end) - HC_kpp(1);
HC_t_kpp = gradient(HC_kpp,3600);

HC_t_surface = gradient(int_total,3600);

% heat content plot
figure('position', [0, 0, 800, 200])
line(time,HC_keps,'LineWidth',.8,'Color',[.7 .4 .6])
line(time,HC_kpp,'LineWidth',.8,'Color',[.4 .3 .5])
line(time,ones(size(time))*HC_keps(1),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')
line(time,ones(size(time))*HC_keps(end),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')
  box on
  datetick('x','mmm')
  lgd = legend('$k-\varepsilon$', 'KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('heat content ($J/m^{2}$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/heat_content_2011','-pdf','-transparent','-painters')  


% temporal variation of heat content
figure('position', [0, 0, 1000, 400])
subplot(2,1,1)
line(time,HC_t_surface,'LineWidth',1,'Color','k')
line(time,HC_t_keps,'LineWidth',1,'Color','y')
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')
  box on
  datetick('x','mmm')
  lgd = legend('surface heat exchange rate','$\partial_{t}H$ in $k-\varepsilon$','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('temporal heat variation ($W/m^{2}$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time','fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
subplot(2,1,2)
line(time,HC_t_surface,'LineWidth',1,'Color','k')
line(time,HC_t_kpp,'LineWidth',1,'Color',[.4 .6 .9])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')
  box on
  datetick('x','mmm')
  lgd = legend('surface heat exchange rate','$\partial_{t}H$ in KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('temporal heat variation ($W/m^{2}$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time','fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
    
  export_fig ('./figs/heat_change_rate_2011','-pdf','-transparent','-painters')


%% Eddy Diffusivity

index = find(date_vec(:,1)==2011 & date_vec(:,2)==8 & date_vec(:,3)==5);

De_keps_pick = mean(De_keps(:,index),2);
nu_h_keps_pick = mean(nu_h(:,index),2);
nu_m_keps_pick = mean(nu_m(:,index),2);
nu_s_keps_pick = mean(nu_s(:,index),2);
% De_kpp_pick = mean(De_kpp(:,index),2);

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

figure('position', [0, 0, 1000, 400])
line(time,sst_from_prof_keps,'LineWidth',.8,'Color',[.8 .7 .2])
line(time,sst_2011,'LineWidth',.8,'Color','k')
line(time,sst_from_prof_kpp,'LineWidth',.8,'Color',[.4 .6 .9])
  box on
  datetick('x','mmm')
  lgd = legend('$k-\varepsilon$', 'observation','KPP','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('sea surface temperature ($$^{\circ}C$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sst_comparison_2011','-pdf','-transparent','-painters')

%% Mixed Layer Depth

% mixed layer depth data is really bad

figure('position', [0, 0, 700, 300])
line(time_dy,mld_keps_dy,'LineWidth',.4,'Color',[.8 .7 .2])
% line(time,mld_kpp,'LineWidth',.4,'Color',[.2 .6 .9])
  box on
  axis ij
  datetick('x','mmm')
  ylabel('mixed layer depth (m)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
%% Mis-fit for Monthly Mean Temperature 

load(ows_papa_2011_obs.mat); % load observation record of monthly profile
tprof_keps = ones(250,24)*NaN;
tprof_kpp = ones(250,24)*NaN;

m = 1;
for i = 2011:2012
    
    for j = 1:12
        
        index = find(date_vec(:,1)==i & date_vec(:,2)==j);
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

%% Evolution of Temperature Structure 

figure('position', [0, 0, 900, 200])

cnum = 15;
CL = [min(min(temp_keps)) max(max(temp_keps))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('matter')
[T, Z] = meshgrid(time,z);
contourf(T,Z,temp_keps,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('March 25, 2011') datenum('March 25, 2012')],...
      'YLim',[-80 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'potential temperature ($$^{\circ}C$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
  %export_fig ('./figs/kpp_temp_2011','-pdf','-transparent','-painters')
  