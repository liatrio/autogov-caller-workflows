# Maintainers

This repository is part of the AutoGov project. Review and merge authority is
held by `@liatrio/tag-autogov` (see [`CODEOWNERS`](CODEOWNERS)), which currently
resolves to a single maintainer — see the review model below.

| Maintainer  | GitHub                                       | Role            |
| ----------- | -------------------------------------------- | --------------- |
| Ian Hundere | [@ianhundere](https://github.com/ianhundere) | Lead maintainer |

## Review model & SLSA source posture

This is a single-maintainer demo repository, so `@liatrio/tag-autogov`
effectively resolves to one person. Genuine two-party review (SLSA Source **L4**)
requires two trusted persons per change and is **not met** — it is aspirational
until the project gains community co-maintainers. The continuously enforced
technical controls earn an honest **SLSA Source L3**. AI-assisted review is used
as *tooling*, not counted as a second review party. As a demo, its build runs
advisory (`allow-failed-vsa: true`), so a self-release's source-review VSA is
recorded for demonstration but does not gate the run.

See the [autogov](https://github.com/liatrio/autogov) repository for the project
overview and contribution guidelines.
