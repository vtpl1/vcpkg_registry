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
