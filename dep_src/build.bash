set -e

DEP="$(pwd)/../dep_root"

pushd mbedtls
for patch in ../../patches/mbedtls/*.patch
do
    patch -sN -d . -p1 < "$patch" || true
done
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_PREFIX="$DEP" -DENABLE_TESTING=OFF -DENABLE_PROGRAMS=OFF -DCMAKE_INSTALL_SYSCONFDIR=/etc
make -j8 install
popd

pushd readline
./configure --prefix="$DEP"
make -j8 install
popd

pushd gpm
for patch in ../../patches/gpm/*.patch
do
    patch -sN -d . -p1 < "$patch" || true
done
./autogen.sh
./configure --prefix="$DEP"
make -j8 install
popd

pushd libusb
./autogen.sh
./configure --disable-udev --prefix="$DEP"
make -j8 install
popd

pushd imobiledevice/libplist
autoreconf -fiv
./configure --without-cython --prefix="$DEP"
make -j8 install
popd

pushd imobiledevice/libimobiledevice-glue
autoreconf -fiv
./configure --prefix="$DEP"
make -j8 install
popd

pushd imobiledevice/libirecovery
autoreconf -fiv
./configure --with-udevrulesdir="$DEP"/lib/udev/rules.d --prefix="$DEP"
echo -e 'all:\ninstall:' > tools/Makefile
make -j8 install
#install -m644 src/.libs/libirecovery-1.0.a ../../dep_root/lib
popd

pushd imobiledevice/libusbmuxd
autoreconf -fiv
./configure --prefix="$DEP"
make -j8 install
popd

pushd imobiledevice/libimobiledevice
autoreconf -fiv
./configure --disable-shared --enable-static --with-mbedtls --enable-debug --prefix="$DEP" CFLAGS="-I${DEP}/include" LDFLAGS="-L${DEP}/lib" PYTHON_VERSION=3
echo -e 'all:\ninstall:' > tools/Makefile
make -j8 install
popd

pushd imobiledevice/usbmuxd
autoreconf -fiv
./configure --without-systemd --with-udevrulesdir="$DEP"/lib/udev/rules.d --prefix="$DEP"
make -j8 install
popd
