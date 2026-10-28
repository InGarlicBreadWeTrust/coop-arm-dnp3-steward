# Contributing

The co-op-facing openDNP3 stewardship fork is for rural electric co-ops and
small utilities that run DNP3 (IEEE-1815) protocol on the field gateways they
have. This is not the upstream `dnp3/opendnp3` repository - it deliberately
tracks the archived v3.1.2 reference and adds an ARM64 cross-build.

## How to contribute

1. Fork the repo.
2. `git pull` from upstream `main` to keep up with opendnp3 security fixes.
3. Make changes on a feature branch.
4. Add a unit test if the change touches protocol / channel behaviour.
5. Sign the Developer Certificate of Origin (`cla/CLA.md`).
6. Open a PR.

We accept:
- ARM64 / RPi / Orange Pi device packaging
- CI hardening for aarch64 cross-compile
- DNP3 conformance test additions
- co-op runbooks, docs, and runbooks
- bug fixes with test regression additions

We do NOT accept:
- changes to the `cpp/` C++ source that would require replying upstream to
  `dnp3/opendnp3` first (this fork is a packaging layer, not a source fork)
- any change that would add PII, telemetry, or a network call-home
- any offensive ICS tooling

## Commit style

Short imperative titles, max ~72 chars, with `Signed-off-by` trailer.
For example:

```
arm64: add cross-build toolchain for co-op SCADA gateways

Signed-off-by: Jane <jane@@example.coop>
```
