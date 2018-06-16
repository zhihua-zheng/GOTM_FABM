% obs_2011

% Extract observation data for GOTM simulation period Mar. 25 2011 - Mar.
% 25 2012 from 'met_forcing_p2007_re.mat', generated after running 'make_forcing.m'
% till 'Time Conversion' section, an updated version of 'met_forcing_p2007.mat'

% by Zhihua Zheng (UW/APL), updated on Jun. 15 2018

%% Load the workspace 'met_forcing_p2007.mat'

load('../processing/met_forcing_p2007_re.mat')

%%

date_r = string(date_r); % convert to string first

d1 = find(date_r == '2011/03/25 00:00:00');
d2 = find(date_r == '2012/03/25 00:00:00');

sst_2011 = sst_r(d1:d2);

d1 = find(date_prof_r == '2011/03/16 02:00:00');
d2 = find(date_prof_r == '2012/03/16 02:00:00');

time_prof_2011 = time_prof_r(d1:d2);
sprof_2011 = sprof_r(:,d1:d2);
tprof_2011 = tprof_r(:,d1:d2);
rhoprof_2011 = rhoprof_r(:,d1:d2)+1000;

clear d1 d2

save('ows_papa_2011_obs.mat','sst_2011','time_prof_2011','sprof_2011','tprof_2011',...
    'rhoprof_2011','depth_t','depth_s');




