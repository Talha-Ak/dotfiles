#!/run/current-system/sw/bin/bash

readonly GUEST_NAME="$1"
readonly OPERATION="$2"
readonly SUB_OPERATION="$3"

readonly guest="win11"

function start_hook() {
    # Unload NVIDIA
    modprobe -r nvidia_drm
    modprobe -r nvidia_modeset
    modprobe -r nvidia_uvm
    modprobe -r nvidia
}

function revert_hook() {
    # Load NVIDIA
    modprobe -r nvidia
    modprobe -r nvidia_uvm
    modprobe -r nvidia_modeset
    modprobe -r nvidia_drm
}

if [[ "$GUEST_NAME" != "$guest" ]]; then
    exit 0
fi

if [[ "$OPERATION" == "prepare" && "$SUB_OPERATION" == "begin" ]]; then
    start_hook
elif [[ "$OPERATION" == "release" && "$SUB_OPERATION" == "end" ]]; then
    revert_hook
fi

