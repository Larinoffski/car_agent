# Contributing

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type**:
  - `feat` — new functionality
  - `fix` — bug fix
  - `docs` — documentation
  - `test` — tests
  - `refactor` — restructuring without behavior change
  - `perf` — performance
  - `build` — build system, Docker
  - `ci` — CI pipeline
  - `chore` — maintenance: configs, dependencies
- **scope** — optional, the affected area: `feat(search):`, `build(docker):`.
- **subject** — English, starts with a lowercase letter, imperative mood ("add", not "added"), no trailing period, up to 72 characters.
- **body** — optional; explains why, not what the diff already shows.
- **footer** — optional, git trailers: `Refs: PROJ-123` links a task, `Closes #42` / `Fixes #42` closes the issue on merge to the default branch.
- **Breaking change** — `!` after the type (`feat(api)!: …`) or a `BREAKING CHANGE: …` footer.

Example:

```
fix(auth): handle expired refresh token

Refresh failed silently and logged the user out.

Refs: PROJ-123
```

## Branches

`<type>/<task-id>-<short-description>`, lowercase except the task id, words separated by hyphens:

```
feat/PROJ-123-cursor-pagination
fix/42-expired-refresh-token
```

`type` is one of the commit types above. Without a task, omit the id: `chore/update-editorconfig`.

## Pull requests

- PRs are squash-merged; the PR title becomes the commit message, so it follows the commit message format.
- Task links (`Closes #42`, `Refs: PROJ-123`) go into the PR description.
- The PR description follows `.github/pull_request_template.md` (GitHub fills it in automatically).
