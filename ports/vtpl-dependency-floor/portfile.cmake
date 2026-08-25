# vtpl-dependency-floor — the floor itself, shipped as data.
# Plan of record: docs/PLAN-shared-element-libraries.md T-20 in vtpl1/vrtc-pipeline.

# THIS PORT COMPILES NOTHING AND FETCHES NOTHING.
#
# The floor exists because vcpkg honours `builtin-baseline` and `overrides` only
# in the TOP-LEVEL manifest — a port cannot hand its pins down to a consumer. So
# every consumer restates the floor and a check keeps them in step, and the check
# needs something to compare against.
#
# That something is dependency-floor.json in THIS DIRECTORY. It is not fetched
# from a source repo, because the registry is already the one place all six
# consumers agree on; adding a repo to clone would put the canonical copy one
# indirection further away and give the file a second home to drift from.
#
# Installing it (rather than only publishing it) is what makes the consumer-side
# check work OFFLINE: after resolution the file sits in
# vcpkg_installed/<triplet>/share/vtpl-dependency-floor/, so a CI job that has
# already resolved its manifest needs no network and no credentials to verify its
# own pins. A check that needs a live fetch is a check that gets skipped.
#
# Consequence to accept deliberately: editing the floor is a VERSION BUMP of this
# port. That is correct rather than annoying — consumers pin the floor, and a
# floor that could change under a pinned consumer would not be a floor.

set(VCPKG_BUILD_TYPE release)
# Nothing is compiled, so there are no headers. Without this, vcpkg's post-build
# validation fails the port for an empty include/ directory.
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

file(INSTALL "${CURRENT_PORT_DIR}/dependency-floor.json"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(INSTALL "${CURRENT_PORT_DIR}/usage"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright"
     "Copyright 2026 Videonetics Technology Pvt Ltd\nSPDX-License-Identifier: Apache-2.0\n")
