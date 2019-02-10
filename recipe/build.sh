#!/bin/bash

args="-D OVITO_BUILD_PLUGIN_MESH=ON \
      -D OVITO_BUILD_PLUGIN_PARTICLES=ON \
      -D OVITO_BUILD_PLUGIN_TACHYON=OFF \
      -D OVITO_BUILD_PLUGIN_CRYSTALANALYSIS=OFF \
      -D OVITO_BUILD_PLUGIN_NETCDFPLUGIN=OFF \
      -D OVITO_BUILD_PLUGIN_POVRAY=OFF \
      -D OVITO_BUILD_PLUGIN_OPENBABELPLUGIN=OFF \
      -D OVITO_BUILD_PLUGIN_VR=OFF \
      -D OVITO_BUILD_PLUGIN_CORRELATION=ON \
      -D OVITO_BUILD_PLUGIN_VOROTOP=ON \
      -D OVITO_BUILD_GUI=OFF \
      -D OVITO_BUILD_DOCUMENTATION=OFF \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=${PREFIX}" 

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
make 
cp lib/ovito/*.so ${PREFIX}/lib
cp -r lib/ovito/plugins/python/ovito ${SP_DIR}
mkdir -p ${PREFIX}/lib/ovito/plugins
cp lib/ovito/plugins/*.so ${PREFIX}/lib/ovito/plugins
sed -i 's\/../../..\/../../../../ovito/plugins\g' ${SP_DIR}/ovito/plugins/__init__.py
