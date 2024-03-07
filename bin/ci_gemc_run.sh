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

### switch the gemc module
### - if we do not have a custom `gemc` build (e.g, from a `coatjava` trigger),
###   use whatever the container's default version is
### - if we do have a custom `gemc` build (e.g., from a `clas12Tags` trigger),
###   this just makes sure the dependencies are resolved correctly
### - if this command fails, e.g. if `gemc/$gemcTag` module is not available, a
###   warning is printed and we proceed with the default version in the container
if [ "$gemcExe" != "gemc" ]; then
  module test gemc/$gemcTag &&
    module switch gemc/$gemcTag ||
    echo -e "\e[1;31m[WARNING]: proceeding with container's default GEMC version \e[0m" >&2
fi

### run a simulation
$gemcExe \
  $gemcConfigFile \
  -INPUT_GEN_FILE="LUND, $evgenFile" \
  -USE_GUI=0 \
  -OUTPUT="hipo, $simFile"
