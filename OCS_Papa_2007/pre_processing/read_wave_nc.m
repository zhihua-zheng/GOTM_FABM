%% read_wave_nc.m
%
% This the script used to read the information from wave spectrum netCDF
% file and the generated workspace is named as 'mewave_forcing_p2007.mat'.

% by Zhihua Zheng (UW/APL), updated on Aug. 13 2018

%% set path
clear
data_dir = '~/Documents/Study/Graduate_research/data_raw/OCS_P/CDIP_Wave';
f_name = '166p1_historic.nc';
file = [data_dir '/' f_name];

%% read variables 

wave_time = ncread(file,'waveTime'); % wave time in UTC
wave_time = double(wave_time);
wave_freq = ncread(file,'waveFrequency'); % band center frequency (hertz)
wave_freq = double(wave_freq);
wave_bw = ncread(file,'waveBandwidth'); % frequency bandwidth (hertz)
wave_spec = ncread(file,'waveEnergyDensity'); % band energy density (m^2/hertz)
wave_mdir = ncread(file,'waveMeanDirection'); 
% band mean direction (from), in degree clockwise from the true North

%% timestamp

% get the reference time from the variable's attribute
ncid = netcdf.open(file,'NC_NOWRITE');

% varid is the variable ID for 'waveTime' in netCDF file
varid = netcdf.inqVarID(ncid,'waveTime');

% get the value of the attribute 'units'
t_ref = netcdf.getAtt(ncid,varid,'units'); 

t_ref = t_ref(15:end); % truncate to get the time string

t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS'); 
netcdf.close(ncid);

wave_time = double(t_ref + wave_time./3600/24);
wave_date = datestr(wave_time,'yyyy/mm/dd HH:MM:SS');
wave_date = string(wave_date);

clear t_ref ncid varid 

%% direction conversion

wave_mdir = 90-(180+wave_mdir);
% henceforth direction (towards) is in degree counter-clockwise from East

%% save

clear data_dir f_name file
save('wave_p2010.mat');

