vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/uriparseutil
  REF "v${VERSION}"
  SHA512 5596bf7ab41a73947c124d8e543524eddeb47ec0e35a6b82f1e725840fd24b35acb8edf21dae60953ff5d3d9b86e1f31e13b499aff223d612631854235cbcfd6
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