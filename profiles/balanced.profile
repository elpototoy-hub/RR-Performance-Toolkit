#!/bin/bash

# RR-Performance-Toolkit - Balanced Profile
# Balanced performance and battery life

echo "Loading balanced profile..."

# CPU settings
CPU_GOVERNOR="schedutil"
CPU_MIN_FREQ=300000
CPU_MAX_FREQ=2000000

# GPU settings
GPU_MODE="balanced"

# Memory settings
MEMORY_CACHE_TRIM=100
SWAPPINESS=60

# Background process limits
BACKGROUND_LIMIT=5

# Animation settings
DISABLE_ANIMATIONS=false

# Screen settings
SCREEN_BRIGHTNESS=80
SCREEN_TIMEOUT=300

echo "Balanced profile loaded successfully"
