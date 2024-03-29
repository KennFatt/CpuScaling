#!/bin/bash

if [[ "$EUID" != "0" ]]; then
    echo "$0: Please run this shell as root priveleges."
    exit 1;
fi

# `cpufreq` directory.
CPUFREQ_DIR=/sys/devices/system/cpu/cpufreq
if ! [[ -d $CPUFREQ_DIR ]]; then
    echo "$0: $CPUFREQ_DIR is not found, your system might not support CPU scaling."
    exit 1
fi

# Set shell option: nullglob
shopt -s nullglob

# Scanning all the available cpu(s). This is an array.
CPUS=($CPUFREQ_DIR/*)
# Counting all the available cpu(s).
T_CPU=${#CPUS[@]}
# Define script's directory.
SCRIPT_DIR="${0%/*}"

# Saved data.
FILE_DAT=$SCRIPT_DIR/.saved

if ! [[ -f $FILE_DAT ]]; then
    touch $FILE_DAT
fi

function fread() {
    echo $(cat $FILE_DAT)
}

function fwrite() {
    echo $1 > $FILE_DAT
}

function apply_changes() {
    local mode_dir=$SCRIPT_DIR/$1

    # Start copying.
    for ((i = 0; i < $T_CPU; ++i)); do
        for j in $mode_dir/*; do
            cp $j $CPUFREQ_DIR/policy$i
        done
    done

    fwrite $1
    echo "Applying success! Current mode: $1"
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
    -c|--current)
        echo "Current mode: $(fread)"
        exit 0
    ;;
    -l|--last)
        apply_changes "$(fread)"
    ;;
    *)
        echo "$0: no mode given"
        echo "Usage: $0 [mode]"
        echo "Available modes are:"
        echo " -a|--auto            Auto mode, technically default mode"
        echo " -i|--idle            Idle mode, set the lowest frequency as possible"
        echo " -p|--performance     Performance mode, for developing and specific purpose"
        echo " -s|--save            Save mode, good for browsing and do some tasks"
        echo " -c|--current         Show current mode"
        echo " -l|--last            Apply last used mode"
        exit 1
    ;;
esac