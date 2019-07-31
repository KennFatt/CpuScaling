#!/bin/bash

if [[ "$EUID" != "0" ]]; then
    echo "$0: Please run this shell as root priveleges."
    exit 1;
fi

# `cpufreq` directory.
CPUFREQ_DIR=/sys/devices/system/cpu/cpufreq
if ! [[ -d $CPUFREQ_DIR ]]; then
    echo "$0: CPUFREQ_DIR is not found, your system might not support intel_pstate scaling."
    exit 0
fi

# Set shell option: nullglob
shopt -s nullglob

# Scanning all the available cpu(s). This is an array.
CPUS=($CPUFREQ_DIR/*)
# Counting all the available cpu(s).
T_CPU=${#CPUS[@]}

function apply_changes() {
    local mode=$1

    # Start copying.
    for ((i = 0; i < $T_CPU; ++i)); do
        for j in $mode/*; do
            cp $j $CPUFREQ_DIR/policy$i
        done
    done

    echo "Applying success! Current mode: $mode"
    exit 0
}

case "$1" in
    -a|--auto)
        apply_changes "auto"
    ;;
    -i|--idle)
        apply_changes "idle"
    ;;
    -p|--performance)
        apply_changes "performance"
    ;;
    -s|--save)
        apply_changes "save"
    ;;
    *)
        echo "$0: no mode given"
        echo "Usage: $0 [mode]"
        echo "Available modes are:"
        echo " -a|--auto            Auto mode, technically default mode"
        echo " -i|--idle            Idle mode, set the lowest frequency as possible"
        echo " -p|--performance     Performance mode, for developing and specific purpose"
        echo " -s|--save            Save mode, good for browsing and do some tasks"
        exit 1
    ;;
esac