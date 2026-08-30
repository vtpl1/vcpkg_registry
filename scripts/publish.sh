#!/usr/bin/env bash
# Update the versions database, using vcpkg's own tooling.
#
#   scripts/publish.sh
#
# This is step 4 of the flow Microsoft documents for a git registry
# (learn.microsoft.com/vcpkg/produce/publish-to-a-git-registry), and the order
# around it is not advisory:
#
#   1. package repo:  commit, then  git tag -a vX.Y.Z  (ANNOTATED), push
#   2. here:          set the port's REF to that commit and "version" to X.Y.Z
#   3. here:          git add ports/. && git commit        <- ports FIRST
#   4. here:          scripts/publish.sh                   <- this script
#   5. here:          git add . && git commit -m "Update versions database"
#
# WHY THE PORT IS COMMITTED BEFORE THIS RUNS. A git registry identifies each
# published version by the `git-tree` SHA of its port DIRECTORY, and that SHA is
# only recalculated when a commit modifies the directory. Running this against
# an uncommitted port records a tree that is not in the repository's history,
# which vcpkg then cannot retrieve. x-add-version refuses it outright, and the
# refusal is the useful behaviour.
#
# WHY --all AND NOT ONE PORT AT A TIME. It is the documented form, and it makes
# the versions database a function of the ports directory rather than of who
# remembered to run what. A port whose contents changed without a version bump
# is reported here rather than shipping as a silently different 1.0.0.
#
# NEVER REWRITE A PUBLISHED VERSION. vcpkg's design guarantees an installed
# dependency does not change without user intervention, and changing the
# git-tree of a version already in versions/ breaks exactly that. If a published
# version is wrong, publish a new port-version instead. --overwrite-version
# exists and is not for this.
set -euo pipefail
cd "$(dirname "$0")/.."
REG="$(pwd)"

VCPKG="${VCPKG:-$(command -v vcpkg || true)}"
[ -n "$VCPKG" ] && [ -x "$VCPKG" ] || {
    echo "vcpkg not found. Set VCPKG=/path/to/vcpkg — the ref is pinned in" >&2
    echo "ports/vtpl-dependency-floor/dependency-floor.json." >&2; exit 2; }

# The version/tag/REF agreement gate runs BEFORE publishing, not after: a wrong
# version added to versions/ is in the registry's history, and removing one is a
# history rewrite.
echo "==> checking every port against the annotated tag it pins"
bash scripts/check_port_versions.sh

if [ -n "$(git -C "$REG" status --porcelain -- ports/)" ]; then
    echo >&2
    echo "FAIL: ports/ has uncommitted changes:" >&2
    git -C "$REG" status --short -- ports/ | sed 's/^/      /' >&2
    echo "      Commit the ports first — the git-tree x-add-version records is" >&2
    echo "      the COMMITTED tree of each port directory." >&2
    exit 1
fi

echo "==> vcpkg x-add-version --all"
"$VCPKG" --x-builtin-ports-root="$REG/ports" \
         --x-builtin-registry-versions-dir="$REG/versions" \
         x-add-version --all --verbose

echo
echo "versions database updated. Review, then commit:"
echo "    git add . && git commit -m 'Update versions database'"
git -C "$REG" status --short -- versions/ | sed 's/^/    /'
