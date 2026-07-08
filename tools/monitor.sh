#!/bin/bash

################################################################################
# System Monitor Tool
# Real-time monitoring of CPU, RAM, GPU, and battery
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

# Source common functions
[ -f "${LIB_DIR}/common.sh" ] && source "${LIB_DIR}/common.sh"
[ -f "${LIB_DIR}/logger.sh" ] && source "${LIB_DIR}/logger.sh"

get_cpu_usage() {
    # Get CPU usage percentage
    if [ -f /proc/stat ]; then
        awk '/^cpu / {print int($2+$3+$4+$6+$7+$8) / int($2+$3+$4+$5+$6+$7+$8) * 100}' /proc/stat
    else
        echo "N/A"
    fi
}

get_memory_info() {
    # Get memory usage
    if [ -f /proc/meminfo ]; then
        awk '/MemTotal:/ {total=$2} /MemAvailable:/ {avail=$2} END {used=total-avail; percent=int(used/total*100); print used","total","percent}' /proc/meminfo
    else
        echo "N/A,N/A,N/A"
    fi
}

get_battery_level() {
    # Get battery percentage
    if [ -f /sys/class/power_supply/battery/capacity ]; then
        cat /sys/class/power_supply/battery/capacity
    elif [ -f /sys/class/power_supply/BatteryPS/capacity ]; then
        cat /sys/class/power_supply/BatteryPS/capacity
    else
        echo "N/A"
    fi
}

get_temperature() {
    # Get device temperature
    if [ -d /sys/class/thermal ]; then
        for zone in /sys/class/thermal/thermal_zone*/temp; do
            if [ -f "$zone" ]; then
                local temp=$(cat "$zone")
                echo "$((temp/1000))°C"
                return 0
            fi
        done
    fi
    echo "N/A"
}

show_system_info() {
    echo "========================================"
    echo "System Information"
    echo "========================================"
    
    echo "Device: $(getprop ro.product.model 2>/dev/null || echo 'Unknown')"
    echo "Android Version: $(getprop ro.build.version.release 2>/dev/null || echo 'Unknown')"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    
    echo ""
    echo "========================================"
    echo "Performance Metrics"
    echo "========================================"
    
    echo "CPU Usage: $(get_cpu_usage)%"
    
    local mem_info=$(get_memory_info)
    IFS=',' read -r used total percent <<< "$mem_info"
    echo "Memory: ${used}KB / ${total}KB (${percent}%)"
    
    echo "Battery: $(get_battery_level)%"
    echo "Temperature: $(get_temperature)"
    echo ""
}

show_cpu_usage() {
    echo "CPU Usage: $(get_cpu_usage)%"
}

start_monitor() {
    local interval=${1:-5}
    echo "Starting monitor (interval: ${interval}s, press Ctrl+C to stop)"
    echo ""
    
    while true; do
        clear
        echo "RR-Performance-Toolkit Monitor"
        echo "$(date '+%Y-%m-%d %H:%M:%S')"
        echo "========================================"
        
        echo "CPU Usage: $(get_cpu_usage)%"
        
        local mem_info=$(get_memory_info)
        IFS=',' read -r used total percent <<< "$mem_info"
        echo "Memory: ${used}KB / ${total}KB (${percent}%)"
        
        echo "Battery: $(get_battery_level)%"
        echo "Temperature: $(get_temperature)"
        echo "========================================"
        echo "Updating in ${interval}s... (Ctrl+C to stop)"
        
        sleep "${interval}"
    done
}

run_optimization() {
    echo "Running optimization routine..."
    echo "- Clearing cache"
    rm -rf /data/system/package_cache/* 2>/dev/null || true
    echo "- Optimization complete"
}

main() {
    case "${1}" in
        --system-info)
            show_system_info
            ;;
        --cpu)
            show_cpu_usage
            ;;
        --monitor)
            local interval=${3:-5}
            start_monitor "${interval}"
            ;;
        --optimize)
            run_optimization
            ;;
        *)
            show_system_info
            ;;
    esac
}

main "$@"
