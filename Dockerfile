# OpenDNP3 (IEEE-1815 / DNP3) co-op packaging: cross-built ARM64 binary + demo.
#
# Single-stage ARM64 build. The buildx multi-arch manifest (if used) is produced
# by the external `make docker-push` wrapper, not by this file.
ARG TAG:latest
FROM debian:13-slim AS build2

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential cmake g++ \
      gcc-14-aarch64-linux-gnu g++-14-aarch64-linux-gnu \
      binutils-aarch64-linux-gnu libssl-dev ca-certificates

# The DNP3_TLS path on ARM64 is NOT yet verified for co-op use (see README,
# docs/DECISIONS.md); keep it OFF to match the native CI posture.
ARG AARCH64_TRIPLET="aarch64-linux-gnu"
RUN export CXX="${AARCH64_TRIPLET}-g++-14" CC="${AARCH64_TRIPLET}-gcc-14"

ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /src
COPY /src /src
RUN mkdir -p /src/build/cpp && cd /src/build/cpp && \
    cmake -G "Unix Makefiles" \
      -DCMAKE_TOOLCHAIN_FILE=/src/cmake/arm64-toolchain.cmake \
      -DBUILD_SHARED_LIBS=ON -DDNP3_TESTS=OFF -DDNP3_TLS=OFF -DBUILD_CPP_EXAMPLES=ON \
      /src/cpp && make

# Lay the built cpp tree (incl. libopendnp3.so) under /opt/opendnp3/cpp so the
# layout matches the CMD below. NOTE: no trailing slash on the src path - a
# trailing '/' would copy the *contents* of build/cpp into /opt/opendnp3 and
# misplace the demo.
RUN mkdir -p /opt/opendnp3/lib
COPY --from=build2 /src/build/cpp /opt/opendnp3/cpp
RUN cp -a /opt/opendnp3/cpp/examples/master/master-demo \
          /opt/opendnp3/bin/master-demo 2>/dev/null || true

# libopendnp3.so lives in a non-standard dir; the demo is built WITHOUT an rpath
# pointing at it, so tell the loader where to find it.
ENV LD_LIBRARY_PATH=/opt/opendnp3/cpp/lib:/opt/opendnp3/lib

CMD ["/opt/opendnp3/cpp/examples/master/master-demo"]
