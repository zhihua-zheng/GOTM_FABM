% make forcing files for new GOTM ows_papa_2010 test case
%
% by Zhihua Zheng (UW/APL), updated on Apr. 21 2018
% 
% load meteological observation data from PMEL OWS P station mooring
% ---------------------------------------------------
% %        w_u - x component wind velocity (m/s)
% %        w_v - y component wind velocity (m/s)
% %      w_spd - total wind speed (m/s)
% %      w_dir - wind direction (clockwise to the North), in oceanographic sense (degree)
% %     z_wind - wind velocity measurement height (m)
% %      t_air - air temperature (degree centigrade)
% %       z_ta - air temperature measurement height (m)
% %         rh - relative humidity (%)
% %       z_rh - relative humidity measurement height (m)
% %         Rs - downward shortwave radiation (W/m^2)
% %         Rl - downward longwave radiation (W/m^2)
% %       rain - pricipitation rate (mm/hr)
% %          P - sea level barometric pressure (hPa)
% %        sst - sea surface temperature (degree centigrade)
% %        sss - sea surface salinity (PSU)
% %        ssd - sea surface potential density (sigma-theta) (kg/m^3)
% %      sprof - salinity profile (PSU)
% %      tprof - temperature profile (degree centigrade)
% %    depth_t - depth for T profile (m)
% %    depth_s - depth for S profile (m)
% %    cur_spd - total current speed (cm/s)
% %      cur_u - x component current velocity profile (cm/s)
% %      cur_v - y component current velocity profile (cm/s)
% %    cur_dir - current direction (clockwise to the North), (degree)
% %  depth_cur - depth for current profile (m)
% %        lat - mooring latitude (degree)
% %        lon - mooring longitude (degree)
% %       time - datenumbers for measurements (UTC)
% %       date - date strings for measurements (UTC)
% %  time_prof - datenumbers for profile measurements (UTC)
% %  date_prof - date strings for profile measurements (UTC)
% %  time_rain - datenumbers for precipitation measurements (UTC)
% %  date_rain - date strings for precipitation measurements (UTC)
% %     dn2007 - datenumber for start time of time series
%  dn2007_prof - datenumber for start time of profile time series
%  dn2007_rain - datenumber for start time of precipitation time series



% Original profile time series has 94 columns, to exclude the bad data in
% salinity profile, the last 5 columns are abandoned, therefore only the 
% first 89 columns are used here

% The workspace is saved as 'met_forcing_p2007.mat'

%% pick out good data

input_test; % initial examination of data quality

%% organize data 

% After preliminary analysis, noticed that most data is ruined for a
% long time between Nov. 2008 and Jun. 2009. We decide to truncate the data
% and pick out the data after Jun. 2009

% Wanted to include rain data in the computation of flux, but the
% precipitation measurement is intermittent, hence rain data is ignored,
% and the sensible heat flux due to rain (smalll) is not included.

inx2010 = find(date=='2010/01/01 00:00:00');
inx2011 = find(date=='2011/01/01 00:00:00');
w_test = w_u(inx2010+1:inx2011);
% pick out data from '2010/01/01 01:00:00' to '2011/01/01 00:00:00'

pre_day = find(w_test>10000,1,'last') + inx2010; % preferred starting time index

% Abandon all the data before pre_day, and linearly interpolate the small
% gaps

% Note that barometric pressure and sea surface temperature have relative
% long period of missing data, hence the large gaps in P and sst time series 
% are filled by interpolating the reanalysis data from MERRA2 in space and 
% time to the ows_papa mooring location and data time.

merra_fill; % subroutine to the large gap

sst_r = interp1(time(sst_r<100),sst_r(sst_r<100),time(pre_day:end));
P_r = interp1(time(P_r<10000),P_r(P_r<10000),time(pre_day:end));

% w_spd_r = interp1(time(w_spd<100),w_spd(w_spd<100),time(pre_day:end));
% extra large gap at the end, compared to w_u and w_v data...

