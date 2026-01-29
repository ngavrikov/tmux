
#!/bin/sh
set -eu

BASHRC="$HOME/.bashrc"

MARKER_BEGIN="# >>> mc-cd-wrapper >>>"
MARKER_END="# <<< mc-cd-wrapper <<<"

# Check if already installed
if [ -f "$BASHRC" ] && grep -q "$MARKER_BEGIN" "$BASHRC"; then
    echo "mc cd wrapper already installed in ~/.bashrc"
    exit 0
fi

cat >> "$BASHRC" <<'EOF'

# >>> mc-cd-wrapper >>>
mc() {
    mc_cwd_file="$(mktemp)"

    command mc -P "$mc_cwd_file" "$@"

    if [ -f "$mc_cwd_file" ]; then
        new_dir="$(cat "$mc_cwd_file")"
        rm -f "$mc_cwd_file"

        if [ -n "$new_dir" ] && [ -d "$new_dir" ]; then
            cd "$new_dir" || return
        fi
    fi
}
# <<< mc-cd-wrapper <<<
EOF

echo "mc cd wrapper installed. Reload your shell or run:"
echo "  . ~/.bashrc"
