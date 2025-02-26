#!/bin/bash

set -e  # 发生错误时终止脚本
set -u  # 变量未定义时终止脚本
set -o pipefail  # 任何管道命令失败时终止脚本

# 获取当前目录
current_dir=$(pwd)
cmake_version="4.0.0-rc2"
cmake_dir="$current_dir/cmake"
cmake_bin="$cmake_dir/bin"

# 定义 CMake 下载 URL 和安装文件
cmake_installer="cmake-${cmake_version}-linux-x86_64.sh"
cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_installer}"

# 检查是否已安装目标版本
if [[ -x "$cmake_bin/cmake" && "$($cmake_bin/cmake --version | head -n1 | awk '{print $3}')" == "$cmake_version" ]]; then
    echo "CMake $cmake_version 已安装，跳过安装步骤。"
else
    echo "正在下载并安装 CMake $cmake_version ..."

    # 下载 CMake 安装文件（如果不存在）
    if [[ ! -f "$cmake_installer" ]]; then
        wget "$cmake_url" -O "$cmake_installer"
    fi

    chmod +x "$cmake_installer"

    # 创建安装目录（如果不存在）
    mkdir -p "$cmake_dir"

    # 安装 CMake（覆盖已有版本）
    ./"$cmake_installer" --prefix="$cmake_dir" --exclude-subdir --skip-license

    echo "CMake $cmake_version 安装完成。"
fi

# 确保环境变量中包含 CMake 路径
if ! grep -qF "$cmake_bin" ~/.bashrc; then
    echo "export PATH=$cmake_bin:\$PATH" >> ~/.bashrc
    source ~/.bashrc
else
    echo "CMake 路径已存在于 ~/.bashrc，无需重复添加。"
fi

echo "CMake 安装及配置完成。"

