#!/bin/bash

# Configuration
DEVICE_ID="${1:-A142}"
LOG_DIR="logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/flutter_${DEVICE_ID}_${TIMESTAMP}.log"
LATEST_LOG="${LOG_DIR}/flutter_${DEVICE_ID}_latest.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Symlink latest log for easy monitoring
rm -f "$LATEST_LOG"
ln -s "flutter_${DEVICE_ID}_${TIMESTAMP}.log" "$LATEST_LOG"

echo "=================================================="
echo " Starting Flutter app on device: ${DEVICE_ID}"
echo " Log file: ${LOG_FILE}"
echo " Latest log symlink: ${LATEST_LOG}"
echo "=================================================="
echo " To monitor logs in parallel in another terminal, run:"
echo "   tail -f ${LATEST_LOG}"
echo "=================================================="
echo ""

# Run flutter app and stream stdout & stderr to both terminal and log file
flutter run -d "$DEVICE_ID" 2>&1 | tee "$LOG_FILE"
