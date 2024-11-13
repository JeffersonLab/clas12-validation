#!/bin/bash
# build GEMC wrapper

set -e
set -u

sourceDir=$1

### source environment
set +u
source /etc/profile.d/localSetup.sh
set -u

### compile GEMC in $sourceDir
pushd $sourceDir
scons -j$(nproc) OPT=1
popd
