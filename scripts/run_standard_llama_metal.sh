#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="$ROOT_DIR/results"
mkdir -p "$RESULTS_DIR"

MODEL="${MODEL:-$HOME/.lmstudio/models/unsloth/Qwen3.5-35B-A3B-GGUF/Qwen3.5-35B-A3B-Q5_K_S.gguf}"
LLAMA_BENCH="${LLAMA_BENCH:-$HOME/src/llama.cpp/build-metal/bin/llama-bench}"
OUT="$RESULTS_DIR/standard-llama-metal.jsonl"
ERR="$RESULTS_DIR/standard-llama-metal.stderr.log"

if [[ ! -x "$LLAMA_BENCH" ]]; then
  echo "LLAMA_BENCH is not executable: $LLAMA_BENCH" >&2
  exit 1
fi

if [[ ! -f "$MODEL" ]]; then
  echo "MODEL does not exist: $MODEL" >&2
  exit 1
fi

"$LLAMA_BENCH" \
  -m "$MODEL" \
  -o jsonl \
  -r 3 \
  -ngl 999 \
  -fa on \
  -ctk f16 \
  -ctv f16 \
  -p 512,2048 \
  -n 128 \
  -pg 512,128 \
  -pg 2048,128 \
  > "$OUT" 2> "$ERR"

echo "Wrote $OUT"
echo "Wrote $ERR"