w_u_r = interp1(time(w_u<100),w_u(w_u<100),time(pre_day:end));
w_v_r = interp1(time(w_v<100),w_v(w_v<100),time(pre_day:end));
w_spd_r = sqrt(w_u_r.^2 + w_v_r.^2);
t_air_r = interp1(time(t_air<50),t_air(t_air<50),time(pre_day:end));
rh_r = interp1(time(rh<150),rh(rh<150),time(pre_day:end));
Rs_r = interp1(time(Rs<1000),Rs(Rs<1000),time(pre_day:end));
Rl_r = interp1(time(Rl<1000),Rl(Rl<1000),time(pre_day:end));
w_dir_r = interp1(time(w_dir<=360),w_dir(w_dir<=360),time(pre_day:end));
time_r = time(pre_day:end); % truncated datenumbers for measurements (UTC)
date_r = date(pre_day:end); % truncated strings for measurements (UTC)


% TS profile data has large gap before 2009/06/16 12:00:00
sprof_tr = sprof(:,25:end);
tprof_tr = tprof(:,25:end);
time_prof_r = time_prof(25:end);

% Absolute salinity and potential temperature conversion (TEOS-10)

[T_s, Z_s] = meshgrid(time_prof_r,depth_s);
saprof = gsw_SA_from_SP(sprof_tr,Z_s,lon,lat); % henceforth absolute salinity
sprof_r = griddata(T_s(~isnan(saprof)),Z_s(~isnan(saprof)),saprof(~isnan(saprof)),T_s,Z_s,'linear');

% absolute salinity is required for calculating potential temperature, so
% make the max depth of t_profile same as s_profile
depth_t = depth_t(1:end-1);
tprof_tr = tprof_tr(1:end-1,:);

[T_t, Z_t] = meshgrid(time_prof_r,depth_t);
sprof_depth_t = griddata(T_s(~isnan(saprof)),Z_s(~isnan(saprof)),saprof(~isnan(saprof)),T_t,Z_t,'linear');
ptprof = gsw_pt0_from_t(sprof_depth_t,tprof_tr,Z_t); % henceforth potential temperature
tprof_r = griddata(T_t(~isnan(ptprof)),Z_t(~isnan(ptprof)),ptprof(~isnan(ptprof)),T_t,Z_t,'linear');


%----- current data is extremely bad
% [T, Z] = meshgrid(time_prof_r,depth_cur);
% cur_u_r = griddata(T(cur_u<100),Z(cur_u<100),cur_u(cur_u<100),T,Z,'linear');


%% compute surface flux

% momentum flux = surface wind stress
%
% net heatflux (positive in) = - latent heat flux (positive out) - sensible 
% heat flux (positive out) + net longwave radiation (positive in)

A = coare35vn(w_spd_r,z_wind,t_air_r,z_ta,rh_r,z_rh,P_r,sst_r,Rs_r,Rl_r,lat,NaN,NaN,NaN,NaN);
% note we should use relative velocity when I have time to do that

tau = A(:,2);
hsb = A(:,3); % sensible heat flux
hlb = A(:,4); % latent heat flux

w_cos = w_u_r./w_spd_r;
w_sin = w_v_r./w_spd_r;

% surface momentum flux in x, y direction
tau_x = tau.*w_cos;
tau_y = tau.*w_sin;


%------ get the date vector and decimal yearday, adjusted for leap year

date_vec = datevec(char(date_r)); 
% lp = leapyear(date_vec(:,1));  % leap year index
% date_vec = [date_vec lp];
% yd = yearday(date_vec(:,2),date_vec(:,3),date_vec(:,7)); 
% yearday - vectorization issue with function yearday
% date_vec = [date_vec yd];

yd = date2doy(time_r)-1; % using function date2doy from File Exchange
%-----------------------

