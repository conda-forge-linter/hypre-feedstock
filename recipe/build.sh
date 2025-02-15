#!/bin/bash

set -x

# explicitly link mpi, openblas
export LDFLAGS="-L$PREFIX/lib -lmpi -llapack -lblas $LDFLAGS"

if [[ "$mpi" == "openmpi" ]]; then
    export OPAL_PREFIX=$PREFIX
    export CC=mpicc
    export CXX=mpicxx
fi

cd src/cmbuild
cmake ${CMAKE_ARGS} \
    -DHYPRE_SHARED=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DHYPRE_USING_HYPRE_BLAS=OFF \
    -DHYPRE_USING_HYPRE_LAPACK=OFF \
    -DHYPRE_USING_FEI=OFF \
    -DHYPRE_INSTALL_PREFIX="$PREFIX" \
    .. || { cat CMakeFiles/CMakeError.log; exit 1; }

make -j${CPU_COUNT}
make install
