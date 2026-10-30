#!/bin/bash

KERNEL_DIR=$(pwd)
TC_DIR="$HOME/toolchains/neutron-clang"
OUT="$HOME/enchilada/kernel-out"
DEFCONFIG="nethunter_defconfig"

# ── Toolchain check ───────────────────────────────────────────────
if [ ! -d "$TC_DIR" ]; then
    echo "$TC_DIR not found! Setting it up..."
    mkdir -p "$TC_DIR"
    cd "$TC_DIR"
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") -S=10032024
    bash <(curl -s "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman") --patch=glibc
    cd "$KERNEL_DIR"
else
    echo "$TC_DIR found!"
fi

# ── Environment ───────────────────────────────────────────────────
SECONDS=0

export PATH="$TC_DIR/bin:$PATH"
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export KBUILD_COMPILER_STRING="$($TC_DIR/bin/clang --version | head -n1 | sed 's/.*clang/clang/')"

MAKE_PARAMS=(
    O="$OUT"
    ARCH=arm64
    CC="ccache clang"
    CXX="ccache clang++"
    HOSTCC="ccache clang"
    HOSTCXX="ccache clang++"
    LD=ld.lld
    AR=llvm-ar
    AS=llvm-as
    NM=llvm-nm
    OBJCOPY=llvm-objcopy
    OBJDUMP=llvm-objdump
    STRIP=llvm-strip
    CROSS_COMPILE="aarch64-linux-gnu-"
    CROSS_COMPILE_ARM32="arm-linux-gnueabi-"
    KBUILD_BUILD_USER="Loukious"
    KBUILD_BUILD_HOST="github"
    KCFLAGS="-Wno-error=fortify-source -Wno-error=enum-conversion -Wno-error=varargs -Wno-error=parentheses-equality -Wno-error=constant-conversion -Wno-error=pragma-pack"
)

# ── Clean ─────────────────────────────────────────────────────────
echo "Cleaning output directory..."
rm -rf "$OUT"
mkdir -p "$OUT"

# ── Build ─────────────────────────────────────────────────────────
echo "Applying defconfig: $DEFCONFIG"
make -j$(nproc) "${MAKE_PARAMS[@]}" $DEFCONFIG

echo "Starting compilation..."
make -j$(nproc) "${MAKE_PARAMS[@]}" Image.gz-dtb

# ── Output ────────────────────────────────────────────────────────
IMAGE="$OUT/arch/arm64/boot/Image.gz-dtb"

if [ -f "$IMAGE" ]; then
    echo -e "\nKernel compiled successfully!"
    echo "Completed in $((SECONDS / 60))m $((SECONDS % 60))s"
    echo "Output: $IMAGE"
else
    echo -e "\nBuild failed! Check the logs above."
    exit 1
fi