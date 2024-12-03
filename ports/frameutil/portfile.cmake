vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/frameutil
  REF "v${VERSION}"
  SHA512 64530b36c03d2dd93ad59fa1b34950b769f6c744a94b4e5ea29303fde38c017f7a23fbc641e2f2142a07e8dcb5d662308c2dbd3aedbb8a52248ce7d09753499c
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