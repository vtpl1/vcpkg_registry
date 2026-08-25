# vrtc-gst-contract — part of the vrtc shared-element programme.
# Plan of record: docs/PLAN-shared-element-libraries.md in vtpl1/vrtc-pipeline.

# vcpkg_from_git, NOT vcpkg_from_github, and that is load-bearing.
#
# vtpl1/vrtc-gst-contract is a PRIVATE repository. vcpkg_from_github fetches
# https://github.com/<repo>/archive/<ref>.tar.gz over plain HTTPS, which for a
# private repo returns 404 to any caller without a token — measured, not
# assumed. vcpkg_from_git CLONES instead, so it goes through git's own
# credential helper, which every box that can clone vrtc-pipeline already has
# configured. No token needs to be planted in vcpkg's environment, and none
# needs to be baked into an image.
#
# REF is a full commit SHA because vcpkg_from_git requires one: a tag is a
# moving target and would make the port irreproducible.
#
# If a consumer sees "could not read Username for 'https://github.com'", that is
# git auth missing in THAT environment, not a broken port. Docker builds need
# the credential passed in as a BuildKit secret -- never a baked token.
vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://github.com/vtpl1/vrtc-gst-contract.git"
    REF 8981f2d070edafe57fb813d9af46eb74bbe448be
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME vrtc-gst-contract CONFIG_PATH "share/vrtc-gst-contract")

# Headers are installed once, from the release tree.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
