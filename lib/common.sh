#!/bin/bash

################################################################################
# Common Functions Library
# Shared utilities for all toolkit scripts
################################################################################

# Utility functions

print_info() {
    echo "[INFO] $@"
}

print_error() {
    echo "[ERROR] $@" >&2
}

print_warning() {
    echo "[WARNING] $@"
}

print_success() {
    echo "[SUCCESS] $@"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Get current timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Get current date
get_date() {
    date '+%Y-%m-%d'
}

# Format bytes to human readable
format_bytes() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    elif [ "$bytes" -lt 1073741824 ]; then
        echo "$((bytes / 1048576))MB"
    else
        echo "$((bytes / 1073741824))GB"
    fi
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Retry function
retry() {
    local n=1
    local max=5
    local delay=1
    while true; do
        "$@" && break || {
            if [ $n -lt $max ]; then
                ((n++))
                sleep $delay
            else
                return 1
            fi
        }
    done
}
