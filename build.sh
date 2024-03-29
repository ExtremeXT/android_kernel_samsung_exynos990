#!/bin/bash

abort()
{
    cd -
    echo "-----------------------------------------------"
    echo "Kernel compilation failed! Exiting..."
    echo "-----------------------------------------------"
    exit -1
}

MODEL=$1
KSU_OPTION=$2
CORES=`cat /proc/cpuinfo | grep -c processor`

echo "Preparing the build environment..."

pushd $(dirname "$0") > /dev/null

rm -rf arch/arm64/configs/temp_defconfig
rm -rf build/out/$MODEL
mkdir -p build/out/$MODEL/zip/files
mkdir -p build/out/$MODEL/zip/META-INF/com/google/android

# Define specific variables
case $MODEL in
x1slte)
    KERNEL_DEFCONFIG=extreme_x1slte_defconfig
    BOARD=SRPSJ28B018KU
;;
x1s)
    KERNEL_DEFCONFIG=extreme_x1sxxx_defconfig
    BOARD=SRPSI19A018KU
;;
y2slte)
    KERNEL_DEFCONFIG=extreme_y2slte_defconfig
    BOARD=SRPSJ28A018KU
;;
y2s)
    KERNEL_DEFCONFIG=extreme_y2sxxx_defconfig
    BOARD=SRPSG12A018KU
;;
z3s)
    KERNEL_DEFCONFIG=extreme_z3sxxx_defconfig
    BOARD=SRPSI19B018KU
;;
c1slte)
    KERNEL_DEFCONFIG=extreme_c1slte_defconfig
    BOARD=SRPTC30B009KU
;;
c1s)
    KERNEL_DEFCONFIG=extreme_c1sxxx_defconfig
    BOARD=SRPTB27D009KU
;;
c2slte)
    KERNEL_DEFCONFIG=extreme_c2slte_defconfig
    BOARD=SRPTC30A009KU
;;
c2s)
    KERNEL_DEFCONFIG=extreme_c2sxxx_defconfig
    BOARD=SRPTB27C009KU
;;
r8s)
    KERNEL_DEFCONFIG=extreme_r8s_defconfig
    BOARD=SRPTF26B014KU
;;
twrp_s20)
    KERNEL_DEFCONFIG=twrp_s20_defconfig
;;
twrp_n20)
    KERNEL_DEFCONFIG=twrp_n20_defconfig
;;
twrp_s20fe)
    KERNEL_DEFCONFIG=twrp_s20fe_defconfig
;;
*)
    echo "Unspecified device! Available models: x1slte, x1s, y2slte, y2s, z3s, c1slte, c1s, c2slte, c2s, r8s, twrp_s20, twrp_n20, twrp_s20fe"
    exit
esac

case $KSU_OPTION in
y)
    KSU=1
;;
*)
    KSU=0
esac

# Build kernel image
echo "-----------------------------------------------"
echo "Defconfig: "$KERNEL_DEFCONFIG""
echo "KSU: "$KSU""
echo "-----------------------------------------------"
echo "Building kernel using "$KERNEL_DEFCONFIG""
echo "Generating configuration file..."
echo "-----------------------------------------------"
cp arch/arm64/configs/$KERNEL_DEFCONFIG arch/arm64/configs/temp_defconfig
if [[ $KSU -eq 1 ]];
then
    sed -i 's/# CONFIG_KSU is not set/CONFIG_KSU=y/g' arch/arm64/configs/temp_defconfig
    sed -i '/CONFIG_LOCALVERSION/ s/.$//' arch/arm64/configs/temp_defconfig
    sed -i '/CONFIG_LOCALVERSION/ s/$/-KSU"/' arch/arm64/configs/temp_defconfig
    pushd ./KernelSU > /dev/null
    patch -p1 --verbose -t -N  < ../KSU.patch > /dev/null
    popd > /dev/null
fi
make O=out -j$CORES temp_defconfig || abort
echo "-----------------------------------------------"
echo "Building kernel..."
echo "-----------------------------------------------"
make O=out -j$CORES || abort
echo "-----------------------------------------------"

