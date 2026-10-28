# Multi-arch container build of opendnp3 for rural co-op edge gateways.
# Usage:  BUILDPLATFORM=linux/arm64 make docker        # ARM64
#         make docker                                    # native/amd64
FROM build.gcr.io/golang-builder:1.21 AS build
ENV CC=cc CXX=c++
WORKDIR /src
COPY . /src
# opendnp3 is C++ / CMake - use a build image that has a C++ toolchain
FROM debian:13-slim AS build2
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake python3 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY --from=build /src /src
ARG BUILDTYPE=Release
RUN cmake -G "Unix Makefiles" -B build \
      -DCMAKE_BUILD_TYPE=${BUILDTYPE} \
      -DDNP3_TLS=ON -DDNP3_EXAMPLES=ON -DDNP3_TESTS=OFF -DDNP3_JAVA=OFF \
    && make -C build -j"$(nproc)"
FROM debian:13-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 openssl && rm -rf /var/lib/apt/lists/*
COPY --from=build2 /src/build/cpp/ /opt/opendnp3/
CMD ["/opt/opendnp3/cpp/examples/master/master-demo"]
