# Contributing to autogov caller workflows

This repository is a **runnable example** of how to consume the
[autogov reusable workflows](https://github.com/liatrio/autogov-workflows) — it
is intentionally small. For the project itself, start at the
[flagship repo](https://github.com/liatrio/autogov).

## What belongs here

- Fixes and clarifications to the example: the workflows under
  `.github/workflows/`, the demo `app.py` / `Dockerfile`, or this README.
- Changes that make the example easier to copy into a real repository.

Changes to workflow *behavior* belong in
[autogov-workflows](https://github.com/liatrio/autogov-workflows); policy changes
belong in
[autogov-policy-library](https://github.com/liatrio/autogov-policy-library).

## Contributing process

1. **Open an issue** describing the change.
2. **Create a feature branch** and keep it focused.
3. **Open a pull request** with a clear description and a linked issue. The build
   and attest workflows run on the PR, so confirm they pass.

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`,
`fix:`, `chore:`, `docs:`).

## Code of Conduct

This project follows the
[Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).
See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
