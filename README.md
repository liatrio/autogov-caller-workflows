# autogov caller workflows — runnable example

[![build image](https://github.com/liatrio/autogov-caller-workflows/actions/workflows/cw-build-image.yaml/badge.svg)](https://github.com/liatrio/autogov-caller-workflows/actions/workflows/cw-build-image.yaml)
[![Release](https://img.shields.io/github/v/release/liatrio/autogov-caller-workflows?sort=semver)](https://github.com/liatrio/autogov-caller-workflows/releases)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

> Part of the [autogov](https://github.com/liatrio/autogov) ecosystem. autogov is a CLI that produces and verifies [SLSA](https://slsa.dev/spec/v1.2/about) supply-chain attestations, evaluates [OPA/Rego](https://www.openpolicyagent.org/docs/policy-language/) policy, and emits a pass/fail Verification Summary Attestation (VSA). This repo is the end-to-end example showing how to wire it up — start with the [autogov CLI](https://github.com/liatrio/autogov) and the [reusable workflows](https://github.com/liatrio/autogov-workflows) it drives.

This repository is a working example of how to consume the reusable
automated governance workflows from
[liatrio/autogov-workflows](https://github.com/liatrio/autogov-workflows).
It builds a small demo app (a container image and a couple of blobs) and runs
it through the reusable build and attest workflows so you can see the
attestation flow and adapt it to your own repositories.

## What this demonstrates

- **`cw-build-image.yaml`** — calls `rw-build-image.yaml` to build the demo
  container image, push it to GHCR, and generate a signed artifact
  attestation.
- **`cw-build-blob.yaml`** — calls `rw-build-blob.yaml` to attest arbitrary
  file blobs (`workflow_dispatch` only by default).
- **`wf-slack-alert.yaml`** — posts a Slack message when one of the build
  workflows fails on `main`.

The demo application itself lives in `app.py` / `requirements.txt` and is
built by the `Dockerfile`, which uses a public Python base image so external
forks can build it without access to a private registry.
Direct execution with `python app.py` and the container both disable Flask's
debugger. This is a demonstration application using Flask's development server.

## Verify the attestations

The workflow produces SLSA build provenance, a CycloneDX SBOM, a vulnerability scan, a Verification Summary Attestation (VSA), and source-review and metadata predicates. The caller sets `allow-failed-vsa: true`: a `FAILED` policy result is recorded and attested but does not block the demo. A successful workflow run therefore does not establish policy compliance; inspect the VSA result. The image is published to GHCR at `ghcr.io/liatrio/autogov-caller-workflows`.

Quick check with the GitHub CLI — confirms the image's attestations are signed by a Liatrio-org workflow via [Sigstore](https://www.sigstore.dev/) (`--owner liatrio` scopes the trusted signer to the org; it does not by itself prove which repo built the image):

```bash
gh attestation verify oci://ghcr.io/liatrio/autogov-caller-workflows:latest --owner liatrio
```

On success you'll see `✓ Verification succeeded!` followed by the verified attestations.

For policy-gated verification — running the OPA/Rego policies in [autogov-policy-library](https://github.com/liatrio/autogov-policy-library) — use the autogov CLI with the full image reference:

```bash
autogov verify attestation \
  --image-digest ghcr.io/liatrio/autogov-caller-workflows@sha256:<digest> \
  --repo liatrio/autogov-caller-workflows \
  --policy-bundle-path ghrel://liatrio/autogov-policy-library \
  --fail-on-policy-error
```

Find the digest with `docker buildx imagetools inspect ghcr.io/liatrio/autogov-caller-workflows:latest`. Pin the trusted signer with `--cert-identity`/`--cert-identity-list` (without it, any valid Sigstore signature is accepted, not just this repo's workflows), and add `--generate-vsa --policy-uri <id> --vsa-output vsa.json` to emit VSA JSON (the CLI requires both `--policy-uri` and `--vsa-output` whenever `--generate-vsa` is set). The CLI does not sign this JSON; the reusable workflow separately creates its signed attestation. See the [autogov verify docs](https://github.com/liatrio/autogov#usage) for the full flag set, offline verification, and the certificate-identity allowlist.

## Prerequisites

- **GHCR access** — the image build pushes to `ghcr.io`. The workflows use the
  job's `GITHUB_TOKEN` with `packages: write`, so no extra credentials are
  needed for pushing to packages in your own repository/org. To pull the
  image afterwards, authenticate to GHCR
  (`docker login ghcr.io`) with a token that has `read:packages`.
- **`SLACK_WEBHOOK` secret** — `wf-slack-alert.yaml` reads
  `secrets.SLACK_WEBHOOK`. Set it under **Settings → Secrets and variables →
  Actions** to an
  [incoming webhook URL](https://api.slack.com/messaging/webhooks) if you want
  failure alerts. Without it the alert step explicitly skips the notification.
  Configured webhooks report HTTP errors by failing the alert step; the build
  workflow's result is unaffected.
- **Workflow permissions** — both build callers request `actions: read`,
  `pull-requests: read`, `id-token: write`, `attestations: write`,
  `artifact-metadata: write`, and `contents: write`. The image caller also
  requests `packages: write`. Ensure Actions is enabled and that your
  org/repo allows these permissions.

## Releases

The reusable image workflow invokes `rw-release.yaml` after build and
verification. Release creation runs on pushes to `main`; pull requests and
manual dispatches do not create releases. AutoGov derives the next version
from commit history, applies `.autogov-release.yaml` to update `ENV VERSION`
in the Dockerfile, and publishes the release with its staged evidence assets.

Protected-branch release writes use the reusable workflow's configured
Octo STS release identity. External adopters must configure their own scope,
identity, and permitted release writer before enabling releases; a default
`GITHUB_TOKEN` does not bypass branch rules. Set `release-image: false` on
the reusable-workflow call while configuring a build-only example. Keep
published release tags and assets immutable.

## Adapting it for your repository

1. Copy the workflows under `.github/workflows/` into your repository.
2. Update the reusable workflow references
   (`uses: liatrio/autogov-workflows/...@<sha>`) and the matching
   `cert-identity:` values to the version you want to pin.
3. Replace the demo `app.py`, `requirements.txt`, and `Dockerfile` with your
   own application, or point `subject-name` / `subject-path` at your real
   build artifacts.
4. Add the `SLACK_WEBHOOK` secret if you want failure notifications, or remove
   `wf-slack-alert.yaml` if you do not.
