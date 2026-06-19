#!/usr/bin/env bash
#
# ios-test.sh — generate the Xcode project and run the iOS app test suite on a
# simulator. Used by both CI and local development so the command never drifts.
#
# Rather than pinning an exact simulator name/OS (which breaks whenever the
# installed runtime moves from e.g. 26.0 to 26.0.1), this selects the newest
# available iPhone simulator by UDID. Determinism comes from pinning the Xcode
# version; the device is whatever iPhone that Xcode ships.
#
# Usage: Scripts/ios-test.sh [extra xcodebuild args...]

set -euo pipefail
cd "$(dirname "$0")/.."

# 1. Generate the project from the declarative spec.
( cd App && xcodegen generate )

# 2. Pick the newest available iPhone simulator.
DEST_ID="$(xcrun simctl list devices available --json | python3 -c '
import json, re, sys
devices = json.load(sys.stdin)["devices"]
best = None
for runtime, devs in devices.items():
    match = re.search(r"iOS-([0-9-]+)", runtime)
    if not match:
        continue
    version = tuple(int(part) for part in match.group(1).split("-"))
    for device in devs:
        if device.get("isAvailable") and device["name"].startswith("iPhone"):
            key = (version, device["name"])
            if best is None or key > best[0]:
                best = (key, device["udid"])
print(best[1] if best else "")
')"

if [[ -z "$DEST_ID" ]]; then
    echo "::error::No available iPhone simulator found." >&2
    exit 1
fi
echo "Using simulator destination id: $DEST_ID"

# 3. Build & test, then assert tests actually ran.
set -o pipefail
xcodebuild test \
    -project App/AlcoholTracker.xcodeproj \
    -scheme AlcoholTracker \
    -destination "platform=iOS Simulator,id=$DEST_ID" \
    CODE_SIGNING_ALLOWED=NO \
    "$@" \
    2>&1 | tee xcodebuild-test.log

Scripts/assert-tests-ran.sh xcodebuild-test.log