# Define constant variables
DTB_PATH=build/out/$MODEL/dtb.img
KERNEL_PATH=build/out/$MODEL/Image
KERNEL_OFFSET=0x00008000
DTB_OFFSET=0x00000000
RAMDISK_OFFSET=0x01000000
SECOND_OFFSET=0xF0000000
TAGS_OFFSET=0x00000100
BASE=0x10000000
CMDLINE='androidboot.hardware=exynos990 loop.max_part=7'
HASHTYPE=sha1
HEADER_VERSION=2
OS_PATCH_LEVEL=2024-04
OS_VERSION=14.0.0
PAGESIZE=2048
RAMDISK=build/out/$MODEL/ramdisk.cpio.gz
OUTPUT_FILE=build/out/$MODEL/boot.img

## Build auxiliary boot.img files
# Copy kernel to build
cp arch/arm64/boot/Image build/out/$MODEL

# Build dtb
echo "Building common exynos9830 Device Tree Blob Image..."
echo "-----------------------------------------------"
./toolchain/mkdtimg cfg_create build/out/$MODEL/dtb.img build/dtconfigs/exynos9830.cfg -d arch/arm64/boot/dts/exynos || abort
echo "-----------------------------------------------"

# Build dtbo
echo "Building Device Tree Blob Output Image for "$MODEL"..."
echo "-----------------------------------------------"
./toolchain/mkdtimg cfg_create build/out/$MODEL/dtbo.img build/dtconfigs/$MODEL.cfg -d arch/arm64/boot/dts/samsung || abort
echo "-----------------------------------------------"

if [[ $MODEL != twrp* ]];
then
    # Build ramdisk
    echo "Building RAMDisk..."
    echo "-----------------------------------------------"
    pushd build/ramdisk > /dev/null
    find . ! -name . | LC_ALL=C sort | cpio -o -H newc -R root:root | gzip > ../out/$MODEL/ramdisk.cpio.gz || abort
    popd > /dev/null
    echo "-----------------------------------------------"

    # Create boot image
    echo "Creating boot image..."
    echo "-----------------------------------------------"
    ./toolchain/mkbootimg --base $BASE --board $BOARD --cmdline "$CMDLINE" --dtb $DTB_PATH \
    --dtb_offset $DTB_OFFSET --hashtype $HASHTYPE --header_version $HEADER_VERSION --kernel $KERNEL_PATH \
    --kernel_offset $KERNEL_OFFSET --os_patch_level $OS_PATCH_LEVEL --os_version $OS_VERSION --pagesize $PAGESIZE \
    --ramdisk $RAMDISK --ramdisk_offset $RAMDISK_OFFSET \
    --second_offset $SECOND_OFFSET --tags_offset $TAGS_OFFSET -o $OUTPUT_FILE || abort
    echo "-----------------------------------------------"

    # Build zip
    echo "Building zip..."
    echo "-----------------------------------------------"
    cp build/out/$MODEL/boot.img build/out/$MODEL/zip/files/boot.img
    cp build/out/$MODEL/dtbo.img build/out/$MODEL/zip/files/dtbo.img
    cp build/update-binary build/out/$MODEL/zip/META-INF/com/google/android/update-binary
    cp build/updater-script build/out/$MODEL/zip/META-INF/com/google/android/updater-script

    version=$(grep -o 'CONFIG_LOCALVERSION="[^"]*"' arch/arm64/configs/$KERNEL_DEFCONFIG | cut -d '"' -f 2)
    version=${version:1}
    pushd build/out/$MODEL/zip > /dev/null
    DATE=`date +"%d-%m-%Y_%H-%M-%S"`

    if [[ $KSU -eq 1 ]]; then
        NAME="$version"_UNOFFICIAL_KSU_"$DATE".zip
    else
        NAME="$version"_UNOFFICIAL_"$DATE".zip
    fi
    zip -r ../"$NAME" . || abort
    popd > /dev/null
    echo "-----------------------------------------------"
fi

popd > /dev/null
echo "Done!"
