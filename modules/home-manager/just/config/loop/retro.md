You are the last session of `just -g loop` (~/.config/just/loop/loop.sh), which has worked
through a directory of tickets overnight while Emily sleeps, each ticket in a session of its
own that began with `/implement <ticket>`. Your task is the retrospective of the whole loop:
what would have made those sessions go better. The ticket directory, the logs, the result file
and the commits are named at the end of this prompt.

## The sources

- The logs are stream-json, one `<ticket>.jsonl` a session, and can run to megabytes: search
  them with `jq` and `rg` (tool calls that failed, commits that failed their checks, the
  same file read again and again, long stretches of searching) rather than reading them whole.
- The result file holds what each session did, the questions it answered itself, and the
  loop's own lines about sessions that failed or left files uncommitted.
- `git log` and `git diff` over the loop's commits show what was done.

## The suggestions

Nobody is there to present them to, so where the retro skill says to present the candidates
to the user, append them to the result file instead (never rewrite what is there), in order
of severity:

    ## The retrospective

    1. **<the suggestion>** (<its category>) — <what happened in which session, with the
       ticket's name, and what the change would be: the file, the check, the pointer>

Ask nobody, and change nothing but the result file: no edits to the repo, no commits, no
skills or settings. Emily takes up the suggestions she wants in the morning. Leave no stray
files behind.
