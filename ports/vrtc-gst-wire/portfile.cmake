# vrtc-gst-wire — part of the vrtc shared-element programme.

# vcpkg_from_git, NOT vcpkg_from_github, and that is load-bearing.
#
# vtpl1/vrtc-gst-wire is a PRIVATE repository. vcpkg_from_github fetches
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
#
# THIS PORT WENT WITHOUT IT UNTIL 0.1.0, and it did not matter while the package
# had a hand-written version.cpp returning a literal — there was nothing to
# discover. Now that the version is generated from git like its siblings', the
# omission would have made every released vrtc-gst-wire report sha "unknown",
# origin "unknown": provenance that is absent precisely in the builds that ship.
set(VRTC_GST_REF f88456528563e0886c5a44e50f2f51cad5df30d9)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://github.com/vtpl1/vrtc-gst-wire.git"
    REF ${VRTC_GST_REF}
)

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
vcpkg_cmake_config_fixup(PACKAGE_NAME vrtc-gst-wire CONFIG_PATH "share/vrtc-gst-wire")

# Headers are installed once, from the release tree.
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
