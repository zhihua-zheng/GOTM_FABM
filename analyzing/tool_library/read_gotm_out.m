function  out = read_gotm_out(fname,order)

% read_gotm_out
%==========================================================================
%
% USAGE:
%  out = read_gotm_out(fname,nsave)
%
% DESCRIPTION:
%  Read the output variables from GOTM simulation netCDF file (fname)
%
% INPUT:
%
%  fname - name of output file
%  order - order of turbulence closure scheme
%
% OUTPUT:
%
%  out - the struct contains all variables in output file
%
% AUTHOR:
%  September 2 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%


%% general_info
out.time = double(ncread(fname,'time'));
% seconds since the initialized time in the simulation

out.lon = double(ncread(fname,'lon')); % longitude [degrees_east]
out.lat = double(ncread(fname,'lat'));% latitude [degrees_north]

%% column_structure
out.ga = double(squeeze(squeeze(ncread(fname,'ga')))); % coordinate scaling
out.z = double(squeeze(squeeze(ncread(fname,'z')))); % depth coordinate[m]
out.zi = double(squeeze(squeeze(ncread(fname,'zi')))); % interface depth [m]
out.h = double(squeeze(squeeze(ncread(fname,'h')))); % layer thickness [m]

%% temperature_and_salinity_and_density
out.temp = double(squeeze(squeeze(ncread(fname,'temp')))); % potential temperature [Celsius]
out.temp_obs = double(squeeze(squeeze(ncread(fname,'temp_obs')))); % observed potential temperature [Celsius]
out.salt = double(squeeze(squeeze(ncread(fname,'salt')))); % absolute salinity [g/kg]
out.salt_obs = double(squeeze(squeeze(ncread(fname,'salt_obs')))); % observed practical salinity [PSU]
out.rho = double(squeeze(squeeze(ncread(fname,'rho')))); % potential density [kg/m^3]

%% surface
% out.KPP_OSBL = double(squeeze(squeeze(ncread(fname,'KPP_OSBL')))); % KPP boundary layer depth
out.mld_surf = double(squeeze(ncread(fname,'mld_surf'))); % surface mixed layer depth [m]
out.zeta = double(squeeze(ncread(fname,'zeta'))); % sea surface elevation [m]
out.sss = double(squeeze(ncread(fname,'sst'))); % sea surface salinity [PSU]
out.sst_obs = double(squeeze(ncread(fname,'sst_obs'))); % observed sea surface temperature [Celsius]
out.sst = double(squeeze(ncread(fname,'sst'))); % sea surface temperature [Celsius]
out.tx = double(squeeze(ncread(fname,'tx'))); % wind stress (x) [m^2/s^2]
out.ty = double(squeeze(ncread(fname,'ty'))); % wind stress (y) [m^2/s^2]
out.u_taus = double(squeeze(ncread(fname,'u_taus'))); % surface friction velocity [m/s]
out.u10 = double(squeeze(ncread(fname,'u10'))); % 10m wind x-velocity [m/s]
out.v10 = double(squeeze(ncread(fname,'v10'))); % 10m wind y-velocity [m/s]
out.v0_stokes = double(squeeze(squeeze(ncread(fname,'v0_stokes')))); % surface Stokes drift y-component
out.u0_stokes = double(squeeze(squeeze(ncread(fname,'u0_stokes')))); % surface Stokes drift x-component

out.int_precip = double(squeeze(ncread(fname,'int_precip'))); % integrated precipitation [m/s]
out.int_evap = double(squeeze(ncread(fname,'int_evap'))); % integrated evaporation [m/s]
out.int_swr = double(squeeze(ncread(fname,'int_swr'))); % integrated short wave radiation [J/m^2]
out.int_heat = double(squeeze(ncread(fname,'int_heat'))); % integrated surface heat fluxes [J/m^2]
out.int_total = double(squeeze(ncread(fname,'int_total'))); % integrated total surface heat exchange [J/m^2]

out.rhoa = double(squeeze(ncread(fname,'rhoa'))); % air density [kg/m^3]
out.cloud = double(squeeze(ncread(fname,'cloud'))); % cloud cover
out.albedo = double(squeeze(ncread(fname,'albedo'))); % albedo
out.precip = double(squeeze(ncread(fname,'precip'))); % precipitation [m/s]
out.evap = double(squeeze(ncread(fname,'evap'))); % evaporation [m/s]
out.airt = double(squeeze(ncread(fname,'airt'))); % 2m air temperature [Celsius]
out.airp = double(squeeze(ncread(fname,'airp'))); % air pressure [Pa]
out.rh = double(squeeze(ncread(fname,'hum'))); % relative humidity [%]
out.es = double(squeeze(ncread(fname,'es'))); % saturation water vapor pressure [Pa]
out.ea = double(squeeze(ncread(fname,'ea'))); % actual water vapor pressure [Pa]
out.qs = double(squeeze(ncread(fname,'qs'))); % saturation specific humidity
out.qa = double(squeeze(ncread(fname,'qa'))); % specific humidity

