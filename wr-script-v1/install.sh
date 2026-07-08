#!/bin/bash

# ============================================================
# vr-script 安装脚本
# 修复: #1 路径检查、#12 正确写入 date-pointer
# ============================================================

command_name=vr
install_path="${HOME}/usr/bin"
target_dir="${HOME}/opt/myscripts/vr-script"
source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== vr-script 安装 ==="
echo "来源: ${source_dir}"
echo "目标: ${target_dir}"
echo ""

# 检查源目录是否存在
if [ ! -f "${source_dir}/vr-entry.sh" ]; then
    echo "ERROR: 找不到 vr-entry.sh，请在脚本所在目录执行。" >&2
    exit 1
fi

# 清理旧版本
if [ -d "${target_dir}" ]; then
    rm -rf "${target_dir}"
    echo "已清理旧版本: ${target_dir}"
fi

# 确保目标父目录存在 (修复 #1)
mkdir -p "$(dirname "${target_dir}")"

# 复制整个目录
cp -r "${source_dir}" "${target_dir}"
echo "已复制目录到: ${target_dir}"

# 更新 date-pointer 为今天 (修复 #12: 写入目标目录而非 cwd)
day_pointer="$(date '+%Y-%m/%m-%d')"
echo "${day_pointer}" > "${target_dir}/date-pointer.txt"
echo "date-pointer 已更新: ${day_pointer}"

# 确保安装路径存在
mkdir -p "${install_path}"

# 创建符号链接
if [ -L "${install_path}/${command_name}" ]; then
    rm "${install_path}/${command_name}"
fi
ln -s "${target_dir}/vr-entry.sh" "${install_path}/${command_name}"

# 验证
if command -v "${command_name}" &>/dev/null; then
    echo ""
    echo "安装成功！可执行文件: $(command -v "${command_name}")"
    echo "输入 'vr help' 查看帮助。"
else
    echo ""
    echo "警告: ${command_name} 未出现在 PATH 中。"
    echo "请确保 ${install_path} 在你的 PATH 环境变量中。"
fi
