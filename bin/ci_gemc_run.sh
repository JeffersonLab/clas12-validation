#!/bin/bash
# run GEMC wrapper

set -e
set -u

gemcExe=$1
gemcTag=$2
gemcConfigFile=$3
evgenFile=$4
simFile=$5

### source environment
set +u
source /app/localSetup.sh
set -u

### show available modules
echo "=============================="
echo "MODULE AVAIL"
echo "=============================="
module avail --no-pager
echo "=============================="

### switch to the gemc module
### - if we do not have a custom build, this activates the appropriate gemc version
### - if we do have a custom build, this just makes sure the dependencies are resolved correctly
module switch gemc/$gemcTag

### run a simulation
$gemcExe \
  $gemcConfigFile \
  -INPUT_GEN_FILE="LUND, $evgenFile" \
  -USE_GUI=0 \
  -OUTPUT="hipo, $simFile"
