#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT_DIR/results"
mkdir -p "$RESULTS_DIR"

OUT="$RESULTS_DIR/hardware.txt"

{
  echo "## Date"
  date
  echo

  echo "## macOS"
  sw_vers
  echo

  echo "## Hardware"
  system_profiler SPHardwareDataType
  echo

  echo "## Displays / GPU"
  system_profiler SPDisplaysDataType
  echo

  echo "## CPU / Memory sysctl"
  echo "CPU brand: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || true)"
  echo "Physical CPUs: $(sysctl -n hw.physicalcpu 2>/dev/null || true)"
  echo "Logical CPUs: $(sysctl -n hw.logicalcpu 2>/dev/null || true)"
  echo "Memory bytes: $(sysctl -n hw.memsize 2>/dev/null || true)"
} > "$OUT"

echo "Wrote $OUT"

