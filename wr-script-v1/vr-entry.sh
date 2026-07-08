#!/bin/bash

# vr — 每日记录与自我管理工具入口
# 安装: 运行 install.sh
# 用法: vr <command> [args]

# 确定脚本实际安装目录 (原问题 #10, #12: 不依赖 pwd)
# 使用 readlink -f 跟随符号链接，解决 vr 是 symlink 时 SCRIPT_DIR 错误的问题
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

# ─── 颜色定义 (原问题 #6: 脚本内部定义，不依赖 .bashrc) ───
NOCOLOR="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
LIGHT_BLUE="\033[1;34m"
LIGHT_GREEN="\033[1;32m"
LIGHT_CYAN="\033[1;36m"

# ─── 路径常量 ───
INSTALL_DIR="${SCRIPT_DIR}"
LIB_DIR="${INSTALL_DIR}/lib"
PY_DIR="${INSTALL_DIR}/py"

# ─── 日期解析 (原问题 #2: -z 不再污染日期变量) ───
build_date_dir() {
    if [ "$2" = "-p" ]; then
        local pointer
        pointer="$(cat "${INSTALL_DIR}/date-pointer.txt")"
        if [ -z "${pointer}" ]; then
            echo -e "${RED}ERROR:${NOCOLOR} date-pointer.txt is empty!" >&2
            return 1 2>/dev/null || true
        fi
        printf '%s' "$pointer"
    elif [ "$2" = "-z" ]; then
        printf 'compress'
    else
        printf '%s' "$(date '+%Y/%Y-%m/%m-%d')"
    fi
}

DATE_DIR="$(build_date_dir "$@")"
RECORD_BASE="${HOME}/mygithub/everyday-record"
TODAY_PATH="${RECORD_BASE}/${DATE_DIR}"

# 导出 p_today 供 vim 内使用
export p_today="${TODAY_PATH}/"

# ─── 初始化每日目录 (若不存在) ───
if [ ! -d "${TODAY_PATH}" ] || [ ! -f "${TODAY_PATH}/plan.txt" ]; then
    mkdir -p "${TODAY_PATH}"
    echo "created directory: ${TODAY_PATH}"

    sep="=================================="
    ts="$(date '+%Y-%m-%d %a %X')"

    # 创建所有模板文件
    for f in plan learn code question review idea temp diary \
             code_task arrangement record; do
        printf '%s\n%s  %s\n%s\n\n' "$sep" "$ts" "$(echo "$f" | tr 'a-z' 'A-Z')" "$sep" \
            > "${TODAY_PATH}/${f}.txt"
    done

    # 打字/英语练习 (保持旧拼写 pratice 以兼容 wr-script 旧数据)
    printf '%s\n%s  %s\n%s\n\n' "$sep" "$ts" "PRATICE" "$sep" \
        > "${TODAY_PATH}/type.pratice"
    printf '%s\n%s  %s\n%s\n\n' "$sep" "$ts" "PRATICE" "$sep" \
        > "${TODAY_PATH}/English.pratice"

    # todolist 从模板复制
    sep2="--------------------------------------"
    printf '%s\n%s  TODOLIST\n%s\n' "$sep2" "$ts" "$sep2" \
        > "${TODAY_PATH}/todolist.txt"
    if [ -f "${INSTALL_DIR}/todolist/todolist.template" ]; then
        cat "${INSTALL_DIR}/todolist/todolist.template" >> "${TODAY_PATH}/todolist.txt"
    fi
    echo "${TODAY_PATH}/todolist.txt" > "${INSTALL_DIR}/todolist/date-path.txt"

    # 打字练习模板
    if [ -f "${INSTALL_DIR}/type.template" ]; then
        cat "${INSTALL_DIR}/type.template" >> "${TODAY_PATH}/type.pratice"
    fi
    echo "$sep2" >> "${TODAY_PATH}/type.pratice"

    # 创建周/月/年计划 (原问题 #17: 用 python3)
    python3 "${INSTALL_DIR}/py/plan-w-m-y.py"
fi

