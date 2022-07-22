vcpkg_check_linkage(ONLY_STATIC_LIBRARY) 

vcpkg_download_distfile(ARCHIVE
    URLS "http://www.live555.com/liveMedia/public/live.2022.07.14.tar.gz"
    FILENAME "live.2022.07.14.tar.gz"
    SHA512 382544d9d9fe200699669a1f3301efb4ccec0193499c95b532ea923c380b1ec6fa721a4118d36a447ba9df08575f185498f244293c66bbe97cff0482eab033c7
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE} 
    # PATCHES
    #     fix-RTSPClient.patch
)

configure_file(
    ${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
    ${SOURCE_PATH}/cmake/config.cmake.in
    COPYONLY
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_install_cmake()
# vcpkg_fixup_cmake_targets()

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/COPYING"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)