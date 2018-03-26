% make forcing files for new GOTM ows_papa_2010 test case
%
% by Zhihua Zheng (UW/APL), Mar. 25 2018
% 
% load meteological observation data from PMEL OWS P station mooring
% ---------------------------------------------------
%         u - x component wind velocity
%         v - y component wind velocity
%       spd - total wind speed 
%     w_dir - wind direction, in oceanographic sense
%        uz - wind velocity measurement height
%     t_air - air temperature
%        zt - air temperature measurement height
%        rh - relative humidity
%        zq - relative humidity measurement height
%        ts - sea surface temperature
%     sprof - salinity profile
%     tprof - temperature profile
%   depth_t - depth for T profile
%   depth_s - depth for S profile
%        Rs - downward short wave radiation
%        Rl - downward long wave radiation
%      rain - pricipitation rate
%         P - sea level barometric pressure
%       lat - mooring latitude
%      time - datenumbers for measurement (UTC)
%      date - date strings for measurement (UTC)
%    prof_t - datenumbers for profile measurement (UTC)
% prof_date - date strings for profile measurement (UTC)
%

% The workspace is saved as 'met_forcing_p2010.mat'

%% pick out bad data

spd_r = interp1(time(spd<100),spd(spd<100),time);
u_r = interp1(time(u<100),u(u<100),time);
v_r = interp1(time(v<100),v(v<100),time);
t_r = interp1(time(t_air<50),t_air(t_air<50),time);
rh_r = interp1(time(rh<150),rh(rh<150),time);
ts_r = interp1(time(ts<100),ts(ts<100),time);
Rs_r = interp1(time(Rs<1000),Rs(Rs<1000),time);
Rl_r = interp1(time(Rl<1000),Rl(Rl<1000),time);
P_r = interp1(time(P<10000),P(P<10000),time);
wd_r = interp1(time(w_dir<=360),w_dir(w_dir<=360),time);


[T, Z] = meshgrid(prof_t,depth_s);
sprof_r = griddata(T(sprof<100),Z(sprof<100),sprof(sprof<100),T,Z,'linear');
[T, Z] = meshgrid(prof_t,depth_t);
tprof_r = griddata(T(tprof<100),Z(tprof<100),tprof(tprof<100),T,Z,'linear');

%% compute surface flux

% momentum flux = surface wind stress
%
% heatflux = latent heat flux + sensible heat flux - net shortwave radiation
% (positive) - net longwave radiation (mostly negative)

A = coare35vn(spd_r,zu,t_r,zt,rh_r,zq,P_r,ts_r,Rs_r,Rl_r,lat,NaN,NaN,NaN,NaN);

tau = A(:,2);
hsb = A(:,3); % sensible heat flux
hlb = A(:,4); % latent heat flux

w_cos = u_r./spd_r;
w_sin = v_r./spd_r;

% surface momentum flux in x, y direction
tau_x = tau.*w_cos;
tau_y = tau.*w_sin;


%------ get the date vector and decimal yearday, adjusted for leap year

date_vec = datevec(date); 
% lp = leapyear(date_vec(:,1));  % leap year index
% date_vec = [date_vec lp];
% yd = yearday(date_vec(:,2),date_vec(:,3),date_vec(:,7)); 
% yearday - vectorization issue with function yearday
% date_vec = [date_vec yd];

yd = date2doy(time)-1; % using function date2doy from File Exchange
%-----------------------

% compute net short wave heat flux
nsw = swhf(yd,date_vec(:,1),lon*ones(length(time),1),lat*ones(length(time),1),Rs_r);

% compute net long wave heat flux
nlw = lwhf(ts_r,Rl_r,Rs_r);

% compute total surfac heat flux (advective heat flux is omitted)
hf = hlb + hsb - nsw - nlw;


%% momentum flux

fileID = fopen('momentumflux.dat','w');
H = [cellstr(date) num2cell(tau_x) num2cell(tau_y)];
formatSpec = '%s  % 8.6e % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% heat flux

fileID = fopen('heatflux.dat','w');
H = [cellstr(date) num2cell(hf)];
formatSpec = '%s   % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% sea surface temparature (sst) file

fileID = fopen('sst.dat','w');
H = [cellstr(date) num2cell(ts_r)];
formatSpec = '%s %6.3f\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% short wave radiation (swr) file

fileID = fopen('swr.dat','w');
H = [cellstr(date) num2cell(nsw)];
formatSpec = '%s  % 8.6e\n';

for i = 1:size(H,1)
    fprintf(fileID,formatSpec,H{i,:});
end

fclose(fileID);

%% salinity profile

fileID = fopen('s_prof.dat','w');
prof_date = string(prof_date);

for i = 1:size(prof_t,1)
    
    fprintf(fileID,'%s  14 2\n',prof_date(i));
    fprintf(fileID,'% d. % 10.7f\n',[depth_s'; sprof_r(:,i)']);
end

fclose(fileID);

%% temperature profile

fileID = fopen('t_prof.dat','w');

for i = 1:size(prof_t,1)
    
    fprintf(fileID,'%s  18 2\n',prof_date(i));
    fprintf(fileID,'% 9.4f   % 8.4f\n',[depth_t'; tprof_r(:,i)']);
end

fclose(fileID);



