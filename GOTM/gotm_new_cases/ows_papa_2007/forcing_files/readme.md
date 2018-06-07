This scenario is a classical scenario for the Northern Pacific, for which long term
observations of meteorological parametersand temperature profiles are available. The
station Papa at 145 deg W, 50 deg N has the advantage that it is situated in a region
where the horizontaladvection of heat and salt is assumed to be small. Various authors
used these data for validating turbulence closure schemes.

The way how bulk formulae for the surface momentum and heat fluxes have been used here
is discussed in detail in Burchard et al. (1999).

The maximum simulation time allowed by the included surface forcing file and the
temperature profile fileis Nov 10 (07.00 h), 2010 - Apr 20 (14.00 h), 2018 (local time). In this scenario, the simulation time is run from Mar 25, 2011 (0.00 h) to Mar 25, 2012 (0.00 h).

For further information, see Burchard and Bolding (2001).

References:

Burchard, H., K. Bolding, and M.R. Villarreal, 1999: GOTM - a general ocean turbulence
model. Theory, applications and test cases, Tech. Rep., No. EUR 18745 EN, European
Commission, 103 pp.(http://io-warnemuende.de/tl_files/staff/burchard/pdf/papers/report.pdf)

Burchard, H., and K. Bolding, Comparative analysis of four second-moment turbulence closure
models for the oceanic mixed layer, J. Phys. Oceanogr., 31, 1943-1968, 2001.


------------------------------------ addition -----------------------------------------

These forcing files include hourly surface momentum flux, hourly heat flux, hourly net
shortwave radiation, hourly sea surface temperature, monthly salinity profile, monthly (in situ) temperature profile.

Hourly data is from 2010/11/10 07:00:00 to 2018/04/20 14:00:00 (local time), monthly data is from 2009/06/16 2:00:00 to 2018/04/16 2:00:00 (local time). Missing data is interpolated using linear method (interp1 and griddata in MATLAB). The time labels used here are in local time zone.

Momentum flux, latent heat flux, and sensible heat flux are computed using coare35vn.m
algorithm (from NOAA, after Fairall et al, 2003) without including rainfall data. Net
shortwave radiation and net longwave radiation are computed using swhf.m and lwhf.m function in air-sea toolboox (MATLAB). Original bulk meteological and oceanographic measurement is from NOAA PMEL mooring near ocean weather station Papa. The sign convention adopted here is treating positive flux as into the ocean.

Note the surface heat flux forcing presented here does not include advective heat flux and net short wave radiation.

---- Zhihua Zheng (UW/APL), updated on May 04 2018
