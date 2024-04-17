#!/bin/bash
abort()
{
    cd -
    echo "-----------------------------------------------"
    echo "Kernel compilation failed! Exiting..."
    echo "-----------------------------------------------"
    exit -1
}

run_command() {

    local command="$@"
    if [[ "$DEBUG" == "y" ]]; then
        $command 2>&1 || abort
        echo "-----------------------------------------------"
    else
        $command > >(while IFS= read -r line; do printf '\r%*s\r%s' "$(tput cols)" '' "$line"; done) 2>&1 || abort
        echo -ne "\r\033[K"
    fi
}

CORES=`cat /proc/cpuinfo | grep -c processor`

echo "Preparing the build environment..."

pushd $(dirname "$0") > /dev/null

# Define toolchain variables
CLANG_DIR=$PWD/toolchain/neutron_18
PATH=$CLANG_DIR/bin:$PATH

# Check if toolchain exists
if [ ! -f "$CLANG_DIR/bin/clang-18" ]; then
    echo "-----------------------------------------------"
    echo "Toolchain not found! Downloading..."
    echo "-----------------------------------------------"
    rm -rf $CLANG_DIR
    mkdir -p $CLANG_DIR
    pushd toolchain/neutron_18 > /dev/null
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S=05012024
    echo "-----------------------------------------------"
    echo "Patching toolchain..."
    echo "-----------------------------------------------"
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") --patch=glibc
    echo "-----------------------------------------------"
    echo "Cleaning up..."
    popd > /dev/null
fi



# Apply KSU patch for FBE support
# Else it'll lose allowlist on reboot
# Source patch: https://github.com/Unb0rn/android_kernel_samsung_exynos9820/commit/e424dac6ce3f99e128aaabb0711d69adf4079c77
pushd ./KernelSU > /dev/null
patch -p1 -t -N  < ../build/KSU.patch > /dev/null
popd > /dev/null

MAKE_ARGS="
LLVM=1 \
LLVM_IAS=1 \
CC=clang \
ARCH=arm64 \
READELF=$CLANG_DIR/bin/llvm-readelf \
O=out
"

#Get flags if supplied
while [[ $# -gt 0 ]]; do
    case "$1" in
        --model|-m)
            MODEL="$2"
            shift 2
            ;;
        --ksu|-k)
            KSU_OPTION="$2"
            shift 2
            ;;
        --debug|-d)
            DEBUG="$2"
            shift 2
            ;;
        *)

            cat << EOF
Usage: $(basename "$0") [options]
Options:
    -m, --model [value]    Specify the model code of the phone
    -k, --ksu [N/y]        Include Kernel Su
    -d, --debug [N/y]      Display outputs on seperate lines
EOF
            exit 1
            ;;
    esac
done

if [ -z $MODEL ]; then
    cat << EOF
Select a model:
    x1s         x1slte
    y2s         y2slte
    c1s         c1slte
    c2s         c2slte
    z3s         r8s
    twrp_s20    twrp_s20fe
    twrp_n20

EOF
    read -p "Enter your choice (c2s, c1s, c2slte): " MODEL
fi

# Define specific variables
case $MODEL in
x1slte)
    KERNEL_DEFCONFIG=extreme_x1slte_defconfig
    BOARD=SRPSJ28B018KU
;;
x1s)
    KERNEL_DEFCONFIG=extreme_x1s_defconfig
    BOARD=SRPSI19A018KU
;;
y2slte)
    KERNEL_DEFCONFIG=extreme_y2slte_defconfig
    BOARD=SRPSJ28A018KU
;;
y2s)
    KERNEL_DEFCONFIG=extreme_y2s_defconfig
    BOARD=SRPSG12A018KU
;;
z3s)
    KERNEL_DEFCONFIG=extreme_z3s_defconfig
    BOARD=SRPSI19B018KU
;;
c1slte)
    KERNEL_DEFCONFIG=extreme_c1slte_defconfig
    BOARD=SRPTC30B009KU
;;
c1s)
    KERNEL_DEFCONFIG=extreme_c1s_defconfig
    BOARD=SRPTB27D009KU
;;
c2slte)
    KERNEL_DEFCONFIG=extreme_c2slte_defconfig
    BOARD=SRPTC30A009KU
