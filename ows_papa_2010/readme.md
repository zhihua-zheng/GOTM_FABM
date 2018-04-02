These forcing files include hourly surface momentum flux, hourly heat flux, hourly net shortwave
 flux, hourly sea surface temperature, monthly salinity profile, monthly temperature profile.

Hourly data is from 2010/06/15 00:00:00 to 2017/10/05 23:00:00, monthly data is from 
2010/06/16 12:00:00 to 2018/03/16 12:00:00. Missing data is interpolated using linear method 
(interpN in MATLAB). The time labels used here are in UTC format.

Momentum flux, latent heat flux, and sensible heat flux are computed using coare35vn.m algorithm. 
Net shortwave radiation and net longwave radiation are computed using swhf.m and lwhf.m function 
in air-sea toolboox (MATLAB). Note the measured insolation in the inputment is treated as the 
measured downward shortwave radiation from original data.

---- Zhihua Zheng (UW/APL), Mar. 25 2018

