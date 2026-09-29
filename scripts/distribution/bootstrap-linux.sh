#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
mkdir -p "$ROOT/.runtime"
cd "$ROOT/.runtime"
curl --fail --location https://www.swi-prolog.org/download/stable/src/swipl-10.0.2.tar.gz -o swipl.tar.gz
echo 'e42cc098f7b8a6051c4f79a99b55162d467098aba60f69649bdc7583f0734b57  swipl.tar.gz' | sha256sum -c -
tar xzf swipl.tar.gz
cmake -S swipl-10.0.2 -B swi-build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$ROOT/.runtime/prolog" -DSWIPL_PACKAGES=ON '-DSWIPL_PACKAGE_LIST=clib;plunit;jpl' -DINSTALL_DOCUMENTATION=OFF
cmake --build swi-build --parallel 4
cmake --install swi-build
mkdir -p prolog/native prolog/legal
# Keep the runtime's non-system native dependency closure relocatable.
while IFS= read -r library; do
  while IFS= read -r dependency; do
    case "$(basename "$dependency")" in
      libc.so.*|libm.so.*|libpthread.so.*|libdl.so.*|librt.so.*|ld-linux*|libjvm.so) continue ;;
    esac
cp -L "$dependency" prolog/native/
owner=$(dpkg-query -S "$(readlink -f "$dependency")" 2>/dev/null | head -1 || true)
owner=${owner%%: *}; owner=${owner%%:*}
if [ -n "$owner" ] && [ -f "/usr/share/doc/$owner/copyright" ]; then
  cp -L "/usr/share/doc/$owner/copyright" "prolog/legal/$owner-copyright.txt"
fi
  done < <(ldd "$library" | awk '/=> \//{print $3}')
done < <(find prolog -type f -name '*.so*')
find prolog -type f -name '*.so*' -exec patchelf --set-rpath '$ORIGIN' {} \;
# Launch scripts also set LD_LIBRARY_PATH to the collected dependency folder.
cp swipl-10.0.2/LICENSE prolog/LICENSE
