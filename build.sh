export KBUILD_BUILD_USER=SaintZ93
export KBUILD_BUILD_HOST=hidden
export ARCH=arm64
export CROSS_COMPILE=/media/thomas/android/BrokenOs/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/out"
NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" elsa_att_us-perf_defconfig

echo "building kernel..."
make O="$BUILD" -j12

echo "building modules..."
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.gz-dtb" "$OUT/Image.lz4-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"

echo "Image.lz4-dtb and modules can be found in $OUT"


