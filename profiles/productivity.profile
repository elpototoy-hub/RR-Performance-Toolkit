#!/bin/bash

# RR-Performance-Toolkit - Productivity Profile
# Balanced for productivity and multitasking

echo "Loading productivity profile..."

# CPU settings
CPU_GOVERNOR="interactive"
CPU_MIN_FREQ=400000
CPU_MAX_FREQ=2200000

# GPU settings
GPU_MODE="balanced"

# Memory settings
MEMORY_CACHE_TRIM=150
SWAPPINESS=50

# Background process limits - More apps allowed
BACKGROUND_LIMIT=8

# Animation settings
DISABLE_ANIMATIONS=false

# Screen settings
SCREEN_BRIGHTNESS=70
SCREEN_TIMEOUT=600

echo "Productivity profile loaded successfully"
