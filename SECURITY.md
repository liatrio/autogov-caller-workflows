# Security Policy

## Reporting a Vulnerability

We take the security of `autogov-caller-workflows` seriously. If you discover a
security vulnerability, please report it **privately** — do not open a public
issue.

**Preferred:** use GitHub's [private vulnerability reporting](https://github.com/liatrio/autogov-caller-workflows/security/advisories/new)
("Report a vulnerability" under the repository's **Security** tab). This keeps
the report confidential until a fix is available and a coordinated disclosure
can be made.

Please include, where possible:

- A description of the vulnerability and its impact
- Steps to reproduce (proof-of-concept, affected version/commit)
- Any known mitigations or workarounds

## What to Expect

- **Acknowledgement** of your report as soon as the maintainers are able to triage it.
- An assessment of the report and, if confirmed, a plan and timeline for a fix.
- Coordinated disclosure: we will work with you on timing and credit you in the
  advisory unless you prefer to remain anonymous.

## Supported Versions

This repository is a demonstration of the reusable automated governance
workflows and is under active development. Security fixes are applied to the
latest released version. Please use the most recent release before reporting,
in case the issue is already addressed.

## Scope

This policy covers the example caller workflows and demo application in this
repository. The reusable workflows themselves live in
[liatrio/autogov-workflows](https://github.com/liatrio/autogov-workflows);
report issues in those workflows there. Vulnerabilities in third-party
dependencies should be reported upstream; if a dependency advisory affects this
repository, we track and remediate it via dependency updates.
