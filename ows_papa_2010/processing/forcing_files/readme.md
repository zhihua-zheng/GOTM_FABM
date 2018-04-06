These forcing files include hourly surface momentum flux, hourly heat flux, hourly net shortwave radiation, 
hourly sea surface temperature, monthly salinity profile, monthly temperature profile.

Hourly data is from 2010/06/14 14:00:00 to 2016/06/16 01:00:00, monthly data is from 2010/06/16 02:00:00 to 
2017/10/16 02:00:00. Missing data is interpolated using linear method (interp1 and griddata in MATLAB). The 
time labels used here are in local time zone.

Momentum flux, latent heat flux, and sensible heat flux are computed using coare35vn.m algorithm (from NOAA), 
without introducing rainfall data. Net shortwave radiation and net longwave radiation are computed using 
swhf.m and lwhf.m function in air-sea toolboox (MATLAB). Original bulk meteological and oceanographic data is
from NOAA PMEL mooring near ocean weather station Papa. The sign convention adopted here is treating positive
flux as into the ocean. 

Note the surface heat flux forcing presented here does not include advective heat flux and net short wave 
radiation.

---- Zhihua Zheng (UW/APL), updated on Apr. 5 2018

