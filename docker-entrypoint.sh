#!/bin/sh
set -eu

# DSH expects a concrete interface address. Docker forwards to the bridge IP.
bind_ip=$(node -e '
  const interfaces = Object.values(require("node:os").networkInterfaces()).flat();
  const address = interfaces.find(entry => entry.family === "IPv4" && !entry.internal);
  if (!address) throw new Error("An IPv4 Docker bridge interface is required");
  process.stdout.write(address.address);
')
exec dsh web --host "$bind_ip" --port 3080 --no-open \
    --public-url "${DSH_PUBLIC_URL:-http://localhost:3080}" \
    --trusted-host "${DSH_TRUSTED_HOST:-localhost:3080}" "$@"
