#!/bin/bash

rm -rf out
mkdir out
mkdir out/G980F out/G981B out/G985F out/G986B out/G988B out/N981B out/N980F out/N985F out/N986B
./toolchain/mkdtimg cfg_create out/dtb.img dtconfigs/exynos9830.cfg -d arch/arm64/boot/dts/exynos
./toolchain/mkdtimg cfg_create out/G980F/dtbo.img dtconfigs/x1slte.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/G981B/dtbo.img dtconfigs/x1s.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/G985F/dtbo.img dtconfigs/y2slte.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/G986B/dtbo.img dtconfigs/y2s.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/G988B/dtbo.img dtconfigs/z3s.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/N981B/dtbo.img dtconfigs/c1s.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/N980F/dtbo.img dtconfigs/c1slte.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/N986B/dtbo.img dtconfigs/c2s.cfg -d arch/arm64/boot/dts/samsung
./toolchain/mkdtimg cfg_create out/N985F/dtbo.img dtconfigs/c2slte.cfg -d arch/arm64/boot/dts/samsung