% compute net short wave heat flux
nsw = swhf(yd,date_vec(:,1),(360-lon)*ones(size(time_r)),lat*ones(size(time_r)),Rs_r);
%---- Note to change the longitude into format of West positive degree
%---- Note the operating time in the subroutine of swhf, soradna1 (no-sky
% solar radiation) is in UTC format, therefore the time zone shifting must 
% be perfomed after here.

% compute net long wave heat flux
nlw = lwhf(sst_r,Rl_r,Rs_r);

% compute net surfac heat flux (shortwave heat flux and advective heat flux are omitted)
hf = -hlb - hsb + nlw;


%% Time Conversion

% correction for time zone shift
UTC_time = datetime(time_r,'ConvertFrom','datenum','TimeZone','UTC');
Papa_time = datetime(UTC_time,'TimeZone','-10:00');

% date number, date string and date vector for papa station local time
time_r = datenum(Papa_time);
date_r = datestr(Papa_time,'yyyy/mm/dd HH:MM:SS');
date_vec = datevec(date_r); 

% do it again for time_prof_r
UTC_time = datetime(time_prof_r,'ConvertFrom','datenum','TimeZone','UTC');
Papa_time = datetime(UTC_time,'TimeZone','-10:00');
time_prof_r = datenum(Papa_time);
date_prof_r = datestr(Papa_time,'yyyy/mm/dd HH:MM:SS');

% Hereafter all the truncated time related variables are in local time zone.

%% Diurnal SWR check

diurnal = ones(3000,24)*NaN; % rearrange for every hour (0-23)

for i = 1:24
    
    inx = find(date_vec(:,4) == i-1);
    diurnal(1:size(inx),i) = Rs_r(inx);
    
end

one_day = nanmean(diurnal);

plot(one_day)
% plot(circshift(one_day,-10))


%% momentum flux

fileID = fopen('../forcing_files/momentumflux.dat','w');
H = [cellstr(date_r) num2cell(tau_x) num2cell(tau_y)];
formatSpec = '%s  % 8.6e % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

copyfile('../forcing_files/momentumflux.dat', '../forcing_files/momentumflux_file.dat');
% one dot (.) - present folder, two dots (..) - parent of current folder

%% heat flux

fileID = fopen('../forcing_files/heatflux.dat','w');
H = [cellstr(date_r) num2cell(hf)];
formatSpec = '%s   % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

copyfile('../forcing_files/heatflux.dat', '../forcing_files/heatflux_file.dat');
copyfile('../forcing_files/heatflux.dat', '../forcing_files/heatflux.dat.kb');

%% sea surface temparature (sst) file

fileID = fopen('../forcing_files/sst.dat','w');
H = [cellstr(date_r) num2cell(sst_r)];
formatSpec = '%s %6.3f\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

copyfile('../forcing_files/sst.dat', '../forcing_files/sst_file.dat');

%% net short wave radiation (swr) file

fileID = fopen('../forcing_files/swr.dat','w');
H = [cellstr(date_r) num2cell(nsw)];
formatSpec = '%s  % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

copyfile('../forcing_files/swr.dat', '../forcing_files/swr_file.dat');

%% salinity profile

fileID = fopen('../forcing_files/sprof.dat','w');

for i = 1:size(time_prof_r,1)
    
    fprintf(fileID,'%s  14 2\n',date_prof_r(i));
    fprintf(fileID,'% d. % 10.7f\n',[depth_s'; sprof_r(:,i)']);
end

fclose(fileID);

copyfile('../forcing_files/sprof.dat', '../forcing_files/s_prof_file.dat');

%% temperature profile

fileID = fopen('../forcing_files/tprof.dat','w');

for i = 1:size(time_prof_r,1)
    
    fprintf(fileID,'%s  18 2\n',date_prof_r(i));
    fprintf(fileID,'% 9.4f   % 8.4f\n',[depth_t'; tprof_r(:,i)']);
end

fclose(fileID);

copyfile('../forcing_files/tprof.dat', '../forcing_files/t_prof_file.dat');

%% velocity profile

