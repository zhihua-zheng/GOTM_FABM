#!/bin/bash
# This script builds netcdf-c library first and then build netcdf-fortran library
# Originally created by Zhihua Zheng on May 22 2018

# define parent directory
export FGDIR=/Users/Danny/Documents/GitHub/GOTM_FABM

# create temporary build folder
mkdir -p ${FGDIR}/build/gotm
mkdir -p ${FGDIR}/build/fabm

mkdir -p ${FGDIR}/local/gotm
mkdir -p ${FGDIR}/local/fabm

# build and compile FABM
cd ${FGDIR}/build/fabm
cmake ${FGDIR}/FABM/code/src -DFABM_HOST=gotm -DCMAKE_INSTALL_PREFIX=${FGDIR}/local/fabm -DCMAKE_Fortran_COMPILER=gfortran
make
make install

# build and compile GOTM
cd ${FGDIR}/build/gotm
cmake ${FGDIR}/GOTM/code/src -DFABM_BASE=${FGDIR}/FABM/code -DCMAKE_INSTALL_PREFIX=${FGDIR}/local/gotm -DCMAKE_Fortran_COMPILER=gfortran
make
make install

export GOTMDIR=${FGDIR}/GOTM/code

rm -r build
