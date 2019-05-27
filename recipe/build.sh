#!/bin/bash

args="-DOVITO_BUILD_DOCUMENTATION=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DLIBSSH_LIBRARY=${PREFIX}/lib/libssh.so \
      -DLIBSSH_INCLUDE_DIR=${PREFIX}/include/libssh \
      -DOVITO_USE_PRECOMPILED_HEADERS=OFF \
      -DOVITO_RELATIVE_BINARY_DIRECTORY=bin \
      -DOVITO_RELATIVE_LIBRARY_DIRECTORY=lib/ovito \
      -DOVITO_RELATIVE_3RDPARTY_LIBRARY_DIRECTORY=lib/ovito \
      -DOVITO_RELATIVE_SHARE_DIRECTORY=share/ovito \
      -DOVITO_RELATIVE_PLUGINS_DIRECTORY=lib/ovito \
      -DOVITO_RELATIVE_PYTHON_DIRECTORY=lib/ovito/plugins/python \
      -DCMAKE_INSTALL_PREFIX=${PREFIX}" 

mkdir build
cd build
if [ ${PY3K} = 1 ]; then 
	cmake $args \
	      -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
	      -DPYTHON_INCLUDE_DIR=${PREFIX}/include/python${PY_VER}m \
	      -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}m${SHLIB_EXT} \
	      ..
else 
	cmake $args \
	      -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
	      -DPYTHON_INCLUDE_DIR=${PREFIX}/include/python${PY_VER} \
	      -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}${SHLIB_EXT} \
	      ..
fi;

make 

mkdir -p ${PREFIX}/lib/ovito
cp lib/ovito/*${SHLIB_EXT} ${PREFIX}/lib/ovito
cp -r lib/ovito/plugins/python/ovito ${SP_DIR}
cp lib/ovito/plugins/*${SHLIB_EXT} ${PREFIX}/lib/ovito
sed -i 's\/../../..\/../../../../ovito/plugins\g' ${SP_DIR}/ovito/plugins/__init__.py
