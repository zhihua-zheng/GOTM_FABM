; get_ocsp_ts
;==========================================================================
;
; USAGE:
;  ncl get_ocsp_ts.ncl
;
; DESCRIPTION:
;  Function to retrieve latest subsurface temperature and salinity data from
;  Ocean Climate Station Papa mooring and export as ASCII files
;
; INPUT:
;
; OUTPUT:
;  ASCII files containing subsurface temperature and salinity data
;
; AUTHOR:
;  September 29 2018. Zhihua Zheng                     [ zhihua@uw.edu ]
;==========================================================================

begin

  ;--- LOAD netCDF file served by OPeNDAP server at NDBC -----------------------
  url = "https://dods.ndbc.noaa.gov/thredds/dodsC/oceansites/DATA_GRIDDED/PAPA/"
  f_name = "OS_PAPA_200706_M_TSVMBP_50N145W_hr.nc"

  exists = isfilepresent(url+f_name)
    if(.not.exists) then
      print("OPeNDAP test unsuccessful.")
      print("Either the file doesn't exist, or NCL does")
      print("not have OPeNDAP cabilities on this system.")
    else
      f = addfile(url + f_name,"r")
      ;vnames = getfilevarnames(f)
      ;print(vnames)
    end if

  ;---- READ VARIABLES ---------------------------------------------------------

  time = f->TIME
  t_length = dimsizes(time)
  t = time(t_length-1) ; only grab most recent data

  ; temperature profile
  depth_t = f->DEPTH
  ;depth_t = depth_t(0:dimsizes(depth_t)-2) ; eliminate the erroneous depth
  tprof = f->TEMP(t_length-1,:,0,0)
  ;tprof = tprof(0:dimsizes(tprof)-2))

  ; salinity profile
  depth_s = f->DEPPSAL
  ;depth_s = depth_s(0:dimsizes(depth_s)-2) ; eliminate the erroneous depth
  sprof = f->PSAL(t_length-1,:,0,0)
  ;sprof = sprof(0:dimsizes(sprof)-2))

  ; get the date string
  load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
  date = cd_string(t,"%Y-%N-%D %H:%M:%S")

  ;---- EXPORTATION TO ASCII FILES ----------------------------------------------

  ; linear interpolate the missing values
  tprof@_FillValue = 1e+35
  t_prof = linmsg(tprof,-1)  ; endPoint= -1 missing end point(s)
                             ;              set to nearest non-missing value
  sprof@_FillValue = 1e+35
  s_prof = linmsg(sprof,-1)  ; endPoint= -1 missing end point(s)
                             ;              set to nearest non-missing value

  ; the directory storing forcing data
  GOTMWORK_ROOT = "~/Documents/GitLab/GOTM_dev/gotmwork"
  basecase = getenv("GOTMWORK_ROOT") + "/data/OCSPapa_forecast"

  file_I = basecase+"/tprof_file.dat"
  system("/bin/rm -f "+file_I)   ; remove any pre-existing file
  write_table(file_I, "w", [/date,dimsizes(t_prof),2/], "%s  %i  %i")
  write_table(file_I, "a", [/-depth_t,t_prof/], "%6.1f   %9.6f") ; append

  file_I = basecase+"/sprof_file.dat"
  system("/bin/rm -f "+file_I)   ; remove any pre-existing file
  write_table(file_I, "w", [/date,dimsizes(s_prof),2/], "%s  %i  %i")
  write_table(file_I, "a", [/-depth_s,s_prof/], "%6.1f   %9.6f") ; append

end
