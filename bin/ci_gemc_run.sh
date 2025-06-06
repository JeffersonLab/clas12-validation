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
CCDB_CONNECTION: ${CCDB_CONNECTION-}
ls CCDB_CONNECTION:
$(ls /cvmfs_ccdb)
=============================="""

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
