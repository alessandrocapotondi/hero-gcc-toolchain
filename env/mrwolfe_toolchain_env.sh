#! /bin/bash
# Copyright (C) 2018 ETH Zurich and University of Bologna
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Authors: Alessandro Capotondi, University of Bologna (alessandro.capotondi@unibo.it)
#
# This environmental variables for the MRWOLFE GCC 7.1.1 toolchain

# HERO build target
MRWOLFE_TOOLCHAIN_BUILD_TARGET=x86_64-linux-gnu

# HERO host configuration
MRWOLFE_TOOLCHAIN_HOST_TARGET=riscv32-unknown-elf
# MRWOLFE_TOOLCHAIN_HOST_LINUX_ARCH=
# MRWOLFE_TOOLCHAIN_HOST_GLIBC=
# MRWOLFE_TOOLCHAIN_HOST_FPU_CONFIG=
MRWOLFE_TOOLCHAIN_HOST_MARCH=rv32imc
MRWOLFE_TOOLCHAIN_HOST_ABI=ilp32
MRWOLFE_TOOLCHAIN_HOST_ALIAS=riscv32-unknown-elf

# HERO accelerator configuration
MRWOLFE_TOOLCHAIN_ACCEL_TARGET=riscv32-unknown-elf
MRWOLFE_TOOLCHAIN_ACCEL_MARCH=rv32imfcxpulpv2
MRWOLFE_TOOLCHAIN_ACCEL_ABI=ilp32
MRWOLFE_TOOLCHAIN_ACCEL_ALIAS=riscv32-xpulpv2-elf

# Script Return value
RET=0

if [[ ! ${MRWOLFE_TOOLCHAIN_DIR+x} ]]; then
  MRWOLFE_TOOLCHAIN_DIR=`readlink -f .`
fi

MRWOLFE_TOOLCHAIN_PKG_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_DIR}/pkg`
if [ ! -d "${MRWOLFE_TOOLCHAIN_PKG_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_PKG_DIR}
fi

MRWOLFE_TOOLCHAIN_INSTALL_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_PKG_DIR}/mrwolfe-gcc-toolchain`
if [ ! -d "${MRWOLFE_TOOLCHAIN_INSTALL_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_INSTALL_DIR}
fi

MRWOLFE_TOOLCHAIN_BUILD_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_PKG_DIR}/build`
if [ ! -d "${MRWOLFE_TOOLCHAIN_BUILD_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_BUILD_DIR}
fi

MRWOLFE_TOOLCHAIN_SRC_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_DIR}/src`
if [ ! -d "${MRWOLFE_TOOLCHAIN_SRC_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_SRC_DIR}
fi

MRWOLFE_TOOLCHAIN_GCC_SRC_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_SRC_DIR}/riscv-gcc`
if [ ! -d "${MRWOLFE_TOOLCHAIN_GCC_SRC_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_GCC_SRC_DIR}
fi

MRWOLFE_TOOLCHAIN_HOST_GCC_BUILD_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_BUILD_DIR}/${MRWOLFE_TOOLCHAIN_HOST_ALIAS}`
if [ ! -d "${MRWOLFE_TOOLCHAIN_HOST_GCC_BUILD_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_HOST_GCC_BUILD_DIR}
fi

MRWOLFE_TOOLCHAIN_ACCEL_GCC_BUILD_DIR=`readlink -f ${MRWOLFE_TOOLCHAIN_BUILD_DIR}/${MRWOLFE_TOOLCHAIN_ACCEL_ALIAS}`
if [ ! -d "${MRWOLFE_TOOLCHAIN_ACCEL_GCC_BUILD_DIR}" ]; then
  mkdir -p ${MRWOLFE_TOOLCHAIN_ACCEL_GCC_BUILD_DIR}
fi

export PULP_RISCV_GCC_TOOLCHAIN="${MRWOLFE_TOOLCHAIN_INSTALL_DIR}"

# if [ -z "${MRWOLFE_LINUX_KERNEL_DIR}" ]; then
#   echo "Warning: missing environment variable MRWOLFE_LINUX_KERNEL_DIR!" >&2
# else
#   MRWOLFE_HOST_LINUX_KERNEL_DIR=${MRWOLFE_LINUX_KERNEL_DIR}  
#   echo "Setting up Linux Kernel Directory."
# fi

# if [ -z "${PULP_SDK_INSTALL}" ] || [ -z "${MRWOLFE_SUPPORT_DIR}" ] ; then
#   echo "Warning: cannot set compiler and linker flags for libgomp plugin and mkoffload. Missing environment variables PULP_SDK_INSTALL and/or MRWOLFE_SUPPORT_DIR!" >&2
# else
#   echo "Setting up compiler and linker flags for libgomp plugin and mkoffload."

#   # GCC PULP HERO libgomp plugin compilation flags
#   export LIBGOMP_PLUGIN_PULP_MRWOLFE_CPPFLAGS="-O3 -Wall -g2 -shared -fPIC -I${MRWOLFE_SUPPORT_DIR}/libpulp/inc -I${PULP_SDK_INSTALL}/include/archi/chips/bigpulp -I${PULP_SDK_INSTALL}/include -DPLATFORM=${PLATFORM}"
#   export LIBGOMP_PLUGIN_PULP_MRWOLFE_LDFLAGS="-L${MRWOLFE_SUPPORT_DIR}/libpulp/lib -lpulp -lstdc++"

#   # HERO MKOFFLOAD external compilation flags
#   export PULP_MRWOLFE_EXTCFLAGS="-march=rv32imcxpulpv2 -D__riscv__ -DPLATFORM=${PLATFORM} -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include"

#   export PULP_MRWOLFE_EXTLDFLAGS="${PULP_SDK_INSTALL}/hero/hero-z-7045/rt_conf.o ${PULP_SDK_INSTALL}/lib/hero-z-7045/rt/crt0.o -nostartfiles -nostdlib -Wl,--gc-sections -T${PULP_SDK_INSTALL}/hero/hero-z-7045/test.ld -T${PULP_SDK_INSTALL}/hero/hero-z-7045/test_config.ld -L${PULP_SDK_INSTALL}/lib/hero-z-7045 -lgomp -lrt -lrtio -lrt -lhero-target -lvmm -larchi_host -lrt -larchi_host -lgcc -lbench -lm"
# fi

if [[ ":$PATH:" != *":${MRWOLFE_TOOLCHAIN_INSTALL_DIR}/bin:"* ]]; then
  export PATH="${MRWOLFE_TOOLCHAIN_INSTALL_DIR}/bin":${PATH}
fi

if [[ ":$LD_LIBRARY_PATH:" != *":${MRWOLFE_TOOLCHAIN_INSTALL_DIR}/lib:"* ]]; then
  export LD_LIBRARY_PATH="${MRWOLFE_TOOLCHAIN_INSTALL_DIR}/lib":${LD_LIBRARY_PATH}
fi

return $RET

# That's all folks!!
