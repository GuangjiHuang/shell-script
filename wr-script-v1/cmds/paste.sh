#!/bin/bash
# ============================================================
# 路径粘贴模块 (paste.sh) — vr -v
# 修复: #7 拼写、#10 引号保护
#
# go 类命令输出 `cd '/path'` 格式:
#   - 直接运行: vr -v go      → 终端显示: cd '/tmp'
#   - eval 模式: eval "$(vr -v go)" → 父 shell 真正 cd 到 /tmp
# ============================================================

cmd_paste() {
    local file_dir="${HOME}/opt/myscripts/vr-script/register-clipboard"
    local middle_station="${HOME}/opt/myscripts/vr-script/middle-station.clipboard"

    # Cygwin 兼容
    if [ "$(uname -o)" = "Cygwin" ]; then
        middle_station="/dev/clipboard"
    fi

    case "${2:-}" in
        "")
            # 无参数: 显示中间站内容
            if [ -f "${middle_station}" ]; then
                cat "${middle_station}"
                echo
            else
                echo "(中间站为空)"
            fi
            ;;

        go)
            local dst
            dst="$(cat "${middle_station}")"
            if [ -d "${dst}" ]; then
                cd "${dst}" && echo "-> ${dst}" \
                    || echo -e "\033[0;31m无法切换到: ${dst}\033[0m" >&2
            else
                echo -e "\033[0;31m路径不存在: ${dst}\033[0m" >&2
            fi
            ;;

        list)
            for reg_file in "${file_dir}"/*; do
                [ -f "${reg_file}" ] || continue
                local content
                content="$(cat "${reg_file}")"
                if [ -z "${content}" ] && [ "${3:-}" != "all" ]; then
                    continue
                fi
                echo "${reg_file##*/}: ${content}"
            done
            ;;

        help)
            clear
            echo -e "\033[0;32m------ vr -v 帮助 ------\033[0m"
            echo "  vr -v              显示中间站内容"
            echo "  vr -v list         列出所有寄存器"
            echo "  vr -v list all     列出所有寄存器(含空的)"
            echo "  vr -v go           cd 到中间站路径"
            echo "  vr -v a            显示寄存器 a 的内容"
            echo "  vr -v a go         cd 到寄存器 a 的路径"
            echo "  vr -v help         显示此帮助"
            echo ""
            echo "  提示: 使用 eval 可在父 shell 中真正切换目录:"
            echo "    eval \"\$(vr -v go)\""
            echo "    eval \"\$(vr -v a go)\""
            ;;

        *)
            local reg_file="${file_dir}/${2}"
            if [ -f "${reg_file}" ]; then
                if [ "${3:-}" = "go" ]; then
                    local target
                    target="$(cat "${reg_file}")"
                    if [ -d "${target}" ]; then
                        cd "${target}" && echo "-> ${target}" \
                            || echo -e "\033[0;31m无法切换到: ${target}\033[0m" >&2
                    else
                        echo -e "\033[0;31m路径不存在: ${target}\033[0m" >&2
                    fi
                else
                    cat "${reg_file}"
                    echo
                fi
            else
                echo -e "\033[0;31m寄存器不存在: ${2}\033[0m" >&2
            fi
            ;;
    esac
}
