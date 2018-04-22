

%% read variables from netCDF files

lat = ncread('../original_data_2007/w50n145w_hr.cdf','lat');
lon = ncread('../original_data_2007/w50n145w_hr.cdf','lon');
w_u = ncread('../original_data_2007/w50n145w_hr.cdf','WU_422');
w_v = ncread('../original_data_2007/w50n145w_hr.cdf','WV_423');
z_wind = - ncread('../original_data_2007/w50n145w_hr.cdf','depth');
w_dir = ncread('../original_data_2007/w50n145w_hr.cdf','WD_410');
w_gust = ncread('../original_data_2007/w50n145w_hr.cdf','WG_430');
w_spd = ncread('../original_data_2007/w50n145w_hr.cdf','WS_401');
sst = ncread('../original_data_2007/sst50n145w_hr.cdf','T_25');
sss = ncread('../original_data_2007/sss50n145w_hr.cdf','S_41');
ssd = ncread('../original_data_2007/ssd50n145w_hr.cdf','STH_71');
rh = ncread('../original_data_2007/rh50n145w_hr.cdf','RH_910');
z_rh = - ncread('../original_data_2007/rh50n145w_hr.cdf','depth');
rain = ncread('../original_data_2007/rain50n145w_hr.cdf','RN_485');
Rs = ncread('../original_data_2007/rad50n145w_hr.cdf','RD_495');
Rl = ncread('../original_data_2007/lw50n145w_hr.cdf','Ql_136');
P = ncread('../original_data_2007/bp50n145w_hr.cdf','BP_915');
t_air = ncread('../original_data_2007/airt50n145w_hr.cdf','AT_21');
z_ta = - ncread('../original_data_2007/airt50n145w_hr.cdf','depth');
time = ncread('../original_data_2007/rad50n145w_hr.cdf','time'); % hours since 2007 Jun 8 05:00:00
time_rain = ncread('../original_data_2007/rain50n145w_hr.cdf','time'); % hours since 2007 Jun 8 04:00:00
dn2007 = datenum(2007,6,8,5,0,0);
dn2007_rain = datenum(2007,6,8,4,0,0);


%% read profiles from netCDF files

depth_s = ncread('../original_data_2007/profiles/s50n145w_mon.cdf','depth');
sprof = ncread('../original_data_2007/profiles/s50n145w_mon.cdf','S_41');
depth_t = ncread('../original_data_2007/profiles/t50n145w_mon.cdf','depth');
tprof = ncread('../original_data_2007/profiles/t50n145w_mon.cdf','T_20');

% uprof_adcp = ncread('adcp50n145w_mon.cdf','u_1205');
% vprof_adcp = ncread('adcp50n145w_mon.cdf','v_1206');
% depth_adcp = ncread('adcp50n145w_mon.cdf','depth');
% time_adcp = ncread('adcp50n145w_mon.cdf','time'); % days since 2010 Jun 16 12:00:00
% 
% uprof_sen = ncread('adcp_sentinel50n145w_mon.cdf','u_1205');
% vprof_sen = ncread('adcp_sentinel50n145w_mon.cdf','v_1206');
% depth_sen = ncread('adcp_sentinel50n145w_mon.cdf','depth');
% time_sen = ncread('adcp_sentinel50n145w_mon.cdf','time'); % days since 2010 Jun 16 12:00:00

cur_u = ncread('../original_data_2007/profiles/cur50n145w_mon.cdf','U_320');
cur_v = ncread('../original_data_2007/profiles/cur50n145w_mon.cdf','V_321');
cur_spd = ncread('../original_data_2007/profiles/cur50n145w_mon.cdf','CS_300');
cur_dir = ncread('../original_data_2007/profiles/cur50n145w_mon.cdf','CD_310');
depth_cur = ncread('../original_data_2007/profiles/cur50n145w_mon.cdf','depth');

time_prof = ncread('../original_data_2007/profiles/s50n145w_mon.cdf','time'); % days since 2007 Jun 16 12:00:00
dn2007_prof = datenum(2007,6,16,12,0,0);


%% Reduce singleton dimension, convert class to double, unify time

w_u = double(squeeze(squeeze(w_u)));
w_v = double(squeeze(squeeze(w_v)));
w_spd = double(squeeze(squeeze(w_spd)));
w_dir = double(squeeze(squeeze(w_dir)));
w_gust = double(squeeze(squeeze(w_gust)));
sss = double(squeeze(squeeze(sss)));
sst = double(squeeze(squeeze(sst)));
ssd = double(squeeze(squeeze(ssd)));
t_air = double(squeeze(squeeze(t_air)));
Rs = double(squeeze(squeeze(Rs)));
Rl = double(squeeze(squeeze(Rl)));
rain = double(squeeze(squeeze(rain)));
rh = double(squeeze(squeeze(rh)));
P = double(squeeze(squeeze(P)));

sprof = double(squeeze(squeeze(sprof)));
tprof = double(squeeze(squeeze(tprof)));
cur_u = double(squeeze(squeeze(cur_u)));
cur_v = double(squeeze(squeeze(cur_v)));
cur_spd = double(squeeze(squeeze(cur_spd)));
cur_dir = double(squeeze(squeeze(cur_dir)));

time = double(time);
time_rain = double(time_rain);
time_prof = double(time_prof);
depth_s = double(depth_s);
depth_t = double(depth_t);
depth_cur = double(depth_cur);


P = P(end-95276+1:end);
rh = rh(end-95276+1:end);
Rl = Rl(end-95276+1:end);
sss = sss(end-95276+1:end);
sst = sst(end-95276+1:end);
ssd = ssd(end-95276+1:end);
t_air = t_air(end-95276+1:end);
w_dir = w_dir(end-95276+1:end);
w_gust = w_gust(end-95276+1:end);
w_spd = w_spd(end-95276+1:end);
w_u = w_u(end-95276+1:end);
w_v = w_v(end-95276+1:end);


%% Timestamp

time = time/24+dn2007;
time_rain = time_rain/24+dn2007_rain;
time_prof = time_prof+dn2007_prof;

date = datestr(time, 'yyyy/mm/dd HH:MM:SS');
date = string(date);

date_rain = datestr(time_rain, 'yyyy/mm/dd HH:MM:SS');
date_rain = string(date_rain);

date_prof = datestr(time_prof, 'yyyy/mm/dd HH:MM:SS');
date_prof = string(date_prof);