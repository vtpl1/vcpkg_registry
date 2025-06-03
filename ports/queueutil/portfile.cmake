vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/queueutil
  REF "v${VERSION}"
  SHA512 d54d30f8be7b3c97f83977bf3974df3bbf4e95facc342c64398aa0cd5335e7b1e840f3281f7f7a2b5cfc0f56517c026e52ca4501d2d9fb00ab525976bedf5729
  HEAD_REF main
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
)
vcpkg_install_cmake()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)