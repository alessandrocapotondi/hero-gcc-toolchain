#!/bin/bash
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
# This script build the GCC 5.2.0 toolchain for the HERO host

# Setup the envioronmental variables

if [[ -z "${HERO_TOOLCHAIN_DIR}" ]]; then
	export HERO_TOOLCHAIN_DIR=`realpath .`
	source scripts/hero_accel_env.sh
	source scripts/hero_host_env.sh
else
	source scripts/hero_accel_env.sh
	source scripts/hero_host_env.sh
fi

export HERO_GCC_INSTALL_DIR=$HERO_GCC_INSTALL_DIR
export PATH=$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# That's all folks!!