#!/usr/bin/env bash
# A port's version must equal the ANNOTATED GIT TAG at the commit the port pins.
#
# WHY THIS IS A CHECK AND NOT A CONVENTION. vcpkg does not verify the pair. It
# installs whatever the port says, while the package's generated
# <name>-config-version.cmake is written from project(VERSION) in the sources
# the portfile actually cloned. When they disagree, `vcpkg install` succeeds,
# the headers are correct, and then
#
#     find_package(vrtc-vrpc 1.2.0 REQUIRED)
#
# fails in the consumer with "could not find a configuration file compatible
# with requested version" — naming a version vcpkg has already installed. It
# reads as a broken consumer rather than a mispublished port.
#
# Measured 2026-08-30, before this existed: three of the five ports were
# published at 1.1.x with NO tag at the pinned commit, and one port had been
# raised to 1.2.0 while its CMakeLists still said 1.1.0.
#
# WHY THE TAG AND NOT project(VERSION). Since the same date the number lives in
# git: project(VERSION) resolves from the annotated tag, or from the portfile's
# -DVRTC_PKG_VERSION when a vcpkg export has stripped .git. Grepping
# CMakeLists.txt would find `${VRTC_VERSION}` and prove nothing. The tag is the
# source, so the tag is what a port is checked against.
#
# WHY IT LIVES HERE and not in the five package repos: the registry is the only
# place that knows both halves. A package repo cannot see its own port, and
# making it look would give every package a dependency on this repo — the
# coupling those packages are kept free of on purpose.
#
# IT NEVER SKIPS. A port it cannot verify is a failure with the reason, not a
# silent pass: a check that quietly does nothing is worse than none, because it
# reads as coverage.
set -euo pipefail
cd "$(dirname "$0")/.."

# Sibling checkouts, since portfiles pin private repos this script must not clone.
SIBLINGS="${VRTC_SIBLING_DIR:-..}"

fail=0
n=0
for port in ports/vrtc-*/; do
    name=$(basename "$port")
    [ -f "$port/vcpkg.json" ] || continue

    pv=$(tr -d ' \t\n' < "$port/vcpkg.json" | grep -oE '"version":"[^"]+"' | head -1 | cut -d'"' -f4)
    if [ -z "$pv" ]; then
        echo "FAIL: $name has no \"version\" in its port manifest" >&2; fail=1; continue
    fi

    ref=$(grep -oE '[0-9a-f]{40}' "$port/portfile.cmake" | head -1)
    if [ -z "$ref" ]; then
        echo "FAIL: $name/portfile.cmake pins no 40-hex REF" >&2; fail=1; continue
    fi

    repo="$SIBLINGS/$name"
    if [ ! -d "$repo/.git" ]; then
        echo "FAIL: cannot verify $name — no checkout at $repo." >&2
        echo "      Clone it beside this registry, or set VRTC_SIBLING_DIR." >&2
        fail=1; continue
    fi
    if ! git -C "$repo" cat-file -e "${ref}^{commit}" 2>/dev/null; then
        echo "FAIL: $name pins ${ref:0:12}, not present in $repo (fetch it, or the port pins a lost commit)" >&2
        fail=1; continue
    fi

    # The tag AT THE PINNED COMMIT, not at that checkout's HEAD: HEAD is whatever
    # the developer happens to have; the published artifact is built from the REF.
    tag=$(git -C "$repo" describe --tags --abbrev=0 "$ref" 2>/dev/null || true)
    if [ -z "$tag" ]; then
        echo "FAIL: $name pins ${ref:0:12}, which has no tag reachable from it." >&2
        echo "      The published commit must carry its version:  git -C $repo tag -a v$pv $ref" >&2
        fail=1; continue
    fi
    if [ "$(git -C "$repo" cat-file -t "$tag" 2>/dev/null)" != "tag" ]; then
        echo "FAIL: $name — $tag is a lightweight tag; release tags must be annotated (git tag -a)" >&2
        fail=1; continue
    fi

    n=$((n + 1))
    if [ "v$pv" != "$tag" ]; then
        echo "FAIL: $name port says $pv but the tag at ${ref:0:12} is $tag" >&2
        fail=1
    fi
done

[ "$fail" = 0 ] && echo "ok: $n port(s) carry the version of the annotated tag they pin"
exit "$fail"
