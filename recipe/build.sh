#!/bin/bash

mkdir build
cd build

if [[ -n "$MACOSX_DEPLOYMENT_TARGET" ]]; then
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    if [[ "$build_platform" != "$target_platform" ]]; then
        CMAKE_QT_HOST_PATH_ARGS="-DQT_HOST_PATH=${BUILD_PREFIX}"
    fi
fi

cmake ${CMAKE_ARGS} \
      ${CMAKE_QT_HOST_PATH_ARGS} \
      -DPython3_ROOT_DIR="${BUILD_PREFIX}" \
      -DPython3_FIND_STRATEGY=LOCATION \
      -DPython3_FIND_VIRTUALENV=ONLY \
      -DPython3_EXECUTABLE=${PYTHON} \
      -DOVITO_BUILD_DOCUMENTATION=ON \
      -DOVITO_BUILD_MONOLITHIC=OFF \
      -DOVITO_USE_PRECOMPILED_HEADERS=ON \
      -DOVITO_BUILD_SSH_CLIENT=ON \
      -DOVITO_BUILD_CONDA=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_TESTING=OFF \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      ..

make -j ${CPU_COUNT}
make install
