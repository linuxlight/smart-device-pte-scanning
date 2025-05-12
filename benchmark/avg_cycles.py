import re
from collections import defaultdict

def parse_file(filename):
    row_data = defaultdict(int)
    elapsed_time = None

    with open(filename, 'r') as file:
        for line in file:
            # Match cycles lines
            match = re.match(r'^\s+([\d,]+)\s+cycles:([uk])', line)
            if match:
                value = int(match.group(1).replace(',', ''))
                mode = match.group(2)  # 'u' or 'k'
                row_data[mode] += value
            # Match elapsed time
            elapsed_match = re.search(r'([\d.]+)\s+seconds time elapsed', line)
            if elapsed_match:
                elapsed_time = float(elapsed_match.group(1))

    return row_data, elapsed_time

def average_data(filenames):
    total_cycles = defaultdict(int)
    cycle_counts = defaultdict(int)
    total_elapsed = 0
    elapsed_count = 0

    for filename in filenames:
        file_cycles, elapsed = parse_file(filename)

        for mode in ['u', 'k']:   # Ensure consistent keys
            if mode in file_cycles:
                total_cycles[mode] += file_cycles[mode]
                cycle_counts[mode] += 1

        if elapsed is not None:
            total_elapsed += elapsed
            elapsed_count += 1

    avg_cycles = {
        key: total_cycles[key] / cycle_counts[key]
        for key in total_cycles
    }

    avg_elapsed = total_elapsed / elapsed_count if elapsed_count > 0 else None
    return avg_cycles, avg_elapsed

# Example usage
if __name__ == "__main__":
    filenames = [f"perf_stat_{i}.txt" for i in range(1, 11)]  # Adjust to your filenames
    avg_cycles, avg_elapsed = average_data(filenames)

    for mode in sorted(avg_cycles):
        mode_str = "user" if mode == 'u' else "kernel"
        print(f"{mode_str} average cycles: {avg_cycles[mode]:,.0f}")

    if avg_elapsed is not None:
        print(f"\nAverage elapsed time: {avg_elapsed:.3f} seconds")

