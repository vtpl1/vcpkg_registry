vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/frameutil
  REF "v${VERSION}"
  SHA512 c03b70c08c41702c608342915b3f34e094faee04b9f3139aada54a1c398f3a88049b2ef4a050fb5308ad57f1c840494f451d87f0329be5bce6603da829608173
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