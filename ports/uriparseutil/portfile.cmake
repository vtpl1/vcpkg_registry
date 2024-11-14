vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/uriparseutil
  REF "v${VERSION}"
  SHA512 1b8fba8678baeb772b9dcd43c193322d259277b4c4aa7f7fc07bfadcea185ca7e38c220cdbf74bd3859382f8c421672ab9cccd45066dc1cbccd19441147ef860
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