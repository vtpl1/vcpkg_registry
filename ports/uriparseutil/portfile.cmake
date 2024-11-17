vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/uriparseutil
  REF "v${VERSION}"
  SHA512 770fddf54f0145be2f8c8661954c5a221f4ec4f500f1a45e80d4e066f0fc6493240b11200b97665c88723b94bfaf94e656a4cc425f9b1b5e03ad2bf2279a205e
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