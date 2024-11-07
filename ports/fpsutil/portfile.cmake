vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO vtpl1/fpsutil
  REF "v${VERSION}"
  SHA512 1fa2ed8d4649c027c38c8e8a82af24865f984c48cf311e266ddb5b31a2db3ad218af62d4df33cf66dfb13061fc21331dbf9d8632dbdb41c6a6976a2d88b43e1e
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