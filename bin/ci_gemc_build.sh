#!/bin/bash
# build GEMC wrapper

set -e
set -u

sourceDir=$1

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

### compile GEMC in $sourceDir
pushd $sourceDir
scons -j$(nproc) OPT=1
popd
