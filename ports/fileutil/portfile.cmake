vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/fileutil
  REF "v${VERSION}"
  SHA512 66978025334d0a29d312110b1738e3c18eae54c84584dc8356856cc7f0a3b0e4cbc29b53ca9b9819d96f2834ea9ffe6eddb2212080b28cf0fb0cdba7a7e24c9a
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