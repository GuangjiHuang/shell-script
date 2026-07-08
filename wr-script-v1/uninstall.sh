#!/bin/bash

# ============================================================
# vr-script 卸载脚本
# ============================================================

target_dir="${HOME}/opt/myscripts/vr-script"
link_path="${HOME}/usr/bin/vr"

echo "=== vr-script 卸载 ==="

# 删除符号链接
if [ -L "${link_path}" ]; then
    rm "${link_path}"
    echo "已删除链接: ${link_path}"
else
    echo "链接不存在: ${link_path}"
fi

# 删除安装目录
if [ -d "${target_dir}" ]; then
    rm -rf "${target_dir}"
    echo "已删除目录: ${target_dir}"
else
    echo "目录不存在: ${target_dir}"
fi

echo "卸载完成。"
