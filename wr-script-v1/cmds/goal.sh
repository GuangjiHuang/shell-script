#!/bin/bash
# ============================================================
# 目标管理模块 (goal.sh)
# 修复: #4 引号保护、#7 拼写
# ============================================================

cmd_goal() {
    local arg1="$1"
    local arg2="$2"
    local goal_dir="${HOME}/mygithub/goal/"
    local goal_info_src="${HOME}/opt/myscripts/vr-script/goal-info"

    # 自动创建 goal 目录结构
    if [ ! -d "${goal_dir}" ]; then
        mkdir -p "${goal_dir}"
        if [ -f "${goal_info_src}/goal.list" ]; then
            cp "${goal_info_src}/goal.list" "${goal_dir}/"
            cd "${goal_dir}" || return 1
            while IFS= read -r line; do
                if [[ "${line}" == ./* ]]; then
                    mkdir -p "${line}"
                fi
            done < "${goal_dir}/goal.list"
        fi
    fi

    case "${arg1}" in
        list)
            echo -e "\033[0;33m------ GOALS ------\033[0m"
            while IFS= read -r line; do
                if [[ "${line}" == ./* ]]; then
                    local name="${line#*/}"
                    name="${name%/}"
                    echo -e "-> \033[0;32m${name}\033[0m"
                fi
            done < "${goal_dir}/goal.list"
            echo -e "\033[0;33m-------------------\033[0m"
            ;;

        create)
            if [ -z "${arg2}" ]; then
                echo -e "\033[0;31m用法: vr goal create <名称>\033[0m" >&2
                return 1
            fi
            mkdir -p "${goal_dir}${arg2}"
            echo "./${arg2}/" >> "${goal_dir}/goal.list"
            echo "已创建目标: ${arg2}"
            ;;

        help)
            clear
            echo -e "\033[0;32m------ GOAL HELP ------\033[0m"
            echo "  list           列出所有目标"
            echo "  create <名称>  创建新目标"
            echo "  help           显示此帮助"
            echo "  <目标名>       进入指定目标目录"
            ;;

        *)
            if [ -d "${goal_dir}${arg1}" ]; then
                cd "${goal_dir}${arg1}" || return 1
                vim "${goal_dir}${arg1}"
            else
                echo -e "\033[0;31m目标不存在: ${arg1}\033[0m"
                echo "提示: 使用 \033[0;32mvr goal create <名称>\033[0m 创建"
            fi
            ;;
    esac
}