# ─── 命令分发 (原问题 #7: 拼写; #8: 清理废弃; #19: 帮助重组) ───
case "$1" in

    # ── 计划 ──
    plan)
        if [ "$2" = "-w" ] || [ "$2" = "-m" ] || [ "$2" = "-y" ]; then
            python3 "${INSTALL_DIR}/py/plan-w-m-y.py" "$2"
        else
            vim "${TODAY_PATH}/plan.txt"
        fi
        ;;

    # ── 日常记录 ──
    record)     vim "${TODAY_PATH}/record.txt" ;;
    arrangement)vim "${TODAY_PATH}/arrangement.txt" ;;
    temp)       vim "${TODAY_PATH}/temp.txt" ;;
    diary)      vim "${TODAY_PATH}/diary.txt" ;;
    code-task)  vim "${TODAY_PATH}/code_task.txt" ;;

    learn)
        if [ "$2" = "-z" ]; then
            vim "${RECORD_BASE}/compress/learn-a.txt"
        else
            vim "${TODAY_PATH}/learn.txt"
        fi
        ;;

    code)
        if [ "$2" = "-z" ]; then
            vim "${RECORD_BASE}/compress/code-a.txt"
        else
            vim "${TODAY_PATH}/code.txt"
        fi
        ;;

    question)
        if [ "$2" = "-z" ]; then
            vim "${RECORD_BASE}/compress/question-a.txt"
        else
            vim "${TODAY_PATH}/question.txt"
        fi
        ;;

    review)
        if [ "$2" = "-z" ]; then
            vim "${RECORD_BASE}/compress/review-a.txt"
        else
            vim "${TODAY_PATH}/review.txt"
        fi
        ;;

    idea)
        if [ "$2" = "-z" ]; then
            vim "${RECORD_BASE}/compress/idea-a.txt"
        else
            vim "${TODAY_PATH}/idea.txt"
        fi
        ;;

    # ── Todo & Score ──
    todo)
        python3 "${INSTALL_DIR}/py/todo_score.py"
        vim "${TODAY_PATH}/todolist.txt"
        ;;

    score)
        clear
        python3 "${INSTALL_DIR}/py/count_score.py" "${2:-}"
        ;;

    todo-cfg)
        cd "${INSTALL_DIR}/todolist/" || return 1 2>/dev/null || true
        vim .
        ;;

    # ── 合并 ──
    merge)
        python3 "${INSTALL_DIR}/py/merge.py"
        ;;

    all)
        vim "${RECORD_BASE}/compress/"
        ;;

    # ── 日期指针 ──
    pointer-check)
        echo -e "Pointer -> $(cat "${INSTALL_DIR}/date-pointer.txt")"
        ;;

    pointer)
        # 原问题 #11: 输入校验
        target="${2:?需要指定日期 YYYY-MM-DD}"
        shift 2
        target_dir="$(printf '%s-%s/%s-%s' "$1" "$2" "$2" "$3" 2>/dev/null)" || true
        # 更友好的解析: vr pointer YYYY-MM-DD
        if [ -n "$2" ] && [ -n "$3" ]; then
            target_dir="${2}-${3}/${3}-$4"  # 兼容旧格式 YYYY-MM-D-DD
        else
            target_dir="${target%%-*}/${target#*-}"
            target_dir="$(echo "$target" | sed 's#-\([0-9][0-9]\)$#/\1#' | sed 's#-#-#')"
            # 简化: YYYY-MM/DD-DD 格式
            IFS='-' read -r yr mo dy <<< "$target"
            if [ -n "${yr}" ] && [ -n "${mo}" ] && [ -n "${dy}" ]; then
                target_dir="${yr}/${yr}-${mo}/${mo}-${dy}"
            fi
        fi
        full_path="${RECORD_BASE}/${target_dir}"
        if [ -d "${full_path}" ]; then
            echo "${target_dir}" > "${INSTALL_DIR}/date-pointer.txt"
            echo -e "Successfully pointing to ${target_dir}"
        else
            echo -e "${RED}ERROR: ${target_dir} not found!${NOCOLOR}" >&2
        fi
        ;;

    # ── 目录跳转 ──
    go-e)
        cd "${TODAY_PATH}" || return 1 2>/dev/null || true
        echo "-> ${TODAY_PATH}"
        ;;

    go-wr)
        cd "${INSTALL_DIR}" || return 1 2>/dev/null || true
        echo "-> ${INSTALL_DIR}"
        ;;

    go-install)
        cd "${INSTALL_DIR}" || return 1 2>/dev/null || true
        echo "-> ${INSTALL_DIR}"
        ;;

    go-goal)
        cd "${HOME}/mygithub/goal/" || return 1 2>/dev/null || true
        echo "-> ${HOME}/mygithub/goal/"
        ;;

    go-config)
        # 原问题 #8 修复: 原来是 cd 到文件而不是目录
        local_path="${HOME}/mygithub/linux_basic_cfg"
        if [ -d "${local_path}" ]; then
            cd "${local_path}" || return 1 2>/dev/null || true
            echo "-> ${local_path}"
        else
            echo -e "${RED}目录不存在: ${local_path}${NOCOLOR}" >&2
        fi
        ;;

    # ── 目标管理 ──
    goal)
        # 原问题 #4: 引号保护
        source "${INSTALL_DIR}/cmds/goal.sh"
        cmd_goal "$2" "$3"
        ;;

    # ── 复制/粘贴寄存器 ──
    -c)  source "${INSTALL_DIR}/cmds/copy.sh"; cmd_copy "$@" ;;
    -v)  source "${INSTALL_DIR}/cmds/paste.sh"; cmd_paste "$@" ;;

    # ── 打字练习 ──
    type)
        # 兼容旧文件 type.pratice（拼写错误）
        _vr_type_file() {
            if [ -f "${TODAY_PATH}/type.pratice" ]; then
                printf '%s' "${TODAY_PATH}/type.pratice"
            else
                printf '%s' "${TODAY_PATH}/type.practice"
            fi
        }
        case "$2" in
            "" | "-p")
                vim "$(_vr_type_file)"
                ;;
            m)
                vim "${INSTALL_DIR}/type.template"
                ;;
            c)
                cp "${INSTALL_DIR}/type.template" \
                   "${HOME}/mygithub/shell-script/wr-script-v1/type.template"
                echo ":-> Successfully renewed type.template!"
                ;;
            renew)
                sep="=================================="
                sep2="--------------------------------------"
                ts="$(date '+%Y-%m-%d %a %X')"
                _vr_tfile="$(_vr_type_file)"
                printf '%s\n%s\n%s\n\n' "$sep" "$ts" "$sep" > "${_vr_tfile}"
                cat "${INSTALL_DIR}/type.template" >> "${_vr_tfile}"
                echo "$sep2" >> "${_vr_tfile}"
                echo ":-> Has been renewed ${_vr_tfile}"
                [ "$3" = "o" ] && vim "${_vr_tfile}"
                ;;
            *)
                echo -e "${RED}Error: unknown sub-command 'vr type $2'${NOCOLOR}" >&2
                ;;
        esac
        unset -f _vr_type_file
        ;;

    # ── 英语练习 ──
    English)
        if [ -f "${TODAY_PATH}/English.pratice" ]; then
            vim "${TODAY_PATH}/English.pratice"
        else
            vim "${TODAY_PATH}/English.practice"
        fi
        ;;

    # ── 娱乐 ──
    rest)
        source "${INSTALL_DIR}/font/rest.sh"
        ;;

    year)
        source "${INSTALL_DIR}/font/year.sh"
        ;;

    moyu)
        source "${INSTALL_DIR}/font/moyu.sh"
        ;;

    xiaban)
        vr merge
        cd "${HOME}/mygithub/everyday-record/" || return 1 2>/dev/null || true
        if [ -f "xiaban.sh" ]; then
            source ./xiaban.sh
        else
            echo "xiaban.sh not found, merge done."
        fi
        ;;

    weather)
        duration="${2:-10}"
        count="${3:-10}"
        for ((i = 1; i < count; i++)); do
            clear
            bash "${INSTALL_DIR}/weather/show-weather.sh"
            sleep "$duration"
        done
        ;;

    rain)
        case "${2:-}" in
            1) TERM=xterm-256color unimatrix -n -s 96 -l "q" ;;
            2) TERM=xterm-256color unimatrix -n -c blue -l "q" ;;
            3) TERM=xterm-256color unimatrix -c yellow -l "e" ;;
            *) TERM=xterm-256color unimatrix -n -c blue -s 66 -l "o" ;;
        esac
        ;;

    fish)
        if [ "$(uname -o)" = "Cygwin" ]; then
            echo "------ No Fish ------"
        else
            asciiquarium
        fi
        ;;

    pretend)
        if [ -f "${INSTALL_DIR}/c++-interesting-program/pretend-to-do-something.exe" ]; then
            "${INSTALL_DIR}/c++-interesting-program/pretend-to-do-something.exe" "$2" "$3" "$4"
        else
            echo "pretend program not found, skip."
        fi
        ;;

    vr)
        vim "${INSTALL_DIR}/vr-entry.sh"
        ;;

    reinstall)
        cd "${HOME}/mygithub/shell-script/wr-script-v1/" || return 1 2>/dev/null || true
        bash ./install.sh && echo "----------------- reinstall successfully --------------------"
        ;;

    # ── 快捷键 ──
    -)
        vim "${HOME}/mygithub/goal/paper/determine_title_report.ddl"
        ;;

    # ── 帮助 (原问题 #19: 重组格式) ──
    help)
        clear
        echo -e "${YELLOW}============================ vr HELP ============================${NOCOLOR}"
        echo
        echo -e "  ${GREEN}[记录]${NOCOLOR}"
        echo "    plan [-w|-m|-y]  日/周/月/年计划"
        echo "    learn [-z]       学习笔记 (-z=合并版)"
        echo "    code [-z]        代码记录"
        echo "    question [-z]    问题收集"
        echo "    review [-z]      复习回顾"
        echo "    idea [-z]        想法灵感"
        echo "    temp             临时笔记"
        echo "    diary            日记"
        echo "    code-task        代码任务"
        echo "    record           时间记录"
        echo "    arrangement      时间安排"
        echo
        echo -e "  ${GREEN}[任务]${NOCOLOR}"
        echo "    todo             待办清单(自动计分)"
        echo "    score [YYYY-MM-DD]  查看评分"
        echo "    todo-cfg         编辑 todo 配置"
        echo "    merge            合并到 compress"
        echo
        echo -e "  ${GREEN}[导航]${NOCOLOR}"
        echo "    go-e             跳到今日记录目录"
        echo "    go-wr            跳到脚本目录"
        echo "    go-goal          跳到目标目录"
        echo "    go-config        跳到配置目录"
        echo "    pointer Y-M-D    设置日期指针"
        echo "    pointer-check    查看当前指针"
        echo
        echo -e "  ${GREEN}[目标]${NOCOLOR}"
        echo "    goal list        列出所有目标"
        echo "    goal create XXX  创建新目标"
        echo "    goal XXX         进入目标"
        echo
        echo -e "  ${GREEN}[剪贴板]${NOCOLOR}"
        echo "    -c [a-z]         复制路径到寄存器"
        echo "    -v [a-z] [go]    粘贴路径 (go=跳转)"
        echo "    -c/-v help       详细说明"
        echo
        echo -e "  ${GREEN}[打字]${NOCOLOR}"
        echo "    type             打开今日练习"
        echo "    type m           编辑模板"
        echo "    type renew [o]   用模板刷新今日练习"
        echo "    English          英语练习"
        echo
        echo -e "  ${GREEN}[娱乐]${NOCOLOR}"
        echo "    weather [N]      循环显示天气(N秒)"
        echo "    rain [1-3]       Matrix 屏保"
        echo "    fish             鱼缸屏保"
        echo "    rest / year / moyu  ASCII 艺术"
        echo
        echo -e "  ${GREEN}[其他]${NOCOLOR}"
 "    xiaban           合并+上传+下班"
        echo "    all              打开 compress 目录"
        echo "    reinstall        重新安装"
        echo "    vr               编辑入口脚本"
        echo
        echo -e "${YELLOW}================================================================${NOCOLOR}"
        ;;

    # ── 未知命令 ── (原问题 #20: 友好提示)
    *)
        echo -e "${RED}未知命令: vr $1${NOCOLOR}" >&2
        echo -e "${GREEN}使用 vr help 查看所有命令${NOCOLOR}" >&2
        return 1 2>/dev/null || true
        ;;
esac