% fileID = fopen('../forcing_files/cur_prof.dat','w');
% 
% for i = 1:size(time_prof_r,1)
%     
%     fprintf(fileID,'%s  18 2\n',date_prof_r(i));
%     fprintf(fileID,'% 9.4f   % 8.4f\n',[depth_t'; tprof_r(:,i)']);
% end
% 
% fclose(fileID);
% 
% copyfile('../forcing_files/cur_prof.dat', '../forcing_files/cur_prof_file.dat');




%% visualization of flux time series for comparison

% heat flux
figure('position', [0, 0, 1000, 200])
line(time_r,hf,'LineWidth',.4,'Color',[.2 .7 .4])
line(time_r,zeros(size(time_r)),'LineWidth',.6,'Color',[.3 .4 .3])
  box on
  datetick('x','yyyy')
  ylabel('surface heat flux ($$W/m^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('November 10, 2010') datenum('April 21, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sur_hf','-pdf','-transparent','-painters')


  
% momentum flux
figure('position', [0, 0, 1000, 200])
line(time_r,tau_x,'LineWidth',.4,'Color',[.6 .7 .4])
line(time_r,zeros(size(time_r)),'LineWidth',.6,'Color',[.3 .4 .3])
  box on
  datetick('x','yyyy')
  ylabel('x - momentum flux ($$N/m^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('November 10, 2010') datenum('April 21, 2018')],...
      'YLim',[-3 3],'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sur_mfx','-pdf','-transparent','-painters')
%-----------
figure('position', [0, 0, 1000, 200])
line(time_r,tau_y,'LineWidth',.4,'Color',[.6 .7 .4])
line(time_r,zeros(size(time_r)),'LineWidth',.6,'Color',[.3 .4 .3])
  box on
  datetick('x','yyyy')
  ylabel('y - momentum flux ($$N/m^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('November 10, 2010') datenum('April 21, 2018')],...
      'YLim',[-3 3],'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sur_mfy','-pdf','-transparent','-painters')

  
  
% sst
figure('position', [0, 0, 1000, 200])
line(time_r,sst_r,'LineWidth',.4,'Color',[.8 .4 .2])
%line(time_r,zeros(size(time_r)),'LineWidth',.6,'Color',[.3 .4 .3])
  box on
  datetick('x','yyyy')
  ylabel('sea surface temperature ($$^{\circ}C$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('November 10, 2010') datenum('April 21, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sur_t','-pdf','-transparent','-painters')

  
  
  
% net short wave radiation
figure('position', [0, 0, 1000, 200])
line(time_r,nsw,'LineWidth',.4,'Color',[.6 .2 .4])
  box on
  datetick('x','yyyy')
  ylabel('net shortwave radiation ($$W/m^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('November 10, 2010') datenum('April 21, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/sur_nsw','-pdf','-transparent','-painters')
  
  
% salinity profiles
figure('position', [0, 0, 900, 250])

cnum = 15;
CL = [min(min(sprof_r)) max(max(sprof_r))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('-haline')
[T, Z] = meshgrid(time_prof_r,depth_s);
contourf(T,Z,sprof_r,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  axis ij
  datetick('x','yyyy')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('June 15, 2009') datenum('April 16, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  h = colorbar('EastOutside');
  h.Label.String = 'salinity ($$psu$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);

  export_fig ('./figs/prof_sal','-pdf','-transparent','-painters')
  
  
  
% temperature profiles
figure('position', [0, 0, 900, 200])

cnum = 15;
CL = [min(min(tprof_r)) max(max(tprof_r))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('matter')
[T, Z] = meshgrid(time_prof_r,depth_t);
contourf(T,Z,tprof_r,conts,'LineWidth',0.01,'LineStyle','none')
  caxis(CL);
  box on
  axis ij
  datetick('x','yyyy')
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('June 15, 2009') datenum('April 16, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  h = colorbar('EastOutside');
  h.Label.String = 'temperature ($$^{\circ}C$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
  export_fig ('./figs/prof_temp','-pdf','-transparent','-painters')
  
  