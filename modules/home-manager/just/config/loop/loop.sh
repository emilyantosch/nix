#!/bin/sh
# The loop of `just -g loop`: works through a directory of tickets while nobody watches, each
# ticket in a Claude Code session of its own, so each starts with a clear context; then powers
# the machine off. It works in any Git repository, on Linux and on macOS.
#
#     sh loop.sh <ticket directory> [yes|no]
#
# The directory is taken from where the loop is called; the sessions run at the top of its
# repository. A ticket is a .md file in the directory (result.md aside), taken in the order of
# the file names; one whose `**Status:**` line says `done` is passed over, so a loop broken off
# is taken up again by starting it once more. Each ticket's session is `/implement <ticket>`,
# the implement skill, with prompt.md appended to its system prompt. Each session is Fable 5.2
# on high effort, in auto mode (it waits for no permission prompt; what the mode's own check
# takes for too risky is refused instead) and asks nothing: what it would have asked, it
# answers itself as prompt.md says and writes into result.md beside the tickets, together with
# what it did. The loop itself adds a line there for a session that failed or left files it did
# not commit.
#
# After the last ticket, a session of the retro skill (`/retro`, with retro.md appended) looks
# back over the whole loop, its logs, result.md and commits, and appends its suggestions to
# result.md. It changes nothing else; it is left out when no ticket was worked on.
#
# Started on main or master, the loop first makes a branch of its own, loop/<directory>-<time>;
# on any other branch it commits there. Each session's log, as stream-json, is kept outside the
# repository, so that no project has to ignore it: ~/.local/state/just-loop/<repository>/<time>/.
# The machine is kept from sleeping while the loop runs (systemd-inhibit, or caffeinate on
# macOS). The second argument, yes by default, says whether to power off at the end; the
# machine is powered off a minute after the last ticket, failed or not, unless the loop is
# stopped in that minute.
set -eu

usage() {
    echo "usage: just -g loop <ticket directory> [poweroff: yes|no]" >&2
    exit 2
}
[ $# -ge 1 ] && [ $# -le 2 ] || usage
poweroff=${2:-yes}
case "$poweroff" in yes | no) ;; *) usage ;; esac
[ -d "$1" ] || { echo "just loop: $1 is no directory" >&2; exit 1; }

# Run again under whatever keeps this machine awake, once
if [ -z "${LOOP_AWAKE:-}" ]; then
    export LOOP_AWAKE=1
    if command -v systemd-inhibit >/dev/null 2>&1; then
        exec systemd-inhibit --what=idle:sleep --who="just loop" \
            --why="Claude Code works through tickets" sh "$0" "$@"
    elif command -v caffeinate >/dev/null 2>&1; then
        exec caffeinate -is sh "$0" "$@"
    fi
fi

here=$(cd "$(dirname "$0")" && pwd)
root=$(git -C "$1" rev-parse --show-toplevel) || {
    echo "just loop: $1 is in no Git repository" >&2
    exit 1
}
dir=$(git -C "$1" rev-parse --show-prefix)
dir=${dir%/}
[ -n "$dir" ] || { echo "just loop: the tickets need a directory of their own, below $root" >&2; exit 1; }
cd "$root"

tickets=$(find "$dir" -maxdepth 1 -type f -name '*.md' ! -name result.md | sort)
[ -n "$tickets" ] || { echo "just loop: $dir holds no tickets (*.md)" >&2; exit 1; }

prompt=$(cat "$here/prompt.md")
retro=$(cat "$here/retro.md")
result="$dir/result.md"
stamp=$(date +%Y-%m-%d-%H%M)
logs="${XDG_STATE_HOME:-$HOME/.local/state}/just-loop/$(basename "$root")/$stamp"
mkdir -p "$logs"

branch=$(git branch --show-current)
case "$branch" in main | master)
    branch="loop/$(printf '%s' "$dir" | sed 's|^docs/||; s|[^A-Za-z0-9._-]|-|g')-$stamp"
    git switch -c "$branch"
    ;;
esac

{
    [ -s "$result" ] && echo
    echo "# The loop of $(date '+%Y-%m-%d %H:%M'), on $branch"
} >>"$result"

# What was left uncommitted before the loop, so that a session is blamed only for what it adds
before=$(git status --porcelain --untracked-files=all | grep -vF "$result" || true)
start=$(git rev-parse HEAD)

# Runs one session: session <log name> <prompt> <appended system prompt>
session() {
    status=0
    claude -p "$2" \
        --append-system-prompt "$3" \
        --model claude-fable-5-2 \
        --effort high \
        --permission-mode auto \
        --disallowedTools AskUserQuestion \
        --output-format stream-json \
        --verbose \
        </dev/null >"$logs/$1.jsonl" 2>&1 || status=$?
    if [ "$status" -ne 0 ]; then
        printf '\n**The loop:** the session of %s ended with exit %s; its log is %s.\n' \
            "$1" "$status" "$logs/$1.jsonl" >>"$result"
    fi
    after=$(git status --porcelain --untracked-files=all | grep -vF "$result" || true)
    if [ "$after" != "$before" ]; then
        printf '\n**The loop:** after %s these were left uncommitted:\n\n```\n%s\n```\n' \
            "$1" "$after" >>"$result"
        before=$after
    fi
}

printf '%s\n' "$tickets" | while IFS= read -r ticket; do
    name=$(basename "$ticket" .md)
    if grep -q '^\*\*Status:\*\* *done' "$ticket"; then
        echo "$(date +%H:%M) $name is done already"
        continue
    fi
    echo "$(date +%H:%M) $name"
    session "$name" "/implement $ticket" "$prompt

The ticket: $ticket
The result file: $result
The branch: $branch
The commit before the ticket: $(git rev-parse HEAD)"
done

if ls "$logs"/*.jsonl >/dev/null 2>&1; then
    echo "$(date +%H:%M) the retrospective"
    before=$(git status --porcelain --untracked-files=all | grep -vF "$result" || true)
    session retro "/retro the sessions of this loop, one log for each ticket in $logs" "$retro

The ticket directory: $dir
The logs: $logs
The result file: $result
The branch: $branch
The commits of the loop: $start..HEAD"
fi

printf '\n**The loop** ended at %s.\n' "$(date +%H:%M)" >>"$result"
echo "$(date +%H:%M) the loop is done: $result"

if [ "$poweroff" = yes ]; then
    echo "Powering off in a minute; Ctrl-C keeps the machine on."
    sleep 60
    if command -v systemctl >/dev/null 2>&1; then
        systemctl poweroff
    else
        osascript -e 'tell application "System Events" to shut down'
    fi
fi
