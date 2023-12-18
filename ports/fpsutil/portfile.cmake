vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/fpsutil
  REF v1.0.8
  SHA512 d7f9f34222a8627c14248cd32aa9fb3bc34e2b5e515013090e5e2cd9548a11d7940ef7e14d5438054defe8988b8ed2647c63b9b9c9dfe0368c5fff5e95e5f74b
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