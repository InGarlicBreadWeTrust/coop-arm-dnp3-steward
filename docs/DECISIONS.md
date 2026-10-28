# Fork Decisions & Known Limitations (DNP3 co-op stewardship)

> DRAFT for user confirmation. These are the best-judgment defaults to unblock
> autonomous work; the user is expected to confirm or override on return.
> Nothing here has been pushed to GitHub. No repo has been created.

## 1. Fork base
**Recommendation: fork the current `osensa/opendnp3` (Apache-2.0, actively
maintained, x64 CI), not `dnp3/opendnp3` (archived 2022) — but layer a
co-op-specific packaging/distribution project *on top of* rather than into the
tree.**

Rationale:
- `dnp3/opendnp3` is archived by design; a co-op building on a dead tree has no
  upstream to sync.
- `stepfunc/dnp3` is NOASSERTION — never fork.
- `osensa/opendnp3` is the only *permissive* actively-maintained fork; it has the
  x64 CI this project extends to ARM64. Forking it keeps the license clean and
  the upstream live.
- Risk: osensa is a solo maintainer. Mitigation: keep the co-op work in its own
  packaging/CI repo that *consumes* osensa/opendnp3, so a co-op isn't a single
  point of failure on one fork.

Decision: **osensa/opendnp3 as the build source; co-op stewardship layer is a
standalone packaging+CI+docs repo that consumes it** (this is what the committed
tree currently reflects — a full opendnp3 checkout with a co-op layer; if the
user prefers a *source fork of osensa* instead, switch `git remote` and drop the
nested copy).

## 2. Repo name / namespace
**Recommendation: `coop-dnp3-steward` (or the user's org namespace) — a packaging,
CI, hardening, and docs repo — NOT a source distribution of opendnp3 itself.**

Rationale: a repo that *contains* a full opendnp3 source tree (1600+ files)
duplicates a licensed project and invites confusion. Cleaner to be a
"companion" repo: toolchain + CI + Docker + patches + legal/privacy, that builds
osensa/opendnp3 on ARM64. If the user wants the full-tree form, keep it; otherwise
convert to a companion repo pulling opendnp3 as a submodule / release tarball.

Decision: **pending user confirmation on name + full-tree vs companion form.**

## 3. CLA
**Recommendation: Developer Certificate of Origin (DCO), as drafted.**

Rationale: for a solo + few-contributors co-op project, a DCO is low-overhead,
proven (Linux/Kubernetes model), and Apache-2.0-compatible. The Apache Foundation
CLA is heavier and implies Apache Foundation governance this project doesn't have.
Keep the DCO unless the project joins the Apache Incubator.

Decision: **DCO, as drafted — pending user confirmation.**

## Known limitations (honest, not blockers for co-op use)
- **aarch64 TLS cross-build NOT proven.** The rootless host's apt serves `amd64`
  only and cannot add `arm64` foreign packages (needs `root dpkg
  --add-architecture arm64`), so a cross OpenSSL isn't available. Most rural co-ops
  do **not** enable DNP3 TLS (it is an optional layer); the non-TLS ARM64 build +
  QEMU execution *is* proven. When a real ARM64 target or a Debian arm64 runner is
  available, `apt-get install libssl-dev` (arm64) + `-DDNP3_TLS=ON` closes this.
- **Conformance + fuzz tests not run.** Two genuine upstream v3.1.2 bugs
  (`fix-countingsoe-stadexcept.md`, `fix-catch-minski.md`) block the test link;
  document-and-forward upstream before enabling. The demo/linkproof layer *is* run.
- **Push to GitHub: not done.** No repo created, no credentials used. The user
  confirms name/namespace (decision 2), then this goes on the `github` skill path
  to create + push + branch-protect.

## Legal posture (unchanged from docs/LEGAL.md)
Apache-2.0 throughout; DNP3/IEEE-1815 SEP risk LOW-to-moderate and covered by the
Apache patent grant for redistribution; a one-time FTO opinion (~$1,500) is the
only recommended gate before any commercial distribution. No PII, no telemetry, no
call-home anywhere.
