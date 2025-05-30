#!/bin/zsh
# download_and_prepare_data.sh
# Usage: ./download_and_prepare_data.sh <zip_url>

set -e

if [ $# -ne 1 ]; then
  echo "Usage: $0 <zip_url>"
  exit 1
fi

ZIP_URL="$1"
ZIP_NAME="$(basename "$ZIP_URL")"
DATA_DIR="../data"

# Download the zip file
curl -L -o "$ZIP_NAME" "$ZIP_URL"

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Unzip to a temporary directory
TMP_DIR=$(mktemp -d)
unzip -q "$ZIP_NAME" -d "$TMP_DIR"

# Copy all files to the /data directory at the repo root
cp -R "$TMP_DIR"/* "$DATA_DIR"/

# Clean up
echo "Cleaning up..."
rm -rf "$TMP_DIR" "$ZIP_NAME"

echo "Data files copied to $DATA_DIR"
