vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/sort-cpp
  REF "v${VERSION}"
  SHA512 e06d6e62eedcbdc030bfb612e5c0535c01b7b7fd40d3cfdec4f791a8086c6beff3946beef2cbe5a1f785b287d856b64cbe9e8ed6d7c29296ac7445ce5d161398
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