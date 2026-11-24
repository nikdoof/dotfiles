# shellcheck shell=bash
# Expose shared agent skills (~/.agents/skills) to Claude Code (~/.claude/skills)

_sync_claude_skills() {
    local src="${HOME}/.agents/skills"
    local dst="${HOME}/.claude/skills"
    local skill name

    [ -d "$src" ] || return 0
    mkdir -p "$dst"

    # Link each skill; leave real directories/files in $dst untouched.
    # find avoids zsh's "no matches found" on an empty glob.
    find "$src" -mindepth 1 -maxdepth 1 ! -name '.*' | while IFS= read -r skill; do
        name="${skill##*/}"
        if [ -L "${dst}/${name}" ] || [ ! -e "${dst}/${name}" ]; then
            ln -sfn "$skill" "${dst}/${name}"
        fi
    done

    # Remove dead symlinks (with -L, -type l only matches broken links)
    find -L "$dst" -mindepth 1 -maxdepth 1 -type l -exec rm -f -- {} +
}

_sync_claude_skills
unset -f _sync_claude_skills
