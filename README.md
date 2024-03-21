# ExtremeKernel for Exynos 990 devices

## Features

- Linux 4.19.87
- Built with GCC 4.9 aarch64 and Clang 12
- Bypass Charging
- EroFS
- IncrementalFS
- More

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

G780F - S20 FE (4G) - r8slte


## Build instructions:

1. Properly clone repository with submodules (KernelSU and toolchains)

````git clone --recurse-submodules https://github.com/ExtremeXT/android_kernel_samsung_exynos990.git```

2. Build for your device, optionally with KSU

```./build.sh x1slte y```

# To be continued
