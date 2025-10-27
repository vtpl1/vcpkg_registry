vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/uriparseutil
  REF "v${VERSION}"
  SHA512 258a150025561991509db1b9b3dfe6f1f75775080e5cbfd0d672a4fabaa2caa2cac0b4d4ebce3e50b0c526807d9b2183d7e8dff4fc7f6e58cd906610b0f471de
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