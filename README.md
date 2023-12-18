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