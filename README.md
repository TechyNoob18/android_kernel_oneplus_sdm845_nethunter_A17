# NetHunter Kernel for OnePlus 6 / 6T (sdm845 / enchilada / fajita)

Customized Kali NetHunter kernel source optimized for Android custom ROM environments.

## Core Features
- **Modern FUSE Architecture**: Configured with proper file system support for robust, standards-compliant virtual file handling.
- **Kali NetHunter Wireless Integration**: Comprehensive wireless driver support and packet injection readiness for external USB adapters.
- **Optimized Packaging**: Streamlined distribution ensuring reliable recovery compatibility.

## Credits & Acknowledgments
This project builds upon the foundational development and open-source contributions of the OnePlus SDM845 NetHunter community:
- **EdwinMoq**: [android_kernel_oneplus_sdm845](https://github.com/EdwinMoq/android_kernel_oneplus_sdm845)
- **Loukious**: [nethunter_kernel_oneplus_sdm845](https://github.com/Loukious/nethunter_kernel_oneplus_sdm845)

## Build Instructions
```bash
export ARCH=arm64
export SUBARCH=arm64
make O=kernel-out nethunter_defconfig
make O=kernel-out -j$(nproc) CC=clang CROSS_COMPILE=aarch64-linux-gnu-
```
