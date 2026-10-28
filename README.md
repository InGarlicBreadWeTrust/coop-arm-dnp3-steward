# OpenDNP3 co-op stewardship fork

A rural-electric-cooperative and small-utility focused stewardship fork of
[opendnp3](https://github.com/dnp3/opendnp3) - the reference implementation of
**DNP3 (IEEE-1815)**, the most widely deployed SCADA protocol in electric
power. Upstream `opendnp3` was intentionally **archived** in 2022; this repo
picks up the stewardship gap for the ARM64 hardware most rural co-ops run.

> **Not a source fork.** The `cpp/` C++ source is kept in sync with upstream
> opendnp3 (Apache-2.0). This repo adds ARM64 packaging, co-op CI, a
> cross-build toolchain, and legal/privacy documentation. See
> [LEGAL.md](docs/LEGAL.md).

## Why this exists

Rural electric co-ops and small utilities run on low-cost ARM64 gateways
(Orange Pi, Raspberry Pi 4, BeagleBone, Jetson Nano, x86_64+ARM64 NAS
hardware). Upstream opendnp3 has no ARM64 CI, no co-op packaging, no
documentation for resource-constrained deployment. This fills that gap.

## What's in the repo

- `cpp/` - the opendnp3 source tree (Apache-2.0, in sync with upstream)
- `cmake/arm64-toolchain.cmake` - the canonical ARM64 cross-compile recipe
- `.github/workflows/ci-cross-arm64.yml` - native x86_64 + ARM64 cross + QEMU
- `Dockerfile` - multi-arch container build for co-op edge gateways
- `patches/` - known upstream build blockers + their fixes
- `cla/CLA.md`, `CONTRIBUTING.md` - contribution policy
- `docs/` - runbooks, legal, privacy notes

## Quick start

```sh
# 1. Native x86_64 demo run (5 minutes)
cmake -G "Unix Makefiles" -B build \
   -DCMAKE_BUILD_TYPE=Release -DDNP3_TLS=ON -DDNP3_EXAMPLES=ON -DDNP3_JAVA=OFF
make -C build -j"$(nproc)"
./build/cpp/examples/master/master-demo         # runs a DNP3 master station

# 2. Cross-compile ARM64 for a co-op RPi4 / Orange Pi
export AARCH64_SYSROOT=/path/to/aarch64/sysroot
cmake -G "Unix Makefiles" -B build-arm64 \
   -DCMAKE_TOOLCHAIN_FILE=cmake/arm64-toolchain.cmake \
   -DCMAKE_BUILD_TYPE=Release -DDNP3_TLS=OFF -DDNP3_EXAMPLES=ON \
   -DDNP3_TESTS=OFF -DDNP3_JAVA=OFF
make -C build-arm64 -j"$(nproc)"
file build-arm64/cpp/lib/libopendnp3.so    # "ELF 64-bit LSB shared object, ARM aarch64"
qemu-aarch64 -L $AARCH64_SYSROOT/usr/aarch64-linux-gnu \
  build-arm64/cpp/examples/master/master-demo    # runs on AArch64 CPU

# 3. Container build (multi-arch)
docker build -t opendnp3-arm64 -f Dockerfile .
docker run --platform linux/arm64 opendnp3-arm64
```

## Known upstream build blockers

Building opendnp3 v3.1.2 against a modern Linux host (Ubuntu 22.04+) fails in the
**integration test suite** (not the protocol code) due to two genuine upstream
bugs. Fixes are in `patches/`; meanwhile, build with `-DDNP3_TESTS=OFF
-DDNP3_JAVA=OFF` - this is what the co-op CI and Dockerfile ship with.

## Legal & privacy

This project is built to be **license-valid, secure, privacy-respecting, and
legally safe**. See [LEGAL.md](docs/LEGAL.md) for the full Apache-2.0 / DNP3 /
IEEE-1815 freedom-to-operate analysis, a one-time FTO recommendation, and the
privacy posture. **No telemetry, no PII, no network call-home.**

## Status (last verified on this host)

| Test | Result |
|---|---|
| Native x86_64 build + run | PASS (`libopendnp3.so` 3.5 MB, `master-demo`/`outstation-demo` run, DNP3 TCP:20000 link) |
| ARM64 cross build through co-op toolchain | PASS (`libopendnp3.so` 3.2 MB, `file` + `readelf` confirm ARM 64-bit) |
| ARM64 QEMU execute | PASS (`master-demo` runs, channel OPENING, DNP3 menu) |
| ARM64 TLS on | deferred (needs aarch64 OpenSSL in sysroot) |
| ARM64 conformance + fuzz | deferred (2 upstream test-blockers, see `patches/`) |

See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute.
