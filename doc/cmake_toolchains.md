# CMake 工具链

- [CMake 工具链](#cmake-工具链)
  - [0. 学习目标](#0-学习目标)
  - [1. 什么是工具链？](#1-什么是工具链)
  - [2. 为什么需要工具链？](#2-为什么需要工具链)
  - [3. 编写 CMake 工具链脚本](#3-编写-cmake-工具链脚本)
  - [4. sysroot](#4-sysroot)
  - [5. 跨平台构建](#5-跨平台构建)
  - [6. 制作 sysroot](#6-制作-sysroot)

## 0. 学习目标
1. 什么是工具链？
2. 为什么需要工具链？
3. 编写 CMake 工具链脚本
4. sysroot
5. 跨平台构建

## 1. 什么是工具链？
CMake 编译、链接、归档等都需要使用工具链，同时 CMake 还使用工具链驱动构建其它任务。对于只在本地构建和运行程序的开发人员来说，可能对 CMake 工具链的存在感没有那么强。这是因为在本地编译和运行，只需要我们安装了相应的编译工具，比如 gcc + make，CMake 就能自动找到它们，其实它们就是工具链的一部分。

但是当我们需要交叉编译的时候，如果我们不告诉 CMake 我们需要构建什么平台运行的程序，以及构建这些平台运行的程序所需要的编译工具和依赖的头文件和库文件等，CMake 就不知道该如何帮我们构建项目了。所以这个时候就是工具链该出场的时候了。

通常 CMake 的工具链是一个以 .cmake 结尾的 CMake 脚本文件，我们在这个 CMake 脚本文件中描述工具链的信息，这样，只要我们告诉 CMake 这个脚本文件，CMake 就能读取其中的信息，进行后续的编译构建工作。

那工具链具体包含什么呢？其实除了我们常接触的编译器、链接器，头文件和库文件等均是工具链的组成部分。

对于本地编译构建的项目，CMake 是有默认的工具链的，这个默认的工具链的信息由 CMake 的 project() 命令中的 LANGUAGES 字段决定。

比如下面的 project() 命令：
```CMake
project(study_cmake
    VERSION         0.0.1
    DESCRIPTION     "Eglinux's cmake study repo"
    HOMEPAGE_URL    "公众号: eglinux"
    LANGUAGES       CXX
)
```
我们在 project() 命令中使用 LANGUAGES 字段制定本项目使用的语言是 C++，这个时候，CMake 就会根据给定的工具链文件或者自动探测本地环境，给相应的变量赋值，比如下面这些变量：

```CMake
CMAKE_CXX_COMPILER
CMAKE_CXX_COMPILER_ID
CMAKE_CXX_COMPILER_VERSION
CMAKE_CXX_FLAGS
```

## 2. 为什么需要工具链？
对于永远只在本地编译构建，运行的平台也和本地平台一样的开发者来说，其实并不用关系工具链，也不需要知道工具链的存在，因为只要安装好了编译工具，配置好编译环境，CMake 就可以自动完成工具链的探测。

但是有跨平台编译构建需求时，工具链就显得尤为重要。比如，没有工具链，我们就不能在 x86 平台上构建运行于 arm 平台的程序。

当然你可能会说，那我们直接到 arm 平台上编译构建不就可以了。听起来很不错，但是并不是一切都那么顺利，首先目标平台得有足够的性能做编译构建，其次还要有对应的编译构建工具。光搭建构建环境我想就能难倒很大一部分人。

但是使用工具链就不一样，我们可以在性能优越的机器上，比如 x86 平台上，使用工具链指定我们的目标平台，然后进行交叉编译。

## 3. 编写 CMake 工具链脚本
看一个简单的 arm linux 的 CMake 工具链脚本文件的例子:
```CMake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_SYSROOT /home/devel/rasp-pi-rootfs)
set(CMAKE_STAGING_PREFIX /home/devel/stage)

set(tools /home/devel/gcc-4.7-linaro-rpi-gnueabihf)
set(CMAKE_C_COMPILER ${tools}/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${tools}/bin/arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
```

- CMAKE_SYSTEM_NAME
  - 指定目标平台
- CMAKE_SYSTEM_PROCESSOR
  - 指定目标平台架构
- CMAKE_SYSROOT
  - 可选，指定 [sysroot](#4-sysroot)
- CMAKE_STAGING_PREFIX
  - 可选，可用于指定安装路径，如果没有这个，将安装到 sysroot，这是我们不愿意看到的。
- ```CMAKE_<LANG>_COMPILER```
  - 编译器的名字或者完整路径

对于交叉编译时，需要运行的程序都应该只在本地机器上寻找，对于包含的头文件，库文件等则需要到 [sysroot](#4-sysroot) 中寻找。这就是本例最后四个变量的含义。

其实这些都是一些 CMake 预先定义好的变量名字，我们只需要填相应的值即可，不过对于 [sysroot](#4-sysroot) 还是比较麻烦，这可能需要我们自己去定制制作能满足自己需求的 [sysroot](#4-sysroot)。见下一节。

需要注意的是 CMake 工具链文件应该尽量小，只需要提供必要信息，不要包含逻辑处理，更不要假设该工具链文件只在项目的顶级目录使用，CMake 工具链文件应该支持多次包含，鉴于此，下面我列出 CMake 工具链需要做的主要事情：
- 描述目标系统的基础信息
  - CMAKE_SYSTEM_NAME
    - Linux, Windows, QNX, Android or Darwin
  - CMAKE_SYSTEM_PROCESSOR
  - CMAKE_SYSTEM_VERSION
- 提供工具路径，通常只需要提供编译器路径
  - ```CMAKE_<LANG>_COMPILER```
- 设置默认 flags，通常只设置编译器和链接器的 flags
- 如果是交叉编译，设置 sysroot


## 4. sysroot
sysroot 可以简单的理解成一个系统的根目录下的所有东西，但是作为一个系统，通常安装了很多应用软件，所以根目录下所有文件通常很大。

在 CMake 交叉编译需要指定 sysroot 的时候，最简单直接的方式就是将目标系统的根目录挂在到编译主机的某个目录，然后作为 sysroot 使用。

不过这种方式对于需要跨团队协作的时候很不方便，因为大家不一定都有相同的目标机器可供挂载目录。所以更通用的方式是自己定制制作一个只包含必要头文件和库文件的 sysroot，然后将其作为一个文件夹共享。

也就是说 sysroot 其实就是包含编译链接的时候需要的必要头文件和库文件的集合。

## 5. 跨平台构建
- 使用自己的工具链
  ```bash
  # -D 形式
  cmake -DCMAKE_TOOLCHAIN_FILE=myToolchain.cmake path/to/source

  # cmake 3.21 开始支持
  cmake --toolchain myToolchain.cmake path/to/source

  # 环境变量
  export CMAKE_TOOLCHAIN_FILE=myToolchain.cmake
  ```

## 6. 制作 sysroot
本节只演示如何制作 arm 平台的 ubuntu 22.04 sysrot。
- 安装 ubuntu 22.04 虚拟机（略）
- 安装制作 sysroot 必要的软件
  ```shell
  sudo apt update
  sudo apt upgrade -y

  sudo apt install automake bc binfmt-support cmake dpkg-dev
  sudo apt install libelf-dev libncurses5-dev libssl-dev
  sudo apt install mesa-common-dev opencl-headers perl qemu
  sudo apt install qemu-user-static texinfo wget xutils-dev
  sudo apt install autopoint gperf intltool libglib2.0-dev
  sudo apt install libltdl-dev libtool python3-libxml2 python3-mako
  sudo apt install xfonts-utils xsltproc x11-xkb-utils
  ```

- 开始制作 sysroot
  ```shell
  mkdir ubuntu-arm-sysroot
  wget http://cdimage.ubuntu.com/ubuntu-base/releases/22.04/release/ubuntu-base-22.04.1-base-arm64.tar.gz
  cd ubuntu-arm-sysroot
  tar -xvf ../ubuntu-base-22.04.1-base-arm64.tar.gz
  cp /etc/resolv.conf etc/
  cp /usr/bin/qemu-aarch64-static usr/bin/
  cp /usr/bin/qemu-arm-static usr/bin/
  # 这里需要手动将 etc/apt/sources.list 中的源加上 [trusted=yes]
  cd ../

  sudo chroot ubuntu-arm-sysroot
  apt update
  apt upgrade -y

  apt-get install locales
  locale-gen en_GB.UTF-8
  dpkg-reconfigure -f noninteractive locales
  dpkg --add-architecture armhf
  apt update
  apt dist-upgrade -y
  # 在这里安装你所需要的库
  # 例如 apt install libstdc++-9-dev:armhf symlinks
  symlinks -cr /lib /usr/lib
  apt clean
  exit
  ```

- 从 sysroot 创建一个根文件系统
  ```shell
  # 安装以下软件包，以使得 systemd 作为 init 进程启动
  apt install cgpt init linux-firmware ubuntu-minimal
  apt install network-manager net-tools openssh-server rsync

  # 启用 ssh 可以使用 root 用户登陆
  sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' > etc/ssh/sshd_config
  echo ’root:eg’ | chpasswd

  # 可选：创建用户
  useradd eg -m -s /bin/bash
  usermod -a -G sudo eg
  echo ’eg:eg’ | chpasswd

  # 启用 DHCP
  ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
  ln -s /dev/null /etc/udev/rules.d/80-net-setup-slot.rules
  cat <<EOF > /etc/netplan/99_config.yaml
  > network:
  >     version: 2
  >     renderer: NetworkManager
  >     ethernets:
  >         eth0:
  >             optional: true
  >             dhcp4: true
  EOF

  # 清理退出
  symlinks -cr /lib /usr/lib
  apt clean
  exit
  ```
