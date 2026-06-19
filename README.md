# Caller Workflows using GitHub Artifact Attestations

This repository is a working example of how to consume the reusable
automated governance workflows from
[liatrio/autogov-workflows](https://github.com/liatrio/autogov-workflows).
It builds a small demo app (a container image and a couple of blobs) and runs
it through the reusable build, attest, and verify workflows so you can see the
end-to-end attestation flow and adapt it to your own repositories.

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
  failure alerts. Without it the alert step will run but the post will fail
  silently; the rest of the pipeline is unaffected.
- **Workflow permissions** — the caller workflows request `id-token: write`,
  `attestations: write`, `packages: write`, and `contents: write`. Ensure
  Actions is enabled and that your org/repo allows these permissions.

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
