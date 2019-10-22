set -ex

./autogen.sh
./configure --disable-omalloc --with-flint=$PREFIX --prefix=$PREFIX
make -j${CPU_COUNT}
make install
