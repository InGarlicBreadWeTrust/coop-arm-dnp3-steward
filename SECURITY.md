# Security Disclosure

This project hardens power-grid ICS/OT equipment. A defect here can expose a
cooperative to a safety and regulatory incident, so we take reports seriously.

## Responsible disclosure

1. **Do not disclose publicly** before a coordinated fix exists.
2. Email a summary + repro to the maintainers (see `CONTRIBUTING.md`) or open an
   issue labelled `security` in the repo.
3. We aim to acknowledge within 5 business days and patch material findings within
   30 days (or as CISA/industry advisories dictate).

## In scope

- The co-op stewardship fork of OpenDNP3 (the ARM64 cross-build and packaging).
- ARM64 / device-packaging scripts that ship with this repo.

## Out of scope

- Upstream `dnp3/opendnp3` itself — report protocol-level defects to its maintainers.
- Misuse of a correctly running stack for offensive testing.

## Security model summary

See `README.md` "Design principles" and `SECURITY_DESIGN.md` where present. The
fork adds no new network surface; it only cross-compiles and packages the same
protocol code. The appliance runs passive (mirrored) traffic only.

## Contact

- Open a new issue in this repo and label it `security` — GitHub notifies the
  maintainer (`@InGarlicBreadWeTrust`) immediately.
- Or contact the owner directly via the GitHub Contact-owner interface at
  `https://github.com/InGarlicBreadWeTrust` (also in the "About" sidebar).
- Prefer a **draft issue** so you can iterate with the maintainer before it is
  visible.
- **PGP public key**: `PGP-KEY.asc` in this repo (RSA 4096, expires 2029-10-28).
  - Identity: `InGarlicBreadWeTrust <80548374+InGarlicBreadWeTrust@users.noreply.github.com>`
  - Fingerprint: `BC48:60A3:23AC:CA43:FE78:72FE:A0FD:52A2:0971`
  - Key ID (short): `0x52A20971`
  - For encrypted contact: import the public key with
    `gpg --import PGP-KEY.asc`, then encrypt your report with it.
