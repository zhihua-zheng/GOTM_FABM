%% make_forecast_forcing

% Script to contruct the forcing files for oceanic forecast at OCS Papa 

% Zhihua Zheng, UW-APL, Sep. 27 2018


%% get OCS Papa mooring TS profiles

ts = get_ocsp_ts();

% linearly interpolate the profiles
tmp = ts.t_prof; 
ts.t_prof = interp1(ts.depth_t(~isnan(tmp)),tmp(~isnan(tmp)),ts.depth_t,'linear');

tmp = ts.s_prof;
ts.s_prof = interp1(ts.depth_s(~isnan(tmp)),tmp(~isnan(tmp)),ts.depth_s,'linear');
clear tmp

%% get GFS prediction

% OWS P nominal location 50.1°N, 144.9°W
lon =  360-(144+25/60);
lat =  50+22/60;

% get the meteorological forecast at Papa
gfs = get_gfs_forecast(lon,lat);


%% momentum flux file

fileID = fopen('./forcing_files/tau_file.dat','w');
H = [cellstr(gfs.date) num2cell(gfs.tau_x) num2cell(gfs.tau_y)];
formatSpec = '%s  % 8.6e % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% U10 file

fileID = fopen('./forcing_files/u10_file.dat','w');
H = [cellstr(gfs.date) num2cell(gfs.u) num2cell(gfs.v)];
formatSpec = '%s  % 8.6e % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% heat flux file

fileID = fopen('./forcing_files/heatflux_file.dat','w');
H = [cellstr(gfs.date) num2cell(gfs.hf)];
formatSpec = '%s   % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% precipitation file

fileID = fopen('./forcing_files/precip_file.dat','w');
H = [cellstr(gfs.date) num2cell(gfs.rain)];
formatSpec = '%s   % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% net short wave radiation (swr) file

fileID = fopen('./forcing_files/swr_file.dat','w');
H = [cellstr(gfs.date) num2cell(gfs.sw)];
formatSpec = '%s  % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% salinity profile

fileID = fopen('./forcing_files/sprof_file.dat','w');

for i = 1:size(ts.time,1)
    
    fprintf(fileID,'%s  19  2\n',ts.date(i));
    fprintf(fileID,'%6.1f   %9.6f\n',[-ts.depth_s'; ts.s_prof(:,i)']);
end

fclose(fileID);

%% temperature profile

fileID = fopen('./forcing_files/tprof_file.dat','w');

for i = 1:size(ts.time,1)
    
    fprintf(fileID,'%s  23  2\n',ts.date(i));
    fprintf(fileID,'%6.1f   %9.6f\n',[-ts.depth_t'; ts.t_prof(:,i)']);
end

fclose(fileID);

