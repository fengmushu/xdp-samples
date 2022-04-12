
# USE OpenWRT for eBPF+XDP

OpenWRT 编译环境支持 bpftool, 需开启 LLVM 工具链

<!-- PROJECT SHIELDS -->

[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->

```bash
# openwrt 配置
make menuconfig

CONFIG_PACKAGE_bpftool-full
CONFIG_BPF_TOOLCHAIN_BUILD_LLVM=y

# linux 配置
make kernel_menuconfig

CONFIG_DEBUG_INFO_BTF=y
```

#### 安装 LLVM 到 $LLVM_DIR, 导出环境变量

1. OpenWRT 生成LLVM工具链:  bin/\${ARCH}/llvm-bpf-13.0.0.Linux-x86_64.tar.xz
2. 解压安装到: $(LLVM_DIR), 如: /opt/llvm-bpf
3. export 安装路径到环境变量文件 env.rc
4. 终端重连后, 需 source env.rc 初始化环境变量

##### 示例: env.rc
```
LLVM_DIR="/opt/llvm-bpf"
OPENWRT_DIR="/home/mice/openwrt"

export KERNELSRC_DIR="${OPENWRT_DIR}/kernel"
export STAGING_DIR="${OPENWRT_DIR}/staging_dir/target-aarch64_cortex-a53_musl"
export TOOLCHAIN_DIR="${OPENWRT_DIR}/staging_dir/toolchain-aarch64_cortex-a53_gcc-11.2.0_musl"

export ARCH=arm64
export CROSS_COMPILE="aarch64-openwrt-linux-"
export PATH=$PATH:${LLVM_DIR}/bin:${TOOLCHAIN_DIR}/bin
```

#### 编辑 Programs.mk 新增 app
``` makefile
# 例如: xdp_router_ipv4

# List of programs to build
# 应用层 app 列表
tprogs-y := xdp_router_ipv4

# List of programs ref source
# app 所需源码引用
xdp_router_ipv4-objs := xdp_router_ipv4_user.o

# Tell kbuild to always build the programs
# app 所需内核加载文件
always-y := $(tprogs-y)
always-y += xdp_router_ipv4_kern.o

```

#### 内核自带 例程

kernel/samples/bpf


#### FAQ

- BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
	- apt-get install dwarves


<!-- links -->
[your-project-path]:fengmushu/xdp-samples.git

[issues-shield]: https://img.shields.io/badge/issues-0-red.svg?style=flat-square
[issues-url]: https://github.com/fengmushu/xdp-samples/issues

[license-shield]: https://img.shields.io/badge/license-MIT-green.svg?style=flat-square
[license-url]: https://github.com/fengmushu/xdp-samples/blob/master/LICENSE.txt
