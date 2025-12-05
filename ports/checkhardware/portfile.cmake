vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/check-hardware-
  REF "v${VERSION}"
  SHA512 1c0c63b4efaedb2d64db4ba71ffd8d1effac782cb9a0ef231bffa18c03490aef276082b0895d2675e5b88e00eaa1593c0eaefb6adb73f4cc7eae71c35a3d934d
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