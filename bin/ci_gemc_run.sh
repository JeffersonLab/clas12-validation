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

### run a simulation
$gemcExe \
  $gemcConfigFile \
  -INPUT_GEN_FILE="LUND, $evgenFile" \
  -USE_GUI=0 \
  -OUTPUT="hipo, $simFile"
