# Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Problem: Permission Denied Error

```bash
chmod +x install.sh
./install.sh
```

#### Problem: Script Not Found

```bash
# Add toolkit to PATH
export PATH="$PATH:$(pwd)"

# Or create symlink
sudo ln -s $(pwd)/rr-toolkit /usr/local/bin/rr-toolkit
```

#### Problem: Dependencies Missing

```bash
# Install required tools
pkg install bash grep sed awk
```

### Runtime Issues

#### Problem: No Data Being Collected

1. Verify Termux storage access:
   ```bash
   termux-setup-storage
   ```

2. Check directory permissions:
   ```bash
   ls -la ~/.config/rr-toolkit/
   ls -la ~/.local/share/rr-toolkit/
   ```

3. Verify configuration:
   ```bash
   cat ~/.config/rr-toolkit/config.conf
   ```

#### Problem: High Memory Usage

1. Check processes:
   ```bash
   rr-toolkit --memory-usage
   ```

2. Clear cache:
   ```bash
   rr-toolkit --clean
   ```

3. Reduce monitoring interval

#### Problem: Battery Draining Quickly

1. Check battery stats:
   ```bash
   rr-toolkit --battery-stats
   ```

2. Enable battery saver:
   ```bash
   rr-toolkit --battery-saver
   ```

3. Check running apps:
   ```bash
   rr-toolkit --memory-usage
   ```

#### Problem: Device Overheating

1. Monitor temperature:
   ```bash
   rr-toolkit --thermal-stats
   ```

2. Stop intensive tasks

3. Use battery saver profile:
   ```bash
   rr-toolkit --profile battery-saver
   ```

#### Problem: Monitoring Not Working

1. Check if script is running:
   ```bash
   ps aux | grep rr-toolkit
   ```

2. Try manual monitoring:
   ```bash
   rr-toolkit --monitor --interval 5
   ```

3. Check logs:
   ```bash
   tail -f ~/.local/share/rr-toolkit/logs/toolkit.log
   ```

### Performance Issues

#### Problem: Slow Performance

1. Check system resources:
   ```bash
   rr-toolkit --system-info
   ```

2. Kill background apps

3. Use gaming profile:
   ```bash
   rr-toolkit --profile gaming
   ```

#### Problem: Laggy Interface

1. Disable animations in profile
2. Reduce monitoring interval
3. Close unused applications

### Configuration Issues

#### Problem: Configuration Not Loading

1. Check config file exists:
   ```bash
   cat ~/.config/rr-toolkit/config.conf
   ```

2. Reset to defaults:
   ```bash
   cp config.conf ~/.config/rr-toolkit/config.conf
   ```

#### Problem: Invalid Profile

1. Check profile file:
   ```bash
   ls ~/.config/rr-toolkit/profiles/
   ```

2. Use default profile:
   ```bash
   rr-toolkit --profile balanced
   ```

### Data Issues

#### Problem: Old Data Not Cleaning Up

1. Manual cleanup:
   ```bash
   rm -rf ~/.local/share/rr-toolkit/logs/*.log.old
   ```

2. Configure retention:
   ```bash
   # Edit config.conf
   LOG_RETENTION_DAYS=30
   ```

#### Problem: Cannot Export Data

1. Check storage space:
   ```bash
   df -h
   ```

2. Check write permissions:
   ```bash
   touch ~/test.txt && rm ~/test.txt
   ```

### Debugging

#### Enable Debug Mode

```bash
rr-toolkit --debug
```

#### Check System Logs

```bash
tail -f ~/.local/share/rr-toolkit/logs/toolkit.log
```

#### Verify Installation

```bash
# Check directories
ls -la ~/.

# Check scripts
ls -la tools/
ls -la lib/
ls -la profiles/

# Run help
rr-toolkit --help
```

## Getting More Help

1. **GitHub Issues**: Report bugs on GitHub
2. **Documentation**: Check docs/ directory
3. **Logs**: Always check logs for errors
4. **Community**: Ask for help in GitHub Discussions

## FAQ

**Q: Will the toolkit break my device?**
A: No, it only reads system information and performs safe optimizations.

**Q: Can I use it on rooted devices?**
A: Yes, and you get additional features with root access.

**Q: Does it work on all Android versions?**
A: Yes, API level 21+ recommended.

**Q: Is it safe to run continuously?**
A: Yes, it's designed for continuous monitoring.
