# vcpkg_registry
.\thirdparty\vcpkg\vcpkg.exe install httpserver --overlay-ports=vcpkg_registry/ports/httpserver
git add ports
git commit -m "[logutil] new port"
git rev-parse HEAD:ports
git add versions
git commit --amend --no-edit

.\thirdparty\vcpkg\vcpkg.exe build logutil --overlay-ports=vcpkg_registry/ports/logutil
.\thirdparty\vcpkg\vcpkg.exe remove httpserver --overlay-ports=vcpkg_registry/ports/httpserver