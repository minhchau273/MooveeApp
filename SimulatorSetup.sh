#!/bin/sh
#
# Setup Simulator accounts for testing
# by overwriting Simulator Library with contents of SimulatorLibraryOverride folder
#
# To update SimulatorLibraryOverride manually copy included subdirectories from simulator library folder
echo "$PROJECT_DIR" > ~/current_directory.txt
if [[ -d "$PROJECT_DIR" ]]
then
    echo "Overriding accounts in iPhone Simulator sandbox environment" > ~/current.txt
    for device in ~/Library/Developer/CoreSimulator/Devices/*/device.plist; do
        runtime=$(defaults read "${device}" runtime)
        devicedir="$(dirname ${device})"
        libdir="$devicedir/data/Library"
        if [[ $runtime = com.apple.CoreSimulator.SimRuntime.iOS-9* ]]
        then
            echo "Overriding iOS9 accounts in:$libdir"
            cp -vfR "$PROJECT_DIR/SimulatorLibraryOverride8"/* "$libdir"/
        fi
    done
else
    echo "PROJECT_DIR is not defined to find override files"
    exit 1
fi