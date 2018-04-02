These forcing files include hourly surface momentum flux, hourly heat flux, hourly net shortwave
 radiation, hourly sea surface temperature, monthly salinity profile, monthly temperature profile.

Hourly data is from 2010/06/15 00:00:00 to 2016/06/16 11:00:00, monthly data is from 
2010/06/16 12:00:00 to 2017/10/16 12:00:00. Missing data is interpolated using linear method 
(interp1 and griddata in MATLAB). The time labels used here are in UTC format.

Momentum flux, latent heat flux, and sensible heat flux are computed using coare35vn.m algorithm (from NOAA). 
Net shortwave radiation and net longwave radiation are computed using swhf.m and lwhf.m function 
in air-sea toolboox (MATLAB). Note the measured insolation in the inputment is treated as the 
measured downward shortwave radiation from original data.

---- Zhihua Zheng (UW/APL), updated on Apr. 2 2018