% heat_fluxes
out.heat = double(squeeze(ncread(fname,'heat'))); % net surface heat flux [W/m^2]
out.qe = double(squeeze(ncread(fname,'qe'))); % sensible heat flux [W/m^2]
out.qh = double(squeeze(ncread(fname,'qh'))); % latent heat flux [W/m^2]
out.qb = double(squeeze(ncread(fname,'qb'))); % long-wave back radiation [W/m^2]
out.I_0 = double(squeeze(ncread(fname,'I_0'))); % incoming short wave radiation [W/m^2]

%% bottom
out.mld_bott = double(squeeze(ncread(fname,'mld_bott'))); % bottom mixed layer depth [m]
out.taub = double(squeeze(ncread(fname,'taub'))); % bottom stress [Pa]
out.u_taub = double(squeeze(ncread(fname,'u_taub'))); % bottom friction velocity [m/s]

%% velocities
out.u = double(squeeze(squeeze(ncread(fname,'u')))); % x-mean flow [m/s]
out.v = double(squeeze(squeeze(ncread(fname,'v')))); % y-mean flow [m/s]
out.u_obs = double(squeeze(squeeze(ncread(fname,'u_obs')))); % observed x-velocity [m/s]
out.v_obs = double(squeeze(squeeze(ncread(fname,'v_obs')))); % observed y-velocity [m/s]
out.v_stokes = double(squeeze(squeeze(ncread(fname,'v_stokes')))); % Stokes drift y-component
out.u_stokes = double(squeeze(squeeze(ncread(fname,'u_stokes')))); % Stokes drift x-component

%% turbulence
% out.taux = double(squeeze(squeeze(ncread(fname,'taux')))); % turbulent flux of x-momentum [m^2/s^2]
% out.tauy = double(squeeze(squeeze(ncread(fname,'tauy')))); % turbulent flux of y-momentum [m^2/s^2]

out.Px = double(squeeze(squeeze(ncread(fname,'xP')))); % extra turbulence production [m^2/s^3]
out.tke = double(squeeze(squeeze(ncread(fname,'tke')))); % turbulent kinetic energy [m^2/s^2]
out.Rig = double(squeeze(squeeze(ncread(fname,'Rig')))); % gradient Richardson number

out.D_e = double(squeeze(squeeze(ncread(fname,'avh')))); % eddy diffusivity [m^2/s]
out.nu_m = double(squeeze(squeeze(ncread(fname,'num')))); % turbulent diffusivity of momentum - down the Eulerian shear [m^2/s]
out.nu_cl = double(squeeze(squeeze(ncread(fname,'nucl')))); % Craik-Leibovich turbulent diffusivity of momentum - down the Stokes shear [m^2/s]
out.nu_h = double(squeeze(squeeze(ncread(fname,'nuh')))); % turbulent diffusivity of heat [m^2/s]
out.nu_s = double(squeeze(squeeze(ncread(fname,'nus')))); % turbulent diffusivity of salt [m^2/s]

out.gamu = double(squeeze(squeeze(ncread(fname,'gamu')))); % non-local flux of x-momentum [m^2/s^2]
out.gamv = double(squeeze(squeeze(ncread(fname,'gamv')))); % non-local flux of y-momentum [m^2/s^2]
out.gamh = double(squeeze(squeeze(ncread(fname,'gamh')))); % non-local heat flux [K*m/s]
out.gams = double(squeeze(squeeze(ncread(fname,'gams')))); % non-local salinity flux [(g/kg)*(m/s)]
out.gam = double(squeeze(squeeze(ncread(fname,'gam')))); % non-dimensional non-local buoyancy flux

if order == 2

 out.eps = double(squeeze(squeeze(ncread(fname,'eps')))); % energy dissipation rate [m^2/s^3]

 out.Rif = double(squeeze(squeeze(ncread(fname,'xRf')))); % flux Richardson number

 out.gamb = double(squeeze(squeeze(ncread(fname,'gamb')))); % non-local buoyancy flux [m^2/s^3]

 out.L = double(squeeze(squeeze(ncread(fname,'L')))); % turbulence length scale [m]
 out.r = double(squeeze(squeeze(ncread(fname,'r')))); % turbulent time scale ratio

 out.ab = double(squeeze(squeeze(ncread(fname,'an')))); % non-dimensional buoyancy time scale
 out.as = double(squeeze(squeeze(ncread(fname,'as')))); % non-dimensional shear time scale
 out.abk = double(squeeze(squeeze(ncread(fname,'at')))); % non-dimensional (half) buoyancy variance

 out.cmue1 = double(squeeze(squeeze(ncread(fname,'cmue1')))); % stability function for momentum diffusivity
 out.cmue2 = double(squeeze(squeeze(ncread(fname,'cmue2')))); % stability function for scalar diffusivity

