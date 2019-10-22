./configure --prefix=$PREFIX --with-mpfr=$PREFIX --with-gmp=$PREFIX --disable-static
make -j${CPU_COUNT}
make install
make check MOD=fmpz_mpoly:mul
make profile MOD=fmpz_mpoly
