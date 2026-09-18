#!/usr/bin/env bash
set -euo pipefail

# Idempotent local-development bootstrap for the animeopenings PHP site.
#
# Several files this app include()s are intentionally git-ignored because they
# hold deployment-specific data (easter-egg metadata, an analytics snippet) or
# large media. This script recreates safe local stand-ins when they are missing
# so the site runs end-to-end in a fresh environment. It never overwrites files
# that already exist, so real data is preserved.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# eggs.php: production lists hidden "egg" videos; an empty array is safe locally.
if [ ! -f eggs.php ]; then
  cat > eggs.php <<'PHP'
<?php
// Local development stub for the git-ignored easter-egg metadata file.
// In production this file lists hidden "egg" videos. Empty is safe for dev.
$eggs = array();
PHP
  echo "created eggs.php"
fi

# backend/includes/botnet.html: production analytics/include snippet.
mkdir -p backend/includes
if [ ! -f backend/includes/botnet.html ]; then
  cat > backend/includes/botnet.html <<'HTML'
<!-- Local development stub for the git-ignored analytics/include snippet. -->
HTML
  echo "created backend/includes/botnet.html"
fi

# Sample videos: generate a few small .webm clips that match entries in
# names.php so the homepage, list and detail pages have playable media.
mkdir -p video
SAMPLE_VIDEOS=(
  "Opening1-AccelWorld.webm"
  "Ending1-AccelWorld.webm"
  "Opening1-AldnoahZero.webm"
  "Opening1-AngelBeats.webm"
)
if command -v ffmpeg >/dev/null 2>&1; then
  for name in "${SAMPLE_VIDEOS[@]}"; do
    if [ ! -f "video/$name" ]; then
      ffmpeg -nostdin -loglevel error \
        -f lavfi -i "testsrc=duration=3:size=640x360:rate=24" \
        -f lavfi -i "sine=frequency=440:duration=3" \
        -c:v libvpx-vp9 -b:v 300k -c:a libvorbis -shortest \
        "video/$name" -y
      echo "created sample video/$name"
    fi
  done
else
  echo "ffmpeg not found; skipping sample video generation" >&2
fi

echo "Local development setup complete."
