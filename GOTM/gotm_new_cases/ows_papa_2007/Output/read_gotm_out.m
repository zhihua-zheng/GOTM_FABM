function  out = read_gotm_out(fname,dt,order)

% read_gotm_out                                      
%==========================================================================
%
% USAGE:  
%  out = read_gotm_out(fname,dt,nsave)
%
% DESCRIPTION:
%  Read the output variables from GOTM simulation netCDF file (fname)
%     
% INPUT:
%
%  fname - name of output file
%  dt - time step of simulation (in seconds)
%  order - order of turbulence closure scheme
%
% OUTPUT:
%  
%  out - the struct contains all variables in output file
%
% AUTHOR:  
%  June 7 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%



% read from nc file

out.time = ncread(fname,'time'); % seconds since the initialized time in the simulation
out.lon = ncread(fname,'lon'); % longitude [degrees_east]
out.lat = ncread(fname,'lat');% latitude [degrees_north]

%% column_structure
out.ga = squeeze(squeeze(ncread(fname,'ga'))); % coordinate scaling
out.z = squeeze(squeeze(ncread(fname,'z'))); % depth coordinate[m]
out.zi = squeeze(squeeze(ncread(fname,'zi'))); % interface depth [m]
out.h = squeeze(squeeze(ncread(fname,'h'))); % layer thickness [m]

%% temperature_and_salinity
out.temp = squeeze(squeeze(ncread(fname,'temp'))); % potential temperature [Celsius]
out.temp_obs = squeeze(squeeze(ncread(fname,'temp_obs'))); % observed potential temperature [Celsius]
out.salt = squeeze(squeeze(ncread(fname,'salt'))); % absolute salinity [g/kg]
out.salt_obs = squeeze(squeeze(ncread(fname,'salt_obs'))); % observed practical salinity [PSU]
out.rho = squeeze(squeeze(ncread(fname,'rho'))); % potential density [kg/m^3]

%% surface
out.mld_surf = squeeze(ncread(fname,'mld_surf')); % surface mixed layer depth [m]
out.zeta = squeeze(ncread(fname,'zeta')); % sea surface elevation [m]
out.sss = squeeze(ncread(fname,'sst')); % sea surface salinity [PSU]
out.sst_obs = squeeze(ncread(fname,'sst_obs')); % observed sea surface temperature [Celsius]
out.sst = squeeze(ncread(fname,'sst')); % sea surface temperature [Celsius]
out.tx = squeeze(ncread(fname,'tx')); % wind stress (x) [m^2/s^2]
out.ty = squeeze(ncread(fname,'ty')); % wind stress (y) [m^2/s^2]
out.u_taus = squeeze(ncread(fname,'u_taus')); % surface friction velocity [m/s]
out.u10 = squeeze(ncread(fname,'u10')); % 10m wind x-velocity [m/s]
out.v10 = squeeze(ncread(fname,'v10')); % 10m wind y-velocity [m/s]

out.int_precip = squeeze(ncread(fname,'int_precip')); % integrated precipitation [m/s]
out.int_evap = squeeze(ncread(fname,'int_evap')); % integrated evaporation [m/s]
out.int_swr = squeeze(ncread(fname,'int_swr')); % integrated short wave radiation [J/m^2]
out.int_heat = squeeze(ncread(fname,'int_heat')); % integrated surface heat fluxes [J/m^2]
out.int_total = squeeze(ncread(fname,'int_total')); % integrated total surface heat exchange [J/m^2]

out.rhoa = squeeze(ncread(fname,'rhoa')); % air density [kg/m^3]
out.cloud = squeeze(ncread(fname,'cloud')); % cloud cover
out.albedo = squeeze(ncread(fname,'albedo')); % albedo
out.precip = squeeze(ncread(fname,'precip')); % precipitation [m/s]
out.evap = squeeze(ncread(fname,'evap')); % evaporation [m/s]
out.airt = squeeze(ncread(fname,'airt')); % 2m air temperature [Celsius]
out.airp = squeeze(ncread(fname,'airp')); % air pressure [Pa]
out.rh = squeeze(ncread(fname,'hum')); % relative humidity [%]
out.es = squeeze(ncread(fname,'es')); % saturation water vapor pressure [Pa]
out.ea = squeeze(ncread(fname,'ea')); % actual water vapor pressure [Pa]
out.qs = squeeze(ncread(fname,'qs')); % saturation specific humidity
out.qa = squeeze(ncread(fname,'qa')); % specific humidity

