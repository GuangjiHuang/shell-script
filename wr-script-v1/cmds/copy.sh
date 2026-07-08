#!/bin/bash
# ============================================================
# 路径复制模块 (copy.sh) — vr -c
# 对照原版 copy_sth() 的行为：
#   wr -c        → 当前路径 → 中间站
#   wr -c a      → 当前路径 → 寄存器 a (同步源码目录)
#   wr -c a -    → 寄存器 a → 中间站
#   wr -c a b    → 寄存器 a → 寄存器 b
#   wr -c - a    → 中间站   → 寄存器 a
# 修复: #7 拼写、#10 引号保护
# ============================================================

cmd_copy() {
    local file_dir="${HOME}/opt/myscripts/vr-script/register-clipboard"
    local file_dir_source="${HOME}/mygithub/shell-script/wr-script-v1/register-clipboard"
    local middle_station="${HOME}/opt/myscripts/vr-script/middle-station.clipboard"

    # Cygwin 兼容
    if [ "$(uname -o)" = "Cygwin" ]; then
        middle_station="/dev/clipboard"
    fi

    # 确保寄存器目录存在
    mkdir -p "${file_dir}"

    if [ -z "${2:-}" ]; then
        # vr -c: 当前路径 → 中间站
        pwd | tr -d '\n' > "${middle_station}"
        return
    fi

    case "$2" in
        help)
            clear
            echo -e "\033[0;32m------ vr -c 帮助 ------\033[0m"
            echo "  (无参数)       复制当前路径到中间站"
            echo "  [a-z]          复制当前路径到寄存器 [a-z]"
            echo "  [a-z] -        寄存器 [a-z] → 中间站"
            echo "  [a-z] [a-z]    寄存器 → 寄存器"
            echo "  - [a-z]        中间站 → 寄存器 [a-z]"
            echo "  help           显示此帮助"
            ;;
        -)
            # vr -c -: 当前路径 → 中间站 (原版行为)
            if [ -z "${3:-}" ]; then
                pwd | tr -d '\n' > "${middle_station}"
            elif [[ "${3}" =~ ^[a-z]$ ]]; then
                # vr -c - a: 中间站 → 寄存器 a
                if [ -f "${middle_station}" ]; then
                    cat "${middle_station}" > "${file_dir}/${3}"
                else
                    echo "中间站为空" >&2
                fi
            else
                echo "第三个参数必须是 a-z 的寄存器名" >&2
            fi
            ;;
        *)
            # vr -c <寄存器名>: 先检查寄存器名合法性
            if [[ ! "${2}" =~ ^[a-z]$ ]]; then
                echo -e "\033[0;31m参数必须是 a-z 的寄存器名\033[0m" >&2
                return 1
            fi

            local src_file="${file_dir}/${2}"
            local src_file_orig="${file_dir_source}/${2}"

            # 原版逻辑: [ -f $file_path ] || [ "$2" == "-" ]
            # 这里 $2 != "-", 所以必须寄存器文件存在才能继续
            if [ -f "${src_file}" ]; then
                if [ -z "${3:-}" ]; then
                    # vr -c a: 当前路径 → 寄存器 a
                    pwd | tr -d '\n' > "${src_file}"
                    # 同步到源码目录(如果存在)
                    if [ -f "${src_file_orig}" ]; then
                        pwd | tr -d '\n' > "${src_file_orig}"
                    fi
                elif [ "${3}" = "-" ]; then
                    # vr -c a -: 寄存器 a → 中间站
                    cat "${src_file}" > "${middle_station}"
                else
                    # vr -c a b: 寄存器 a → 寄存器 b
                    if [[ ! "${3}" =~ ^[a-z]$ ]]; then
                        echo -e "\033[0;31m第三个参数必须是 a-z 的寄存器名\033[0m" >&2
                        return 1
                    fi
                    cat "${src_file}" > "${file_dir}/${3}"
                fi
            else
                echo "寄存器 ${2} 不存在，请先使用 'vr -c ${2}' 创建" >&2
            fi
            ;;
    esac
}
