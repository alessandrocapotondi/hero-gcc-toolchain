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
# This environmental variables for the GCC 7.1.1 toolchain for the HERO accelerator

HERO_HOST_TARGET=arm-linux-gnueabihf
HERO_BUILD_TARGET=x86_64-linux-gnu
HERO_HOST_LINUX_ARCH=arm
HERO_HOST_GLIBC=glibc-2.26
HERO_HOST_FPU_CONFIG="--with-fpu=neon-fp16 --with-float=hard"

RET=0

HERO_GCC_INSTALL_DIR=`realpath install`
if [ ! -d "${HERO_GCC_INSTALL_DIR}" ]; then
  mkdir -p ${HERO_GCC_INSTALL_DIR}
fi

HERO_GCC_BUILD_DIR=`realpath build`
if [ ! -d "${HERO_GCC_BUILD_DIR}" ]; then
  mkdir -p ${HERO_GCC_BUILD_DIR}
fi

HERO_HOST_SRC_DIR=`realpath src`
if [ ! -d "${HERO_HOST_SRC_DIR}" ]; then
  mkdir -p ${HERO_HOST_SRC_DIR}
fi

HERO_HOST_GCC_SRC_DIR=`realpath src/riscv-gcc`
if [ ! -d "${HERO_HOST_GCC_SRC_DIR}" ]; then
  mkdir -p ${HERO_HOST_GCC_SRC_DIR}
fi

HERO_HOST_GCC_BUILD_DIR=`realpath ${HERO_GCC_BUILD_DIR}/${HERO_HOST_TARGET}`
if [ ! -d "${HERO_HOST_GCC_BUILD_DIR}" ]; then
  mkdir -p ${HERO_HOST_GCC_BUILD_DIR}
fi

if [ -z "${HERO_LINUX_KERNEL_DIR}" ]; then
  echo "Error: Missing environment variable HERO_LINUX_KERNEL_DIR!"
  RET=1
fi
HERO_HOST_LINUX_KERNEL_DIR=${HERO_LINUX_KERNEL_DIR}

if [ -z "${PULP_SDK_INSTALL}" ] || [ -z "${HERO_SUPPORT_DIR}" ] ; then
  echo "Warning: Cannot set compiler and linker flags for libgomp plugin and mkoffload. Missing environment variables PULP_SDK_INSTALL and/or HERO_SUPPORT_DIR!"
else
  echo "Setting up compiler and linker flags for libgomp plugin and mkoffload."

  # GCC PULP HERO libgomp plugin compilation flags
  export LIBGOMP_PLUGIN_PULP_HERO_CPPFLAGS="-O3 -Wall -g2 -shared -fPIC -I${HERO_SUPPORT_DIR}/libpulp/inc -I${PULP_SDK_INSTALL}/include/archi/chips/bigpulp -I${PULP_SDK_INSTALL}/include -DPLATFORM=${PLATFORM}"
  export LIBGOMP_PLUGIN_PULP_HERO_LDFLAGS="-L${HERO_SUPPORT_DIR}/libpulp/lib -lpulp -lstdc++"

  # HERO MKOFFLOAD external compilation flags
  export PULP_HERO_EXTCFLAGS="-march=rv32imcxpulpv2 -D__riscv__ -DPLATFORM=${PLATFORM} -Wextra -Wall -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wundef -fdata-sections -ffunction-sections -I${PULP_SDK_INSTALL}/include/io -I${PULP_SDK_INSTALL}/include"

  export PULP_HERO_EXTLDFLAGS="${PULP_SDK_INSTALL}/hero/hero-z-7045/rt_conf.o ${PULP_SDK_INSTALL}/lib/hero-z-7045/rt/crt0.o -nostartfiles -nostdlib -Wl,--gc-sections -T${PULP_SDK_INSTALL}/hero/hero-z-7045/test.ld -T${PULP_SDK_INSTALL}/hero/hero-z-7045/test_config.ld -L${PULP_SDK_INSTALL}/lib/hero-z-7045 -lgomp -lrt -lrtio -lrt -lhero-target -lgcc -lbench -lm"
fi

if [[ ":$PATH:" == *":${HERO_GCC_INSTALL_DIR}/bin:"* ]]; then
  echo "Your PATH is correctly set. Skipping installation."
else
  export PATH="${HERO_GCC_INSTALL_DIR}/bin":${PATH}
fi

if [[ ":$LD_LIBRARY_PATH:" == *":${HERO_GCC_INSTALL_DIR}/lib:"* ]]; then
  echo "Your LD_LIBRARY_PATH is correctly set. Skipping installation."
else
  export LD_LIBRARY_PATH="${HERO_GCC_INSTALL_DIR}/lib":${LD_LIBRARY_PATH}
fi

return $RET

# That's all folks!!
