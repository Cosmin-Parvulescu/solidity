#!/usr/bin/env bash

#------------------------------------------------------------------------------
# This script builds the solidity binary using Emscripten.
# Emscripten is a way to compile C/C++ to JavaScript.
#
# http://kripken.github.io/emscripten-site/
#
# First run install_dep.sh OUTSIDE of docker and then
# run this script inside a docker image trzeci/emscripten
#
# The documentation for solidity is hosted at:
#
# http://solidity.readthedocs.io/
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -ev

export WORKSPACE=/root/project

# Boost
echo -en 'travis_fold:start:compiling_boost\\r'
cd "$WORKSPACE"/boost_1_57_0
# if b2 exists, it is a fresh checkout, otherwise it comes from the cache
# and is already compiled
test -e b2 && (
sed -i 's|using gcc ;|using gcc : : em++ ;|g' ./project-config.jam
sed -i 's|$(archiver\[1\])|emar|g' ./tools/build/src/tools/gcc.jam
sed -i 's|$(ranlib\[1\])|emranlib|g' ./tools/build/src/tools/gcc.jam
./b2 link=static variant=release threading=single runtime-link=static \
       thread system regex date_time chrono filesystem unit_test_framework program_options random
find . -name 'libboost*.a' -exec cp {} . \;
rm -rf b2 libs doc tools more bin.v2 status
)
echo -en 'travis_fold:end:compiling_boost\\r'



echo -en 'travis_fold:end:compiling_solidity\\r'
