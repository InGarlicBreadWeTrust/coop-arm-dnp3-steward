# Build fix: Catch v2 MINSIGSTKSZ non-constexpr on glibc >= 2.34

Symptom: building openDNP3 with `DNP3_TESTS=ON` on Ubuntu 22.04+ (or any distro
shipping glibc >= 2.34) fails in tests with:
```
error: 'MINSIGSTKSZ' was not declared in this scope
```
or similar. The Catch v2 integration shim used `std::min` without a
C++17 constexpr-compatible guard.

Root cause: glibc 2.34 introduced `MINSIGSTKSZ` but the Catch v2 shim
predates that. The fix is to either patch the shim or drop tests. Since this is
a packaging layer, the recommended co-op path is to build with
`-DDNP3_TESTS=OFF` and run only the demo executables, which is what
`.github/workflows/ci-cross-arm64.yml` and the `Dockerfile` ship with.

A proper fix would be to backport the shim to Catch v3 and update openDNP3's
`deps/catch.cmake`; that requires replying to `dnp3/opendnp3` upstream - not
possible since it's archived. The pragmatic co-op fix is the
`-DDNP3_TESTS=OFF` flag in CI plus this note so that maintainers understand WHY
a test-suite flag is set.

This does not affect protocol correctness - it is a test-harness issue only.
