#!/bin/bash
# CI `gemc` build wrapper for CI workflow steps when `uses: [CONTAINER]` is used,
# which does not seem to be compatible with multi-line commands

if [ $# -ne 1 ]; then
  echo "USAGE: $0 [source dir]" >&2
  exit 2
fi
pushd $1

source /app/localSetup.sh
scons -j4 OPT=1

module switch gemc/5.4 # for dependency files ##### FIXME: switch to gemc/dev and use ubuntu + cvmfs action

echo "### GEMC Build Information:"
./gemc -USE_GUI=0

popd
