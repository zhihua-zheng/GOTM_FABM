%% display_out

% Script to display the output from simulation of Qing's GOTM-develop

% Zhihua Zheng Jun. 27 2018

%% read variables

clear
dinfo = dir(fullfile('./*.nc'));
fname = fullfile('./',{dinfo.name});

vstokes = squeeze(double(ncread(fname{:},'v_stokes')));
ustokes = squeeze(double(ncread(fname{:},'u_stokes'))); 
% vstokes_Z = squeeze(double(ncread(fname{:},'v_stokes')));
% ustokes_Z = squeeze(double(ncread(fname{:},'u_stokes')));
nuh = squeeze(double(ncread(fname{:},'nuh'))); 
sal = squeeze(double(ncread(fname{:},'salt'))); 
% Pb = squeeze(double(ncread(fname{:},'G'))); 
% Ps = squeeze(double(ncread(fname{:},'P'))); 
% eps = squeeze(double(ncread(fname{:},'eps'))); 
% tke = squeeze(double(ncread(fname{:},'tke')));
% L = squeeze(double(ncread(fname{:},'L')));
int_total = squeeze(double(ncread(fname{:},'int_total')));
rho = squeeze(double(ncread(fname{:},'rho')));
zi = mean(squeeze(double(ncread(fname{:},'zi'))),2);
z = mean(squeeze(double(ncread(fname{:},'z'))),2);
temp = squeeze(double(ncread(fname{:},'temp')));
temp_obs = squeeze(double(ncread(fname{:},'temp_obs')));
time = squeeze(double(ncread(fname{:},'time')));

 % get the reference time from the variable's attribute
  ncid = netcdf.open(fname{:},'NC_NOWRITE');
  varid = netcdf.inqVarID(ncid,'time'); % varid is the variable ID for 'time' in netCDF file
  t_ref = netcdf.getAtt(ncid,varid,'units'); % get the value of the attribute 'unit'
  t_ref = t_ref(15:end); % truncate to get the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS'); % datenumber for initialized time of simulation
  netcdf.close(ncid);
  
time = t_ref + time./3600/24;
date = string(datestr(time, 'yyyy/mm/dd HH:MM:SS'));
clear t_ref ncid varid fname dinfo