% buoyancy
 out.buoy_P = double(squeeze(squeeze(ncread(fname,'Pb')))); % production of (half) buoyancy variance [m^2/s^5]
 out.Pb = double(squeeze(squeeze(ncread(fname,'G')))); % buoyancy production [m^2/s^3]
 out.buoy_epsb = double(squeeze(squeeze(ncread(fname,'epsb')))); % destruction of (half) buoyancy variance [m^2/s^5]
 out.buoy_kb = double(squeeze(squeeze(ncread(fname,'kb')))); % (half) buoyancy variance [m^2/s^4]
end

out.buoy = double(squeeze(squeeze(ncread(fname,'buoy')))); % buoyancy [m/s^2]
out.NNT = double(squeeze(squeeze(ncread(fname,'NNT')))); % contribution of T-gradient to buoyancy frequency squared [1/s^2]
out.NNS = double(squeeze(squeeze(ncread(fname,'NNS')))); % contribution of S-gradient to buoyancy frequency squared [1/s^2]
out.NN = double(squeeze(squeeze(ncread(fname,'NN')))); % buoyancy frequency squared [1/s^2]

% shear
if order == 2

 out.uu = double(squeeze(squeeze(ncread(fname,'uu')))); % variance of turbulent x-velocity (fluctuation) [m^2/s^2]
 out.vv = double(squeeze(squeeze(ncread(fname,'vv')))); % variance of turbulent y-velocity (fluctuation) [m^2/s^2]
 out.ww = double(squeeze(squeeze(ncread(fname,'vv')))); % variance of turbulent z-velocity (fluctuation) [m^2/s^2]
 out.Ps = double(squeeze(squeeze(ncread(fname,'P')))); % shear production [m^2/s^3]
 out.PS = double(squeeze(squeeze(ncread(fname,'PS')))); % Stokes production [m^2/s^3]

end

out.SS = double(squeeze(squeeze(ncread(fname,'SS')))); % shear frequency squared [1/s^2]
out.drag = double(squeeze(squeeze(ncread(fname,'drag')))); % drag coefficient in water column
out.fric = double(squeeze(squeeze(ncread(fname,'fric')))); % extra friction coefficient in water column


% Langmuir
out.theta_WW = double(squeeze(squeeze(ncread(fname,'theta_WW')))); % angle between wind and waves
out.theta_WL = double(squeeze(squeeze(ncread(fname,'theta_WL')))); % angle between wind and Langmuir cells
out.La_SLP2 = double(squeeze(squeeze(ncread(fname,'La_SLP2')))); % surface layer averaged, projected Langmuir number (RWHGK16)
out.La_SLP1 = double(squeeze(squeeze(ncread(fname,'La_SLP1')))); % surface layer averaged, projected Langmuir number (VFSHH12)
out.La_SL = double(squeeze(squeeze(ncread(fname,'La_SL')))); % surface layer averaged Langmuir number
out.La_Turb = double(squeeze(squeeze(ncread(fname,'La_Turb')))); % turbulent Langmuir number
out.delta = double(squeeze(squeeze(ncread(fname,'delta')))); % Stokes drift penetration depth

%% column_integrals
out.Eturb = double(squeeze(ncread(fname,'Eturb'))); % turbulent kinetic energy [J]
out.Epot = double(squeeze(ncread(fname,'Epot'))); % potential energy [J]
out.Ekin = double(squeeze(ncread(fname,'Ekin'))); % kinetic energy [J]

%% light
out.bioshade = double(squeeze(squeeze(ncread(fname,'bioshade'))));
% fraction of visible light that is not shaded by overlying biogeochemistry

out.swr = double(squeeze(squeeze(ncread(fname,'rad')))); % short-wave radiation [W/m^2]

%% -- Get date strings

  % get the reference time from the variable's attribute
  ncid = netcdf.open(fname,'NC_NOWRITE');
  varid = netcdf.inqVarID(ncid,'time'); % varid is the variable ID for 'time' in netCDF file
  t_ref = netcdf.getAtt(ncid,varid,'units'); % get the value of the attribute 'unit'
  t_ref = t_ref(15:end); % truncate to get the time string
  t_ref = datenum(t_ref, 'yyyy-mm-dd HH:MM:SS'); % datenumber for initialized time of simulation
  netcdf.close(ncid);

out.time = t_ref + out.time./3600/24;
out.date = string(datestr(out.time, 'yyyy/mm/dd HH:MM:SS'));
% -------

end