% heat_fluxes
out.heat = squeeze(ncread(fname,'heat')); % net surface heat flux [W/m^2]
out.qe = squeeze(ncread(fname,'qe')); % sensible heat flux [W/m^2]
out.qh = squeeze(ncread(fname,'qh')); % latent heat flux [W/m^2]
out.qb = squeeze(ncread(fname,'qb')); % long-wave back radiation [W/m^2]
out.I_0 = squeeze(ncread(fname,'I_0')); % incoming short wave radiation [W/m^2]

%% bottom
out.mld_bott = squeeze(ncread(fname,'mld_bott')); % bottom mixed layer depth [m]
out.taub = squeeze(ncread(fname,'taub')); % bottom stress [Pa]
out.u_taub = squeeze(ncread(fname,'u_taub')); % bottom friction velocity [m/s]

%% velocities
out.u = squeeze(squeeze(ncread(fname,'u'))); % x-mean flow [m/s]
out.v = squeeze(squeeze(ncread(fname,'v'))); % y-mean flow [m/s]
out.u_obs = squeeze(squeeze(ncread(fname,'u_obs'))); % observed x-velocity [m/s]
out.v_obs = squeeze(squeeze(ncread(fname,'v_obs'))); % observed y-velocity [m/s]

%% turbulence
out.taux = squeeze(squeeze(ncread(fname,'taux'))); % turbulent flux of x-momentum [m^2/s^2]
out.tauy = squeeze(squeeze(ncread(fname,'tauy'))); % turbulent flux of y-momentum [m^2/s^2]

out.D_e = squeeze(squeeze(ncread(fname,'avh'))); % eddy diffusivity [m^2/s]
out.Px = squeeze(squeeze(ncread(fname,'xP'))); % extra turbulence production [m^2/s^3]
 
if order == 2
 
 out.tke = squeeze(squeeze(ncread(fname,'tke'))); % turbulent kinetic energy [m^2/s^2]
 out.eps = squeeze(squeeze(ncread(fname,'eps'))); % energy dissipation rate [m^2/s^3]

 out.nu_m = squeeze(squeeze(ncread(fname,'num'))); % turbulent diffusivity of momentum / turbulent viscosity [m^2/s]
 out.nu_h = squeeze(squeeze(ncread(fname,'nuh'))); % turbulent diffusivity of heat [m^2/s]
 out.nu_s = squeeze(squeeze(ncread(fname,'nus'))); % turbulent diffusivity of salt [m^2/s]
 
 out.Rif = squeeze(squeeze(ncread(fname,'xRf'))); % flux Richardson number
 out.Rig = squeeze(squeeze(ncread(fname,'Rig'))); % gradient Richardson number

 out.L = squeeze(squeeze(ncread(fname,'L'))); % turbulence length scale [m]
 out.r = squeeze(squeeze(ncread(fname,'r'))); % turbulent time scale ratio 

 out.ab = squeeze(squeeze(ncread(fname,'an'))); % non-dimensional buoyancy time scale
 out.as = squeeze(squeeze(ncread(fname,'as'))); % non-dimensional shear time scale
 out.abk = squeeze(squeeze(ncread(fname,'at'))); % non-dimensional (half) buoyancy variance
 out.gam = squeeze(squeeze(ncread(fname,'gam'))); % non-dimensional non-local buoyancy flux

 out.cmue1 = squeeze(squeeze(ncread(fname,'cmue1'))); % stability function for momentum diffusivity
 out.cmue2 = squeeze(squeeze(ncread(fname,'cmue2'))); % stability function for scalar diffusivity

 out.gamu = squeeze(squeeze(ncread(fname,'gamu'))); % non-local flux of x-momentum [m^2/s^2]
 out.gamv = squeeze(squeeze(ncread(fname,'gamv'))); % non-local flux of y-momentum [m^2/s^2]
 out.gamb = squeeze(squeeze(ncread(fname,'gamb'))); % non-local buoyancy flux [m^2/s^3]
 out.gamh = squeeze(squeeze(ncread(fname,'gamh'))); % non-local heat flux [K*m/s]
 out.gams = squeeze(squeeze(ncread(fname,'gams'))); % non-local salinity flux [(g/kg)*(m/s)]
 
 
