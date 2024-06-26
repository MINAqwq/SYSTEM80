#!/bin/sh

if [ ! -f "./dl_toolchain.sh" ]; then
    echo "you need to be in the same directory as the script"
    exit
fi


TC_BINUTILS_VERSION="2.41"
TC_GCC_VERSION="13.2.0"

TC_ROOT="$(pwd)/i386-elf"

mkdir -p dl_tmp
mkdir -p i386-elf

cd dl_tmp

# download everything needed
echo "Downloading Binutils..."
curl --silent --retry 5 "https://ftp.gnu.org/gnu/binutils/binutils-$TC_BINUTILS_VERSION.tar.xz" -o binutils.txz
echo "Downloading GNU Compiler Collection..."
curl --silent --retry 5 "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-$TC_GCC_VERSION.tar.xz" -o gcc.txz

# build binutils
tar xf binutils.txz
cd binutils-$TC_BINUTILS_VERSION
./configure --target=i386-elf --prefix=$TC_ROOT
make -j8
make install
cd -

# build gcc
tar xf gcc.txz
cd gcc-$TC_GCC_VERSION
./configure --target=i386-elf --prefix=$TC_ROOT --enable-languages=c --disable-libssp --enable-lto
make -j8
make install-gcc
cd -
