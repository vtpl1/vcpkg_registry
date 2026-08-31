# vrtc-vrpc — the vrpc transport, distributed as SOURCE.

# This port INSTALLS FILES AND BUILDS NOTHING, which is the whole design. vcpkg
# ships gRPC as a static library only, so a prebuilt archive here would become a
# SECOND gRPC module in any consumer that has gRPC translation units of its own
# — a duplicate protobuf descriptor table (pre-main abort) and a split ExecCtx
# (access violation on the first RPC). Linux hides both; Windows does not. So
# the consumer gets sources plus vrtc_grpc_add_library()/vrtc_grpc_assemble()
# and builds exactly one module. Same shape as vcpkg's own vcpkg-cmake port.

# Release-only: nothing is compiled, so a debug pass would install the identical
# files a second time.
set(VCPKG_BUILD_TYPE release)

# vcpkg_from_git, NOT vcpkg_from_github — vtpl1/vrtc-vrpc is PRIVATE, and
# vcpkg_from_github fetches an HTTPS tarball that returns 404 without a token.
# Cloning goes through git's own credential helper instead. REF is a full commit
# SHA because vcpkg_from_git requires one and a tag would move.
# The REF is bound to a variable and passed on to the build, and that is the
# whole point of it being here twice. vcpkg builds from an export with NO .git
# in it, so the package cannot discover its own commit — it would report
# "unknown" in exactly the situation traceability exists for. Passing the REF
# makes THIS sha, the one actually cloned, the one the payload reports.
#
# IT MATTERS MORE HERE THAN ANYWHERE ELSE IN THE PROGRAMME. This package
# compiles nothing: its version TU ships inside the src/ payload and is compiled
# by the CONSUMER, long after this portfile has run. Whatever sha is resolved at
# THIS moment is the only one that will ever be recorded — there is no later
# build of ours to correct it.
set(VRTC_VRPC_REF 4cbe7bee57527a189559e39e0870ff6796120ff8)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://github.com/vtpl1/vrtc-vrpc.git"
    REF ${VRTC_VRPC_REF}
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    # -DVRTC_PKG_VERSION: vcpkg's ${VERSION} is this port's manifest version, and the
    # package cross-checks it against its own annotated tag. A vcpkg export has no
    # .git, so the tag is unreachable in exactly the build that ships -- same reason
    # VRTC_PKG_GIT_SHA is passed. Passing it keeps the port, the tag and
    # project(VERSION) one number instead of three that merely agree today.
    OPTIONS -DVRTC_PKG_GIT_SHA=${VRTC_VRPC_REF}
            -DVRTC_PKG_VERSION=${VERSION}
)
vcpkg_cmake_install()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
