#!/bin/bash
set -euo pipefail
DENTAL_BASE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source "$DENTAL_BASE/common-unix.sh"
platform_paths
[[ "$DENTAL_PLATFORM" == linux ]] || fail 'This script requires Ubuntu 24.04 x64.'
source /etc/os-release
[[ "$ID" == ubuntu && "$VERSION_ID" == 24.04 ]] || fail 'This release supports Ubuntu 24.04 x64 desktops.'
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
if [[ ! -x "$DENTAL_JAVA/bin/java" ]]; then
  sudo apt-get update
  sudo apt-get install -y openjdk-21-jdk
fi
if [[ ! -x "$DENTAL_SWIPL" ]]; then
  printf '%s\n' 'Building SWI-Prolog 10.0.2 with JPL for all users. Initial setup can take several minutes.'
  sudo apt-get update
  sudo apt-get install -y build-essential cmake ninja-build libgmp-dev zlib1g-dev libedit-dev libncurses-dev libutf8proc-dev curl ca-certificates
  fetch 'https://www.swi-prolog.org/download/stable/src/swipl-10.0.2.tar.gz' 'e42cc098f7b8a6051c4f79a99b55162d467098aba60f69649bdc7583f0734b57' "$WORK/swipl.tar.gz"
  tar xzf "$WORK/swipl.tar.gz" -C "$WORK"
  export JAVA_HOME="$DENTAL_JAVA"
  cmake -S "$WORK/swipl-10.0.2" -B "$WORK/build" -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$DENTAL_PROLOG" -DSWIPL_PACKAGES=ON '-DSWIPL_PACKAGE_LIST=clib;plunit;jpl' -DINSTALL_DOCUMENTATION=OFF
  cmake --build "$WORK/build" --parallel "$(nproc)"
  sudo cmake --install "$WORK/build"
fi
check_dependencies
launch_java "$DENTAL_BASE/../application" --verify-runtime
printf '%s\n' 'Dependencies ready. Run Install-Application-Linux.sh next.'
