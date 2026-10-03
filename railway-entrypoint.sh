#!/bin/sh
# Railway mounts volumes root-owned; give /data to the node user (uid 1000)
# and drop privileges before starting Mailflare.
set -e
DATA_DIR="${DATA_DIR:-/data}"
mkdir -p "$DATA_DIR/blobs"
chown -R 1000:1000 "$DATA_DIR"
exec setpriv --reuid=1000 --regid=1000 --clear-groups "$@"
