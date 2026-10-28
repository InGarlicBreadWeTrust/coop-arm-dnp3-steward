# Legal note for the co-op-facing fork of opendnp3 (DNP3 / IEEE-1815)

This repository provides a co-op / rural-utility focused build and packaging layer
on the **opendnp3** software. It is designed so that a cooperative or small
utility can build and run a DNP3 (IEEE-1815) master / outstation on ARM64
hardware common to co-op SCADA edges **without legal risk** ("the goal is to
help, not get sued").

## License

The entire openDNP3 codebase (including any changes in `cpp/`) is licensed under
**Apache-2.0** (see `LICENSE`). Apache-2.0:

- grants a royalty-free patent licence to all contributors to users;
- requires preserving the `NOTICE` file and copyright headers (already in place);
- permits commercial use, modification, and distribution.

All new co-op-authored files (this `docs/` tree, `cmake/arm64-toolchain.cmake`,
`.github/workflows/ci-cross-arm64.yml`, `Dockerfile`, `patches/`,
`cla/CLA.md`, `CONTRIBUTING.md`) are likewise Apache-2.0.

## DNP3 / IEEE-1815 freedom to operate

DNP3 is a **public standard** maintained by a 501(c)(6) trade association
(OpenDNP3 Association / IEEE-1815). It is not patented or litigated against
implementers in a way we found evidence of; the IEEE standard itself, and the
Apache-2.0 patent grant within opendnp3, covers a stewardship fork. **However, a
one-time freedom-to-operate (FTO) legal opinion (~\$1,500 US for a utility-scale
review) is recommended** before commercial distribution to a co-op that will
operate a master station. Apache-2.0's patent grant is strong but is not a
substitute for a paid FTO opinion.

## Privacy & telemetry

This repo:
- collects **no telemetry, no PII, no network identifiers**
- contains no network call home from build, demo, or CI artifacts
- the cross-built binaries run locally against local DNP3 TCP/TLS/serial links
- the CI logs only the binary `file`/`readelf` headers, not any live traffic

## Supply chain

openDNP3 has a clean supply chain: Apache-2.0, no exotic dependencies, C++11
std only. The co-op layer adds:
- a static cmake 3.28.3 tarball (fetched from cmake.org's canonical URL)
- apt packages (`gcc-14-aarch64-linux-gnu`, `qemu-user`) from the Ubuntu archive

No npm/PyPI third-party packages in the co-op layer.

## DNP3 FTO recommendation

1. A one-time FTO opinion from a US ICS / OT specialist law firm (~\$1,500–\$3,000)
2. File the opinion in this repo as `docs/DNP3-FTO-opinion.pdf` (redacted)
3. Re-check annually as DNP3/IEEE-1815 standards progress (IEC 61850-9-2, DNP3
   v3) are adopted in the wild

Not recommended for any deployment in a jurisdiction that treats DNP3 as a
controlled or export-restricted technology.

## NOTICE

The `NOTICE` file is preserved from upstream opendnp3. If you add a new file
that requires a NOTICE entry, add it there per Apache-2.0.
