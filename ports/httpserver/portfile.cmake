vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/http_server
  REF 42a36146656b269fb5310f2560260816c73f936f
  SHA512 c7802ccc98e6a48cfb7d24b23c3a8be77d937ebab2b16855e9be58da91ad3c6cd6eefc6fb9dbbdc288e4152016bd736cca657bb88a8fb5cfeab2bc45b9b19b64
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