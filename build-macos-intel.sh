#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir="$project_dir/.build/upstream"
upstream_ref=dsh-v0.2.3-alpha.2

if [ "$(uname -s)" != Darwin ]; then
    echo "The Intel DMG must be built on macOS." >&2
    exit 1
fi

if [ ! -d "$source_dir/.git" ]; then
    git clone --depth 1 --branch "$upstream_ref" \
        https://github.com/deepseek-ai/deepseek-harness.git "$source_dir"
fi

cd "$source_dir"
pnpm install --frozen-lockfile
pnpm run package:desktop:mac:x64:unsigned "$@"
