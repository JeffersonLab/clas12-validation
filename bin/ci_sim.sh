#!/bin/bash
# CI `gemc` wrapper for CI workflow steps when `uses: [CONTAINER]` is used,
# which does not seem to be compatible with multi-line commands

if [ $# -ne 3 ]; then
  echo "USAGE: $0 [config] [input] [output]" >&2
  exit 2
fi
gemcConfigFile=$1
evgenFile=$2
simFile=$3

source /app/localSetup.sh

module switch gemc/5.4 # for dependency files ##### FIXME: switch to gemc/dev and use ubuntu + cvmfs action

clas12Tags/source/gemc \
  $gemcConfigFile \
  -INPUT_GEN_FILE="LUND, $evgenFile" \
  -USE_GUI=0 \
  -OUTPUT="hipo, $simFile"
