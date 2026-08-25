# vrtc-vrpc — the vrpc transport, distributed as SOURCE.
# Plan of record: docs/PLAN-shared-element-libraries.md §3.6 and §4.3 in
# vtpl1/vrtc-pipeline.

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
vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://github.com/vtpl1/vrtc-vrpc.git"
    REF 72b8a4f8bd8b3c8270a325c1b54c535e1a206e51
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
