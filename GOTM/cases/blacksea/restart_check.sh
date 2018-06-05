#!/bin/bash

export GOTMDIR=~/source/repos/GOTM/code

fabm_calc=True

make namelist restart_offline=False fabm_calc=$fabm_calc
gotm >& gotm_1.log
mv restart.nc restart_1.nc
mv output.nc output_1.nc

make namelist restart_offline=False stop="1990-07-01 00:00:00" fabm_calc=$fabm_calc
gotm >& gotm_2a.log
cp restart.nc  restart_2a.nc 
mv output.nc output_2a.nc

make namelist restart_offline=True start="1990-07-01 00:00:00" fabm_calc=$fabm_calc restart_allow_missing_variable=False
gotm >& gotm_2b.log
mv restart.nc  restart_2b.nc 
mv output.nc output_2b.nc

md5sum restart_1.nc restart_2b.nc

