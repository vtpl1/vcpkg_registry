# vcpkg_registry
.\thirdparty\vcpkg\vcpkg.exe install httpserver --overlay-ports=vcpkg_registry/ports/httpserver
git add ports
git commit -m "[logutil] new port"
git rev-parse HEAD:ports/logutil
git add versions
git commit --amend --no-edit

..\thirdparty\vcpkg\vcpkg.exe install logutil --overlay-ports=ports/logutil
..\thirdparty\vcpkg\vcpkg.exe remove logutil --overlay-ports=ports/logutil


..\thirdparty\vcpkg\vcpkg.exe create vtpllive555 http://www.live555.com/liveMedia/public/live.2022.07.14.tar.gz live.2022.07.14.tar.gz

..\thirdparty\vcpkg\vcpkg.exe install vtpllive555 --overlay-ports=ports/vtpllive555
..\thirdparty\vcpkg\vcpkg.exe remove vtpllive555 --overlay-ports=ports/vtpllive555

git add ports
git commit -m "[live555] new port"
git rev-parse HEAD:ports/live555
git add versions
git commit --amend --no-edit

..\thirdparty\vcpkg\vcpkg.exe remove queueutil
..\thirdparty\vcpkg\vcpkg.exe install queueutil --overlay-ports=ports/queueutil

..\thirdparty\vcpkg\vcpkg.exe remove fpsutil
..\thirdparty\vcpkg\vcpkg.exe install fpsutil --overlay-ports=ports/fpsutil

git add ports
git commit -m "[fpsutil] new port"
git rev-parse HEAD:ports/fpsutil
git add versions
git commit --amend --no-edit

../thirdparty/vcpkg/vcpkg remove magic-enum
../thirdparty/vcpkg/vcpkg install magic-enum --overlay-ports=ports/magic-enum

git add ports
git commit -m "[magic-enum] new port"
git rev-parse HEAD:ports/magic-enum
git add versions
git commit --amend --no-edit

../thirdparty/vcpkg/vcpkg format-manifest ports/processutil/vcpkg.json
../thirdparty/vcpkg/vcpkg format-manifest ports/fpsutil/vcpkg.json
../thirdparty/vcpkg/vcpkg format-manifest ports/queueutil/vcpkg.json
../thirdparty/vcpkg/vcpkg format-manifest ports/logutil/vcpkg.json
../thirdparty/vcpkg/vcpkg format-manifest ports/fileutil/vcpkg.json
../thirdparty/vcpkg/vcpkg format-manifest ports/envutil/vcpkg.json

../thirdparty/vcpkg/vcpkg  --x-builtin-ports-root=./ports --overwrite-version --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose

../thirdparty/vcpkg/vcpkg remove frameutil
update ports/frameutil/vcpkg.json
../thirdparty/vcpkg/vcpkg install frameutil --overlay-ports=ports/frameutil
update hash in ports/frameutil/portfile.cmake
../thirdparty/vcpkg/vcpkg install frameutil --overlay-ports=ports/frameutil

git add ports
git commit -m "[frameutil] new port"
git rev-parse HEAD:ports/frameutil
add new entry in versions/f-/frameutil.json
update frameutil baseline in versions/baseline.json
git add versions
git commit --amend --no-edit
