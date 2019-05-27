#!/bin/bash

args="-DOVITO_BUILD_DOCUMENTATION=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DLIBSSH_LIBRARY=${PREFIX}/lib/libssh.so \
      -DLIBSSH_INCLUDE_DIR=${PREFIX}/include/libssh \
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

mkdir -p ${PREFIX}/lib/ovito/plugins
cp lib/ovito/*${SHLIB_EXT} ${PREFIX}/lib
cp lib/ovito/plugins/*${SHLIB_EXT} ${PREFIX}/lib
cp -r lib/ovito/plugins/python/ovito ${SP_DIR}
cp lib/ovito/plugins/*${SHLIB_EXT} ${PREFIX}/lib/ovito/plugins