% buoyancy

 
 out.buoy_P = squeeze(squeeze(ncread(fname,'Pb'))); % production of (half) buoyancy variance [m^2/s^5]
 out.Pb = squeeze(squeeze(ncread(fname,'G'))); % buoyancy production [m^2/s^3] 
 out.buoy_epsb = squeeze(squeeze(ncread(fname,'epsb'))); % destruction of (half) buoyancy variance [m^2/s^5]
 out.buoy_kb = squeeze(squeeze(ncread(fname,'kb'))); % (half) buoyancy variance [m^2/s^4]
else
end

out.buoy = squeeze(squeeze(ncread(fname,'buoy'))); % buoyancy [m/s^2]
out.NNT = squeeze(squeeze(ncread(fname,'NNT'))); % contribution of T-gradient to buoyancy frequency squared [1/s^2]
out.NNS = squeeze(squeeze(ncread(fname,'NNS'))); % contribution of S-gradient to buoyancy frequency squared [1/s^2]
out.NN = squeeze(squeeze(ncread(fname,'NN'))); % buoyancy frequency squared [1/s^2]

% shear

if order == 2
 
 out.uu = squeeze(squeeze(ncread(fname,'uu'))); % variance of turbulent x-velocity (fluctuation) [m^2/s^2]
 out.vv = squeeze(squeeze(ncread(fname,'vv'))); % variance of turbulent y-velocity (fluctuation) [m^2/s^2]
 out.ww = squeeze(squeeze(ncread(fname,'vv'))); % variance of turbulent z-velocity (fluctuation) [m^2/s^2]
 out.Ps = squeeze(squeeze(ncread(fname,'P'))); % shear production [m^2/s^3]
else
end

out.SS = squeeze(squeeze(ncread(fname,'SS'))); % shear frequency squared [1/s^2]
out.drag = squeeze(squeeze(ncread(fname,'drag'))); % drag coefficient in water column 
out.fric = squeeze(squeeze(ncread(fname,'fric'))); % extra friction coefficient in water column

%% column_integrals
out.Eturb = squeeze(ncread(fname,'Eturb')); % turbulent kinetic energy [J]
out.Epot = squeeze(ncread(fname,'Epot')); % potential energy [J]
out.Ekin = squeeze(ncread(fname,'Ekin')); % kinetic energy [J]

%% light
out.bioshade = squeeze(squeeze(ncread(fname,'bioshade'))); 
% fraction of visible light that is not shaded by overlying biogeochemistry

out.swr = squeeze(squeeze(ncread(fname,'rad'))); % short-wave radiation [W/m^2]

% reduce dummy dimension

%% -- Get date strings

  % get the reference time from the variable's attribute
  ncid = netcdf.open(fname,'NC_NOWRITE');
  varid = netcdf.inqVarID(ncid,'time'); % varid is the variable ID for 'time' in netCDF file
  t_ref = netcdf.getAtt(ncid,varid,'units'); % get the value of the attribute 'unit'
  t_ref = t_ref(15:end); % truncate to get the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS'); % datenumber for initialized time of simulation
  netcdf.close(ncid);
  
out.time = t_ref + out.time./dt/24;
out.date = string(datestr(out.time, 'yyyy/mm/dd HH:MM:SS'));
% -------

end