%% length scale

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(L)) max(max(L))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('deep')
[T, Z] = meshgrid(time,zi);
contourf(T,Z,L,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-300 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'length scale ($$m$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  %export_fig ('./length','-pdf','-transparent','-painters')
  set(gca(),'LooseInset', get(gca(),'TightInset')); % no blank edge
  saveas(gcf, './length', 'epsc');
  
[x,y] = find(L>100);

%% time-depth temperature

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(temp)) max(max(temp))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('matter')
[T, Z] = meshgrid(time,z);
contourf(T,Z,temp,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  datetick('x','mmm')
  %title('COREII_LAT-54_LON254_SMCLT_20080915-20090915_VR1m_DT60s')
  %title('COREII LAT-54 LON254 SMC 20080915-20090915 VR1m DT1800s','fontname',...
   %   'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  %xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-300 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'potential temperature ($$^{\circ}C$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  %export_fig ('./temp','-pdf','-transparent','-painters')
  set(gca(),'LooseInset', get(gca(),'TightInset')); % no blank edge
  saveas(gcf, './temp', 'epsc');
  
% hold on 
% [T, Z] = meshgrid(time,zi);
% contour(T,Z,L,[100 100],'LineWidth',5)

%% time-depth obs. temperature

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(temp_obs)) max(max(temp_obs))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('matter')
[T, Z] = meshgrid(time,z);
contourf(T,Z,temp_obs,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  %caxis([0 25])
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-300 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'obs. potential temperature ($$^{\circ}C$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
  clear h conts cnum CL
  %export_fig ('./temp_obs','-pdf','-transparent','-painters')
  set(gca(),'LooseInset', get(gca(),'TightInset')); % no blank edge
  saveas(gcf, './temp_obs', 'epsc');
  
%% heat content

HC = trapz(z,rho.*(temp+273.15)*gsw_cp0);  
HC_delta = HC(end) - HC(1);
HC_t = gradient(HC,3600*3);

figure('position', [0, 0, 900, 300])
line(time,HC./10^(6),'LineWidth',.1,'Color',[.7 .4 .6])
line(time,(int_total+HC(1))./10^(6),'LineWidth',.1,'Color',[.1 .6 .7])
line(time,ones(size(time))*HC(1)/10^(6),'LineWidth',.6,'Color',[.3 .3 .3],'LineStyle','--')
% mark the heat content change of water column from simulation results
line([time(end) time(end)],[HC(1)/10^(6) HC(end)/10^(6)],'Color','k','LineStyle','-','LineWidth',4);
text(time(280),2.325*10^(5),['heat content change $\sim$ ', num2str(round(HC_delta/10^(6))), ' $MJ/m^{2}$'],...
    'fontname','computer modern','Interpreter','latex','fontsize',13)

  box on
  datetick('x','mmm')
  lgd = legend('model HC','surface heat exchange','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('heat content ($MJ/m^{2}$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  %export_fig ('./figs/heat_content','-pdf','-transparent','-painters')  

%%  temporal change of heat content

figure('position', [0, 0, 900, 300])  
line(time,HC_t,'Color',[.6 .5 .7])
line(time,zeros(size(time)),'Color',[.3 .3 .3],'LineStyle','--')
  datetick('x','mmm')
  box on
  datetick('x','mmm')
  lgd = legend('model HC','surface heat exchange','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('temporal heat content change ($MJ/m^{2}*s$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
 
%% time-depth salinity

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(sal)) max(max(sal))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('matter')
[T, Z] = meshgrid(time,z);
contourf(T,Z,sal,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-500 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'salinity ($$psu$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
 
%% time-depth density

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(rho)) max(max(rho))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('dense')
[T, Z] = meshgrid(time,z);
contourf(T,Z,rho,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-500 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'potential density ($$kg/m^{3}$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
%% buoyancy production

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(Pb)) max(max(Pb))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('balance')
[T, Z] = meshgrid(time,zi);
contourf(T,Z,Pb,conts,'LineWidth',0.01,'LineStyle','none')
  caxis([CL(1) -CL(1)]);
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-150 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'buoyancy production';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
%% heat diffusivity

figure('position', [0, 0, 980, 250])
cnum = 15;
CL = [min(min(nuh)) max(max(nuh))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('tempo')
[T, Z] = meshgrid(time,zi);
contourf(T,Z,nuh,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  % axis ij
  datetick('x','mmm')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[time(1) time(end)],...
      'YLim',[-150 0],'fontsize',11,'fontname','computer modern','TickLabelInterpreter','latex')
  h = colorbar('EastOutside');
  h.Label.String = 'heat diffusivity';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);

  

%% heat content comparison

clear

load('hf_comparison.mat')



time_q = datenum(time_q);
time_z = datenum(time_z);
date_q = string(datestr(time_q));
date_z = string(datestr(time_z));

inx_1 = find(date_z == date_q(1));
inx_end = find(date_z == date_q(end));
hf_zq = hf_z(inx_1:inx_end);
time_zq = time_z(inx_1:inx_end);



figure('position', [0, 0, 1000, 200])

scatter(time_q, hf_q, .1, 'MarkerEdgeColor', 'b')
hold on 
scatter(time_zq, hf_zq, .1, 'MarkerEdgeColor', 'r')
line(time_q, zeros(size(time_q)))



line(time,hf_Qing,'LineWidth',.4,'Color',[.2 .7 .4])
line(time,zeros(size(time)),'LineWidth',.6,'Color',[.3 .4 .3])
  box on
  datetick('x','mmm')
  ylabel('surface heat flux ($$W/m^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('January 1, 2012') datenum('December 31, 2013')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  