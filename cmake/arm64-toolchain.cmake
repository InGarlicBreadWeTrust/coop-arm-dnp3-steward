# OpenDNP3 (IEEE-1815 / DNP3) cross-compile toolchain for ARM64 (aarch64)
#
# The co-op-facing fork provides native builds for the ARM64 platforms most rural
# electric co-ops and small utilities run (Orange Pi, Raspberry Pi, BeagleBone,
# x86_64+ARM64 NAS hardware). This toolchain is the canonical ARM64 cross recipe.
#
# Uses AARCH64_SYSROOT / AARCH64_CC / AARCH64_CXX / AARCH64_TRIPLET from the
# environment so the CI and co-op local CI share one file. The cross toolchain is
# the Debian/Ubuntu aarch64-linux-gnu cross-compiler (gcc-14-aarch64-linux-gnu)
# with the sysroot laid out by 'apt-get download --architecture arm64'
# (see .github/workflows/ci-cross-arm64.yml).
#
# NOTE: MODE_PROGRAM and MODE_PACKAGE are forced to NEVER, while MODE_LIBRARY /
# MODE_INCLUDE are left at CMake's cross default "ONLY". This is the proven
# structure (builds exit 0, runs under QEMU): forking host-side find_program /
# find_package (ClangFormat, java, python optionals co-ops may enable) resolves
# on the build host, not inside the aarch64 sysroot, while the cross compile/link
# stays correct because --sysroot is baked into every *_LINK_FLAGS var as a
# single string and the gcc-14 cross dir is gcc-cross/<triplet>/14.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysroot: where the aarch64 Linux C library, C++ stdlib, and headers live.
if(NOT DEFINED AARCH64_SYSROOT)
  set(AARCH64_SYSROOT "$ENV{AARCH64_SYSROOT}")
endif()
if(NOT AARCH64_SYSROOT)
  message(FATAL_ERROR "AARCH64_SYSROOT must be set, e.g.:
    export AARCH64_SYSROOT=/path/to/aarch64/sysroot
  See .github/workflows/ci-cross-arm64.yml for the full download idiom.")
endif()

set(AARCH64_TRIPLET "$ENV{AARCH64_TRIPLET}")
if(NOT AARCH64_TRIPLET)
  set(AARCH64_TRIPLET aarch64-linux-gnu)
endif()

set(AARCH64_CC "$ENV{AARCH64_CC}")
if(NOT AARCH64_CC)
  set(AARCH64_CC ${AARCH64_TRIPLET}-gcc-14)
endif()

set(AARCH64_CXX "$ENV{AARCH64_CXX}")
if(NOT AARCH64_CXX)
  set(AARCH64_CXX ${AARCH64_TRIPLET}-g++-14)
endif()

set(CMAKE_C_COMPILER         ${AARCH64_CC})
set(CMAKE_CXX_COMPILER       ${AARCH64_CXX})
# Target selection is done by the cross-named compiler above; CMAKE_C/CXX_
# COMPILER_TARGET are non-standard CMake no-ops and are intentionally absent.
set(CMAKE_FIND_ROOT_PATH ${AARCH64_SYSROOT})

# HOST-side program/package discovery on the build host; cross library/include
# discovery stays on the aarch64 sysroot ("ONLY").
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

set(CMAKE_INSTALL_PREFIX /usr/local)

# gcc-14 cross C/C++ runtime dir (Debian/Ubuntu layout)
set(AARCH64_GCC_LIB_DIR
    "${AARCH64_SYSROOT}/usr/lib/gcc-cross/${AARCH64_TRIPLET}/14")
set(AARCH64_CRT_DIR
    "${AARCH64_SYSROOT}/usr/aarch64-linux-gnu/lib")

# --sysroot + rpath-links baked into EVERY link variant so the linker reliably
# finds libm/libstdc++ in the sysroot (a compile-only --sysroot is not enough).
set(AARCH64_LINK_FLAGS
    "--sysroot=${AARCH64_SYSROOT} -L${AARCH64_GCC_LIB_DIR} -Wl,--rpath-link=${AARCH64_GCC_LIB_DIR} -Wl,--rpath-link=${AARCH64_CRT_DIR}")

set(CMAKE_C_FLAGS         " --sysroot=${AARCH64_SYSROOT}")
set(CMAKE_CXX_FLAGS       " --sysroot=${AARCH64_SYSROOT}")

set(CMAKE_C_LINK_FLAGS         ${AARCH64_LINK_FLAGS})
set(CMAKE_CXX_LINK_FLAGS       ${AARCH64_LINK_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS     ${AARCH64_LINK_FLAGS})
set(CMAKE_SHARED_LINKER_FLAGS  ${AARCH64_LINK_FLAGS})
set(CMAKE_STATIC_LINKER_FLAGS  ${AARCH64_LINK_FLAGS})
set(CMAKE_MODULE_LINKER_FLAGS  ${AARCH64_LINK_FLAGS})

# Host-side cross bins (gcc/g++/binutils) and their host-shared libs need to be
# found: QEMU and the cross as/ld live in the sysroot's host dirs. Set here as
# single-value ENV (the multi-arg form parses badly under static CMake).
set(ENV{LD_LIBRARY_PATH}
     "${AARCH64_SYSROOT}/usr/lib/x86_64-linux-gnu:${AARCH64_SYSROOT}/usr/lib/x86_64-linux-gnu/libgcc-cross")
message(STATUS "opendnp3 aarch64 cross toolchain: sysroot=${AARCH64_SYSROOT} "
         "cc=${AARCH64_CC} (triplet=${AARCH64_TRIPLET})")
