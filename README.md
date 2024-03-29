# ExtremeKernel for Exynos 990 devices

## Features

- Linux 4.19.87
- OneUI 5.1 and OneUI 6.0 support
- Supports all Exynos 990 devices
- Compiled with aarch64 GCC 4.1 and Clang 12 compilers
- Optional KernelSU (version 11682) with hiding mechanisms proted from GKI kernels
- Based on the latest Samsung source for Exynos 990
- Fixed all compilation warnings and some Samsung bugs
- Disabled Samsung's anti-rooting protection
- Disabled some useless logging functions
- Enabled all TCP Scheduling Algorithms, CPU Governors and I/O Schedulers available in the source
- SELinux Enforcing
- Boeffla Wakelock Blocker support with a decent default list
- Wireguard support
- Charging Bypass support
- LZ4 ZRAM compression by default
- Backported the Timer Events Oriented (TEO) Governor from 5.x kernel
- Backported VDSO from upstream 4.19-stable kernel
- Backported latest LZ4 1.9.4 module with ARM64v8 optimizations
- Backported IncrementalFS (https://source.android.com/docs/core/architecture/kernel/incfs) from latest 4.19-stable (Requires ROM support)
- Backported FUSE Passthrough (Requires ROM support)
- Backported EroFS driver from 5.10 with some extra tweaks
- Various network optimizations and touch latency tweaks
- Various stability/optimization backports from newer Android kernel versions
- Various general architecture patches, CPU improvements, memory management improvements etc
- Easy to modify and compile for developers
- Optimized for a balance between performance, battery life and low thermals
- Fully open source with a clean commit history

## Supported devices:

G980F - S20 4G - x1slte

G981B - S20 5G - x1s

G985F - S20+ 4G - y2slte

G986B - S20+ 5G - y2s

G988B - S20 Ultra (5G) - z3s

N980F - Note 20 4G - c1slte

N981B - Note 20 5G - c1s

N985F - Note 20 Ultra 4G - c2slte

N986B - Note 20 Ultra 5G - c2s

G780F - S20 FE (4G) - r8s


## Build instructions:

1. Set up build environment as per Google documentation

https://source.android.com/docs/setup/start/requirements

* The `gcc-aarch64-linux-gnu` and `ccache` packages are also necessary

2. Properly clone repository with submodules (KernelSU and toolchains)

```git clone --recurse-submodules https://github.com/ExtremeXT/android_kernel_samsung_exynos990.git```

3. Build for your device, optionally with KSU

```./build.sh x1slte y```

4. Fetch the flashable zip of the kernel that was just compiled

```build/out/[your_device]/ExtremeKernel...zip```

# To be continued
