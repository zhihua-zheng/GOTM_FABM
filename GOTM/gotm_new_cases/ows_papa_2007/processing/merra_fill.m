% merra_fill


%%

% time = ncread('prmsl.2012.nc','time');
% prmsl = ncread('prmsl.2012.nc','prmsl');
% x = ncread('prmsl.2012.nc','lon');
% y = ncread('prmsl.2012.nc','lat');
% 
% y_papa = find(y==50);
% x_papa = find(x==214 | x==216);
% 
% dn1800 = datenum(1800,1,1,0,0,0);
% time = time/24 + dn1800;
% date = string(datestr(time, 'yyyy/mm/dd HH:MM:SS'));

%% slp_2010

% large gap in barometric pressure after pre_day (Mar. 2010 - Nov.2010)
P_test = P(dn2010+1:dn2011);
P_2010 = find(P_test>10000) + dn2010;


ncvars =  {'lat', 'lon', 'SLP', 'time'};
merra_dir = './original_data_2007/MERRA/slp2010';
dinfo = dir(fullfile(merra_dir,'*.nc'));
num_files = length(dinfo);
filenames = fullfile(merra_dir,{dinfo.name});

lat_merra = ncread(filenames{1}, ncvars{1});
lon_merra = ncread(filenames{1}, ncvars{2});

slp = zeros(length(lat_merra),length(lon_merra),24*num_files)*NaN;
time_slp = zeros(24*num_files,1)*NaN;

for K = 1:24:(24*num_files-23)
    
  this_file = filenames{ceil(K/24)};
  slp(:,:,K:K+23) = ncread(this_file, ncvars{3});
  
  % get the reference time from the variable's attribute
  ncid = netcdf.open(this_file,'NC_NOWRITE');
  t_ref = netcdf.getAtt(ncid,3,'units'); % 3 is the variable ID for 'time' in netCDF file
  t_ref = t_ref(15:end); % truncate to the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS');
  netcdf.close(ncid);
  
  % date numbers for the timestamp
  time_slp(K:K+23) = double(ncread(this_file, ncvars{4}))/(60*24) + t_ref;
  
end

% date_slp = string(datestr(time_slp,'yyyy/mm/dd HH:MM:SS'));
[X_merra, Y_merra, Z_merra] = meshgrid(lon_merra,lat_merra,time_slp);

% interpolate to get the sea level pressure time series at buoy site
lon = double(lon);
lat = double(lat);
slp_papa_2010 = interp3(X_merra,Y_merra,Z_merra,slp,...
    (lon-360)*ones(size(P_2010)),lat*ones(size(P_2010)),time(P_2010))/100;
% the unit for sea level pressure in merra is Pa

P_r = P;
P_r(P_2010) = slp_papa_2010;

%% slp_2013

dn2013 = find(date=='2013/01/01 00:00:00');
dn2015 = find(date=='2015/01/01 00:00:00');

P_test = P(dn2013+1:dn2015);
P_2013 = find(P_test>10000) + dn2013;


ncvars =  {'lat', 'lon', 'SLP', 'time'};
merra_dir = './original_data_2007/MERRA/slp2013';
dinfo = dir(fullfile(merra_dir,'*.nc'));
num_files = length(dinfo);
filenames = fullfile(merra_dir,{dinfo.name});

lat_merra = ncread(filenames{1}, ncvars{1});
lon_merra = ncread(filenames{1}, ncvars{2});

slp = zeros(length(lat_merra),length(lon_merra),24*num_files)*NaN;
time_slp = zeros(24*num_files,1)*NaN;

for K = 1:24:(24*num_files-23)
    
  this_file = filenames{ceil(K/24)};
  slp(:,:,K:K+23) = ncread(this_file, ncvars{3});
  
  % get the reference time from the variable's attribute
  ncid = netcdf.open(this_file,'NC_NOWRITE');
  t_ref = netcdf.getAtt(ncid,3,'units'); % 3 is the variable ID for 'time' in netCDF file
  t_ref = t_ref(15:end); % truncate to the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS');
  netcdf.close(ncid);
  
  % date numbers for the timestamp
  time_slp(K:K+23) = double(ncread(this_file, ncvars{4}))/(60*24) + t_ref;
  
end

% date_slp = string(datestr(time_slp,'yyyy/mm/dd HH:MM:SS'));
[X_merra, Y_merra, Z_merra] = meshgrid(lon_merra,lat_merra,time_slp);

% interpolate to get the sea level pressure time series at buoy site
slp_papa_2013 = interp3(X_merra,Y_merra,Z_merra,slp,...
    (lon-360)*ones(size(P_2013)),lat*ones(size(P_2013)),time(P_2013))/100;
% the unit for sea level pressure in merra is Pa

P_r(P_2013) = slp_papa_2013;

%% sst_2017

dn2017 = find(date=='2017/01/01 00:00:00');
dn2018 = find(date=='2018/01/01 00:00:00');

sst_test = sst(dn2017+1:dn2018);
sst_2017 = find(sst_test>10000) + dn2017;


ncvars =  {'lat', 'lon', 'TS', 'time'};
merra_dir = './original_data_2007/MERRA/sst2017';
dinfo = dir(fullfile(merra_dir,'*.nc'));
num_files = length(dinfo);
filenames = fullfile(merra_dir,{dinfo.name});

lat_merra = ncread(filenames{1}, ncvars{1});
lon_merra = ncread(filenames{1}, ncvars{2});

ts = zeros(length(lat_merra),length(lon_merra),24*num_files)*NaN;
time_sst = zeros(24*num_files,1)*NaN;

for K = 1:24:(24*num_files-23)
    
  this_file = filenames{ceil(K/24)};
  ts(:,:,K:K+23) = ncread(this_file, ncvars{3});
  
  % get the reference time from the variable's attribute
  ncid = netcdf.open(this_file,'NC_NOWRITE');
  t_ref = netcdf.getAtt(ncid,3,'units'); % 3 is the variable ID for 'time' in netCDF file
  t_ref = t_ref(15:end); % truncate to the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS');
  netcdf.close(ncid);
  
  % date numbers for the timestamp
  time_sst(K:K+23) = double(ncread(this_file, ncvars{4}))/(60*24) + t_ref;
  
end

[X_merra, Y_merra, Z_merra] = meshgrid(lon_merra,lat_merra,time_sst);

% interpolate to get the sea level pressure time series at buoy site
ts_papa = interp3(X_merra,Y_merra,Z_merra,ts,...
    (lon-360)*ones(size(sst_2017)),lat*ones(size(sst_2017)),time(sst_2017))-273.15;
% the unit for surface skin temperature in merra is Kelvin

sst_r = sst;
sst_r(sst_2017) = ts_papa;


