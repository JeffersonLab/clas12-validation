#!/bin/bash
# CI `gemc` wrapper for CI workflow steps when `uses: [CONTAINER]` is used,
# which does not seem to be compatible with multi-line commands

set -e
set -u

### usage
if [ $# -eq 0 ]; then
  echo """
  USAGE: $0 [command] [ARGS]...
    commands:

      build  compile GEMC
             ARGS: [source_dir]

      sim    run GEMC
             ARGS: [source_dir] [config] [input] [output]

  """ >&2
  exit 2
fi
cmd=$1
shift

### parse arguments
case $cmd in
  build)
    sourceDir=$1
    ;;
  sim)
    sourceDir=$1
    gemcConfigFile=$2
    evgenFile=$3
    simFile=$4
    ;;
  *)
    echo "ERROR: unknown command '$cmd'" >&2
    exit 1
    ;;
esac

### source environment, and show available modules
set +u
source /app/localSetup.sh
set -u
echo "=============================="
echo "MODULE AVAIL"
echo "=============================="
module avail --no-pager
echo "=============================="

### compile GEMC in $sourceDir
if [ "$cmd" = "build" ]; then
  pushd $sourceDir
  scons -j4 OPT=1
  popd
fi

### to get the dependencies correct, switch to this tag
##### FIXME: switch to gemc/dev and use ubuntu + cvmfs action
module switch gemc/5.4

### run a simulation or print build info
case $cmd in
  sim)
    ### run a simulation
    $sourceDir/gemc \
      $gemcConfigFile \
      -INPUT_GEN_FILE="LUND, $evgenFile" \
      -USE_GUI=0 \
      -OUTPUT="hipo, $simFile"
    ;;
  build)
    ### print build info
    echo "### GEMC Build Information:"
    $sourceDir/gemc -USE_GUI=0
    popd
    ;;
esac
