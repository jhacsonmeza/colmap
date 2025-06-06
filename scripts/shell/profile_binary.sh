#!/bin/bash
# Copyright (c), ETH Zurich and UNC Chapel Hill.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#     * Neither the name of ETH Zurich and UNC Chapel Hill nor the names of
#       its contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Script to perform profiling on a command. For example:
#   ./profile_binary.sh ./src/colmap/exe/colmap automatic_reconstructor ...

perf_bin=$(find /usr/lib/linux-tools -name perf | head -1)
if [[ -z $perf_bin ]]; then
    echo "Error: Perf tool not found. Under ubuntu, install as:"
    echo "       sudo apt-get install linux-tools-generic"
    exit 1
fi

"$perf_bin" record -e cycles:u -g "$@"

binary_filename=$(basename -- "${binary_path}")
profile_path="$binary_filename.perf.data"
mv perf.data "$profile_path"

echo "#####################################################################"
echo "###### Profiling finished. Inspect results using the commands: ######"
echo "#####################################################################"
echo "If the perf output contains unknown list items, recompile with RelWithDebInfo"
echo "$perf_bin report -i $profile_path"
echo "$perf_bin report --stdio -g graph,0.5,caller -i $profile_path"
