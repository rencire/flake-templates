---
name: vcs
description: Use for version-control work in Git or Jujutsu repos, especially when translating between them, choosing the right commit/push workflow, or remembering the common commands.
---

# VCS

Use this skill for everyday version-control tasks in Git or Jujutsu.

## Choose The Tool

- Use `git` when the repo is managed directly with Git.
- Use `jj` when the repo is managed with Jujutsu.
- If the repo uses Jujutsu on top of Git, do local history work with `jj` and publish with `jj git push` or `git push` when the Git view is already exported and current.

## Common Git Workflows

- Inspect: `git status`, `git diff`, `git log --oneline --graph --decorate --all`
- Start work: `git switch -c <branch>`
- Commit: `git add <paths>`, `git commit -m "<message>"`
- Amend: `git commit --amend`
- Move or rename a branch: `git branch -m <old> <new>`
- Merge: `git merge <branch>`
- Rebase: `git rebase <upstream>`
- Publish: `git push`, `git push -u origin <branch>`

## Common Jujutsu Workflows

- Inspect: `jj st`, `jj diff`, `jj log`
- Create a change: edit files, then `jj commit -m "<message>"`
- Update the bookmark to the commit you just made: `jj bookmark set <bookmark> -r @-`
- Equivalent bookmark move: `jj bookmark move <bookmark> -t @-`
- List bookmarks: `jj bookmark list`
- Repoint a bookmark manually: `jj bookmark set <bookmark> -r <revision>`
- Rebase or reshape history: `jj rebase`, `jj new`, `jj squash`, `jj split`
- Export to the underlying Git repo: `jj git export`
- Publish: `jj git push --bookmark <bookmark>` or `jj git push --all`
- Sync from Git: `jj git fetch`, `jj git import`

## Practical JJ Pattern

1. Edit files.
2. Run `jj commit -m "<message>"`.
3. Move the bookmark to the commit you just made with `jj bookmark set <bookmark> -r @-`.
4. Push with `jj git push --bookmark <bookmark>`.
5. If you need to use raw `git push`, run `jj git export` first.

## Guardrails

- Do not assume Git branches and Jujutsu bookmarks are interchangeable.
- If you rewrite history in `jj`, verify the bookmark still points at the intended commit before pushing.
- Prefer one tool as the source of truth for the current operation; do not mix `git` staging and `jj` history edits unless the repo workflow already does that.
