vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/queueutil
  REF "v${VERSION}"
  SHA512 7e3db9df469ac040677a0f20da552515a03b961198c139dd1c3650f61ea039a0cdbc6b9f8d15456e2c28a8d4bd7dc52db0111ddc433b2c6ce71054d7b22307c5
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