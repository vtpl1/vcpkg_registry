vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/frameutil
  REF "v${VERSION}"
  SHA512 0b035b254bb449a5a67e0fcf3095b5c8fe371add2c852aa7cdacc95ecc25fa6bde1dbbbb36e7896c56154afa75ae6fd6eeb7b26c1f2152f363554e779580fc0b
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