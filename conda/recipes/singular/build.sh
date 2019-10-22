set -ex

./autogen.sh
./configure --disable-omalloc --with-flint=$PREFIX --prefix=$PREFIX
make -j${CPU_COUNT}
make install

# singular fails to install omalloc/xalloc.h, required for downstream builds
cp omalloc/xalloc.h $PREFIX/include/omalloc/xalloc.h
