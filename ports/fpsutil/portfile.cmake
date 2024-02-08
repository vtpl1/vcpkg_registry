vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/fpsutil
  REF v1.0.11
  SHA512 d65aa14e6836ac7ae59c91123497c11a6ed7c749f0902af3e6c0fd7182bc2dddb7a66065ea827c73a4dea3d56c0f8a8bd972624caa2a3bded447941b53e9691c
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