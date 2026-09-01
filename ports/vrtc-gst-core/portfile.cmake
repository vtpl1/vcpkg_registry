# vrtc-gst-core — part of the vrtc shared-element programme.

# vcpkg_from_git, NOT vcpkg_from_github, and that is load-bearing.
#
# vtpl1/vrtc-gst-core is a PRIVATE repository. vcpkg_from_github fetches
# https://github.com/<repo>/archive/<ref>.tar.gz over plain HTTPS, which for a
# private repo returns 404 to any caller without a token — measured, not
# assumed. vcpkg_from_git CLONES instead, so it goes through git's own
# credential helper, which every box that can clone these repos already has
# configured. No token needs to be planted in vcpkg's environment, and none
# needs to be baked into an image.
#
# REF is a full commit SHA because vcpkg_from_git requires one: a tag is a
# moving target and would make the port irreproducible.
#
# If a consumer sees "could not read Username for 'https://github.com'", that is
# git auth missing in THAT environment, not a broken port. Docker builds need
# the credential passed in as a BuildKit secret -- never a baked token.
# The REF is bound to a variable and passed on to the build, and that is the
# whole point of it being here twice. vcpkg builds from an export with NO .git
# in it, so the package cannot discover its own commit — it would report
# "unknown" in exactly the situation traceability exists for. Passing the REF
# makes THIS sha, the one actually cloned, the one the binary reports. One
# source, so the two can never disagree.
set(VRTC_GST_REF 382eb4ea48b00df5a42699ddb65fb4aae6ce5598)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://github.com/vtpl1/vrtc-gst-core.git"
    REF ${VRTC_GST_REF}
)

# GStreamer arrives through pkg-config (glib only — this package uses no
# GStreamer element API); libjpeg-turbo and vrtc-gst-contract are declared in
# vcpkg.json. Declaring libjpeg-turbo is load-bearing rather than tidy: without
# it find_package(JPEG) falls through to the SYSTEM libjpeg, which
# ABI-mismatches the encoder and longjmps on every crop — silently, with a green
# build. Measured on a standalone configure that resolved JPEG_LIB_VERSION 80.
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    # -DVRTC_PKG_VERSION: vcpkg's ${VERSION} is this port's manifest version, and the
    # package cross-checks it against its own annotated tag. A vcpkg export has no
    # .git, so the tag is unreachable in exactly the build that ships -- same reason
    # VRTC_PKG_GIT_SHA is passed. Passing it keeps the port, the tag and
    # project(VERSION) one number instead of three that merely agree today.
    OPTIONS -DVRTC_PKG_GIT_SHA=${VRTC_GST_REF}
            -DVRTC_PKG_VERSION=${VERSION}
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME vrtc-gst-core CONFIG_PATH "share/vrtc-gst-core")

# Headers are installed once, from the release tree.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