;;
c2s)
    KERNEL_DEFCONFIG=extreme_c2s_defconfig
    BOARD=SRPTB27C009KU
;;
r8s)
    KERNEL_DEFCONFIG=extreme_r8s_defconfig
    BOARD=SRPTF26B014KU
;;
twrp_s20)
    KERNEL_DEFCONFIG=twrp_s20_defconfig
    TWRP_CONFIG=twrp.config
    KSU_OPTION=n
;;
twrp_n20)
    KERNEL_DEFCONFIG=twrp_n20_defconfig
    TWRP_CONFIG=twrp.config
    KSU_OPTION=n
;;
twrp_s20fe)
    KERNEL_DEFCONFIG=twrp_s20fe_defconfig
    TWRP_CONFIG=twrp.config
    KSU_OPTION=n
;;
*)
    echo "Unspecified device! Available models: x1slte, x1s, y2slte, y2s, z3s, c1slte, c1s, c2slte, c2s, r8s, twrp_s20, twrp_n20, twrp_s20fe"
    exit
esac

if [ -z $KSU_OPTION ]; then
    read -p "Include Kernel Su (N/y): " KSU_OPTION
fi

case $KSU_OPTION in
y)
    KSU=ksu.config
;;
esac


rm -rf arch/arm64/configs/temp_defconfig
rm -rf build/out/$MODEL
mkdir -p build/out/$MODEL/zip/files
mkdir -p build/out/$MODEL/zip/META-INF/com/google/android


# Build kernel image
echo "-----------------------------------------------"
echo "Defconfig: "$KERNEL_DEFCONFIG""
if [ -z "$KSU" ]; then
    echo "KSU: N"
else
    echo "KSU: $KSU"
fi

echo "-----------------------------------------------"
echo "Building kernel using "$KERNEL_DEFCONFIG""
echo "Generating configuration file..."
echo "-----------------------------------------------"
run_command "make ${MAKE_ARGS} -j$CORES $KERNEL_DEFCONFIG extreme.config $TWRP_CONFIG $KSU 2>&1"

echo "Building kernel..."
echo "-----------------------------------------------"
run_command "make ${MAKE_ARGS} -j$CORES"

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
cp out/arch/arm64/boot/Image build/out/$MODEL

# Build dtb
echo "Building common exynos9830 Device Tree Blob Image..."
echo "-----------------------------------------------"
run_command "./toolchain/mkdtimg cfg_create build/out/$MODEL/dtb.img build/dtconfigs/exynos9830.cfg -d out/arch/arm64/boot/dts/exynos"

# Build dtbo
echo "Building Device Tree Blob Output Image for "$MODEL"..."
echo "-----------------------------------------------"
run_command "./toolchain/mkdtimg cfg_create build/out/$MODEL/dtbo.img build/dtconfigs/$MODEL.cfg -d out/arch/arm64/boot/dts/samsung"

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

    # Build zip
    echo "Building zip..."
    echo "-----------------------------------------------"
    cp build/out/$MODEL/boot.img build/out/$MODEL/zip/files/boot.img
    cp build/out/$MODEL/dtbo.img build/out/$MODEL/zip/files/dtbo.img
    cp build/update-binary build/out/$MODEL/zip/META-INF/com/google/android/update-binary
    cp build/updater-script build/out/$MODEL/zip/META-INF/com/google/android/updater-script

    version=$(grep -o 'CONFIG_LOCALVERSION="[^"]*"' arch/arm64/configs/extreme.config | cut -d '"' -f 2)
    version=${version:1}
    pushd build/out/$MODEL/zip > /dev/null
    DATE=`date +"%d-%m-%Y_%H-%M-%S"`

    if [[ $KSU_OPTION -eq "y" ]]; then
        NAME="$version"_"$MODEL"_UNOFFICIAL_KSU_"$DATE".zip
    else
        NAME="$version"_"$MODEL"_UNOFFICIAL_"$DATE".zip
    fi
    if [[ "$DEBUG" == "y" ]]; then
        zip -r ../"$NAME" .
    else
        zip -r -qq ../"$NAME" .
    fi
    popd > /dev/null
fi

popd > /dev/null
echo "Done! Output Directory: build/out/$MODEL/"
