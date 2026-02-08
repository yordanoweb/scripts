#!/usr/bin/env sh
# If we're in fish, re-exec under fish; otherwise stay in sh/bash
if [ -n "$FISH_VERSION" ]; then
    exec fish "$0" $argv
fi

# --------------------
# POSIX / Bash section
# --------------------

set -eu

read X Y W H <<EOF
$(slop -f "%x %y %w %h")
EOF

# round down to even
X=$((X & ~1))
Y=$((Y & ~1))
W=$((W & ~1))
H=$((H & ~1))

timestamp=$(date +%F_%H-%M-%S)

exec ffmpeg \
  -f x11grab \
  -video_size "${W}x${H}" \
  -framerate 30 \
  -grab_x "$X" \
  -grab_y "$Y" \
  -i :0 \
  -c:v libx264 \
  -preset ultrafast \
  -crf 18 \
  -pix_fmt yuv420p \
  -y "$HOME/tmp/output_${timestamp}.mp4"

# --------------------
# Fish section
# --------------------

read X Y W H (slop -f "%x %y %w %h"); or exit 1

# round down to even
set X (math "$X & ~1")
set Y (math "$Y & ~1")
set W (math "$W & ~1")
set H (math "$H & ~1")

set timestamp (date "+%F_%H-%M-%S")

exec ffmpeg \
    -f x11grab \
    -video_size {$W}x{$H} \
    -framerate 30 \
    -grab_x $X \
    -grab_y $Y \
    -i :0 \
    -c:v libx264 \
    -preset ultrafast \
    -crf 18 \
    -pix_fmt yuv420p \
    -y "$HOME/tmp/output_$timestamp.mp4"
