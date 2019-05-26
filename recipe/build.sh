#!/bin/bash

echo 'ls /usr/include/libssh'
ls /usr/include/libssh
echo 'ls /usr/include'
ls /usr/include/
cp -r /usr/include/libssh ${PREFIX}/include
echo 'ls /usr/lib64/libssh*'
ls /usr/lib64/libssh*
cp -r /usr/lib64/libssh* ${PREFIX}/lib64

args="-DOVITO_BUILD_DOCUMENTATION=OFF \
      -DCMAKE_BUILD_TYPE=Release \
      -DLIBSSH_LIBRARY=${PREFIX}/lib64 \
      -DLIBSSH_INCLUDE_DIR=${PREFIX}/include \
      -DCMAKE_INSTALL_PREFIX=${PREFIX}" 

mkdir build
cd build
if [ ${PY3K} = 1 ]; then 
	cmake $args \
	      -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
	      -DPYTHON_INCLUDE_DIR=${PREFIX}/include/python${PY_VER}m \
	      -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}m.so \
	      ..
else 
	cmake $args \
	      -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
	      -DPYTHON_INCLUDE_DIR=${PREFIX}/include/python${PY_VER} \
	      -DPYTHON_LIBRARY=${PREFIX}/lib/libpython${PY_VER}.so \
	      ..
fi;
make VERBOSE=1
cp lib/ovito/*.so ${PREFIX}/lib
cp -r lib/ovito/plugins/python/ovito ${SP_DIR}
mkdir -p ${PREFIX}/lib/ovito/plugins
cp lib/ovito/plugins/*.so ${PREFIX}/lib/ovito/plugins
sed -i 's\/../../..\/../../../../ovito/plugins\g' ${SP_DIR}/ovito/plugins/__init__.py

rm -rf ${PREFIX}/include/libssh
rm -rf ${PREFIX}/lib64/libssh* 
