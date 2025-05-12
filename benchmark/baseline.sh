#!/bin/bash

# === Parameter Settings ===
WORKLOAD_DURATION=20      # stress-ng runtime (seconds)
WORKLOAD_THREADS=10         # Number of stress-ng threads
WORKLOAD_MEMORY=48%        # Memory usage per thread


# Start stress-ng workload
echo "[INFO] Starting stress-ng workload..."
sudo sh -c 'echo 0 > /proc/sys/kernel/numa_balancing' 2>/dev/null || true
for i in {1..10}
do
	sudo numactl --cpunodebind=0 --membind=0 stress-ng --vm $WORKLOAD_THREADS --vm-bytes $WORKLOAD_MEMORY --vm-populate --oom-avoid --vm-keep --timeout ${WORKLOAD_DURATION}s &
	sleep 2
	STRESS_PID=$!
	echo "[INFO] stress-ng started with PID $STRESS_PID"
	sleep 8
	echo "[INFO] Attaching stress-ng to perf..."
	sudo /proj/rasl-PG0/seokjoo3/linux-6.11.9/tools/perf/perf stat -e cycles:u,cycles:k -p $STRESS_PID,$(pidof kdamond.0) -o perf_stat_$i.txt &
	SAMPLER_PID=$!

	# Wait for stress-ng workload to complete
	echo "[INFO] Waiting for workload to finish (~${WORKLOAD_DURATION}s)..."
	wait $STRESS_PID
	
	kill -SIGINT $SAMPLER_PID
	wait $SAMPLER_PID 2>/dev/null
	echo "[INFO] stress-n workload finished."
done
sudo sh -c 'echo 1 > /proc/sys/kernel/numa_balancing' 2>/dev/null || true

echo "[DONE] Full stress-ng Benchmark Completed."
