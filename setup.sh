echo -n "Enable Performance Mode: "
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Reference: https://serverfault.com/a/967597
echo -n "Disabling Hyperthreading: "
echo off | sudo tee /sys/devices/system/cpu/smt/control

# Reference: https://askubuntu.com/a/620114
echo -n "Disabling Turbo Boost (disable=1): "
echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

echo -n "Disabling NUMA Balancing: "
echo "0" | sudo tee /proc/sys/kernel/numa_balancing
