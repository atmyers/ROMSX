#!/bin/bash

set -e

umask 002

git clone --recursive git@github.com:seahorce-scidac/ROMSX
git clone --recursive git@github.com:seahorce-scidac/COAWST

cd COAWST

git apply ../ROMSX/Build/compare_flat_tweak_inputs.patch

cd ../ROMSX/Build
if [ "$NERSC_HOST" == "cori" ]
then
source cori-env.sh
elif [ "$NERSC_HOST" == "perlmutter" ]
then
source saul-env.sh
else
export NETCDF_INCDIR=${NETCDF_DIR}/include
export NETCDF_LIBDIR=${NETCDF_DIR}/lib
fi

echo "We will use these paths for netcdf:"
echo "${NETCDF_DIR}"
echo "${NETCDF_LIBDIR}"
echo "${NETCDF_INCDIR}"

cd ../Exec/Upwelling
nice make -j16 USE_NETCDF=TRUE DEBUG=TRUE
#./ROMSX3d.gnu.DEBUG.TPROF.MPI.ex inputs amrex.fpe_trap_invalid=0 romsx.plotfile_type=netcdf romsx.plot_int_1=1 max_step=10
cd ../../../

cd COAWST

#activeList = {
#  ["Nsight-Compute"] = "2022.1.1",
#  ["Nsight-Systems"] = "2022.2.1",
#  ["PrgEnv-gnu"] = "8.3.3",
#  ["cpe"] = "22.11",
#  ["cray-dsmml"] = "0.2.2",
#  ["cray-hdf5"] = "1.12.2.1",
#  ["cray-libsci"] = "22.11.1.2",
#  ["cray-mpich"] = "8.1.22",
#  ["cray-netcdf"] = "4.9.0.1",
#  ["craype"] = "2.7.19",
#  ["craype-accel-nvidia80"] = "",
#  ["craype-network-ofi"] = "",
#  ["craype-x86-milan"] = "",
#  ["cudatoolkit"] = "11.7",
#  ["gcc"] = "11.2.0",
#  ["gpu"] = "1.0",
#  ["libfabric"] = "1.15.2.0",
#  ["perftools-base"] = "22.09.0",
#  ["xalt"] = "2.10.2",
#  ["xpmem"] = "2.5.2-2.4_3.20__gd0f7936.shasta",
#}

./coawst.bash -j 4
#./coawst.bash -noclean -j 4
#./coawstM ROMS/External/roms_upwelling.in