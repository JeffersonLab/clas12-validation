#!/bin/bash
# run GEMC wrapper

set -e
set -u

gemcVer=$1
gemcConfigFile=$2
evgenFile=$3
simFile=$4

### source environment
set +u
source /etc/profile.d/localSetup.sh
set -u

### switch the gemc module, or use the CI build
gemcExe=gemc
case $gemcVer in
  build)
    gemcExe=./clas12Tags/source/gemc
    # use checked out experiment directory
    export GEMC_DATA_DIR=$(pwd)/clas12Tags
    ;;
  default)
    ;;
  *)
    echo '''
    ==============================
    MODULE AVAIL
    =============================='''
    module avail --no-pager
    echo '=============================='
    module switch gemc/$gemcVer
    ;;
esac

### echo env vars
echo """==============================
CCDB_CONNECTION = ${CCDB_CONNECTION-}
=============================="""
echo "DEBUG 0"
ls /cvmfs_ccdb
echo "DEBUG END"
# echo "DEBUG 1"
# ls /cvmfs_ext
# echo "DEBUG 2"
# ls /cvmfs_ext/oasis.opensciencegrid.org
# echo "DEBUG 3"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab
# echo "DEBUG 4"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb
# echo "DEBUG 5"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12
# echo "DEBUG 6"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12/sw
# echo "DEBUG 7"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/noarch
# echo "DEBUG 8"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/noarch/data
# echo "DEBUG 9"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/noarch/data/ccdb
# echo "DEBUG 10"
# ls /cvmfs_ext/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/noarch/data/ccdb/ccdb_latest.sqlite

### run a simulation, with truth-matching enabled
$gemcExe \
  $gemcConfigFile \
  -INPUT_GEN_FILE="LUND, $evgenFile" \
  -USE_GUI=0 \
  -OUTPUT="hipo, $simFile" \
  -RUNNO=11 \
  -SAVE_ALL_MOTHERS=1 \
  -SKIPREJECTEDHITS=1 \
  -INTEGRATEDRAW="*" \
  -NGENP=50
