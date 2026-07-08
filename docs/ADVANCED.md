# Advanced Usage Guide

## Introduction

This guide covers advanced features and customization options for the RR-Performance-Toolkit.

## Custom Performance Profiles

### Creating a Custom Profile

1. Create a new profile file in `~/.config/rr-toolkit/profiles/`:

```bash
cat > ~/.config/rr-toolkit/profiles/custom.profile << 'EOF'
#!/bin/bash

echo "Loading custom profile..."

# CPU settings
CPU_GOVERNOR="performance"
CPU_MIN_FREQ=600000
CPU_MAX_FREQ=2000000

# GPU settings
GPU_MODE="balanced"

# Memory settings
MEMORY_CACHE_TRIM=150
SWAPPINESS=40

echo "Custom profile loaded"
EOF
```

2. Load your profile:

```bash
rr-toolkit --profile custom
```

## Configuration File Customization

Edit `~/.config/rr-toolkit/config.conf` to customize:

- Monitoring intervals
- Battery alerts
- Thermal thresholds
- Logging behavior
- Output formats

## Advanced Monitoring

### Continuous Monitoring with Logging

```bash
rr-toolkit --monitor --log-data --interval 2
```

### Custom Data Export

```bash
rr-toolkit --export --format json --from 2024-01-01 --to 2024-01-31
```

## Performance Tuning

### CPU Governor Selection

- `performance`: Maximum CPU frequency (highest performance, battery drain)
- `powersave`: Minimum CPU frequency (battery efficient, lower performance)
- `schedutil`: Scheduler-based scaling (balanced approach)
- `interactive`: Performance-oriented scaling

### GPU Modes

- `max`: Maximum GPU frequency (best graphics performance)
- `balanced`: Dynamic GPU scaling
- `min`: Minimum GPU frequency (maximum battery life)

## Troubleshooting Advanced Issues

### Enable Debug Mode

```bash
rr-toolkit --debug
```

### Check Detailed Logs

```bash
tail -f ~/.local/share/rr-toolkit/logs/toolkit.log
```

### Memory Leak Detection

Monitor a specific application:

```bash
rr-toolkit --app-profile com.example.app
```

## Performance Benchmarking

### Generate Benchmark Report

```bash
rr-toolkit --report benchmark.txt
```

### Compare Performance

Run multiple profiles and compare results:

```bash
rr-toolkit --profile gaming --report gaming.txt
rr-toolkit --profile battery-saver --report battery.txt
```

## Integration with Other Tools

### Export to CSV

```bash
rr-toolkit --export --format csv --output performance.csv
```

### Pipeline with Other Commands

```bash
rr-toolkit --monitor | grep "CPU Usage"
```

## Tips and Tricks

1. **Create aliases** for frequent commands:
   ```bash
   alias monitor-gaming='rr-toolkit --profile gaming --monitor'
   ```

2. **Schedule profiles** with cron:
   ```bash
   0 9 * * * rr-toolkit --profile productivity
   0 18 * * * rr-toolkit --profile balanced
   ```

3. **Automated reports** via cron:
   ```bash
   0 0 * * 0 rr-toolkit --report ~/reports/weekly-$(date +\%Y-\%m-\%d).txt
   ```

## Best Practices

1. **Regular monitoring** to identify issues early
2. **Profile-based optimization** for different use cases
3. **Regular log review** to understand device behavior
4. **Scheduled optimization** during off-peak hours
5. **Data backup** before major changes

## Support and Issues

For advanced troubleshooting:
- Check logs: `~/.local/share/rr-toolkit/logs/toolkit.log`
- Enable debug: `rr-toolkit --debug`
- Report issues on GitHub
