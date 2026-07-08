#!/usr/bin/env python3
"""
count_score.py — 计算并显示综合评分
修复: #3  硬编码 Cygwin 路径 → 基于 RECORD_BASE 动态查找
     #14 使用共享库
"""

import os
import sys
import time

script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)
from vr_score_lib import (
    color, rank_label,
    get_todolist_score,
    get_record_score,
    get_arragement_score,
    get_question_and_learn_score,
)

# 颜色
_NO = "\033[0m"
_LIGHT_RED = "\033[1;31m"
_YELLOW = "\033[1;33m"
_LIGHT_BLUE = "\033[1;34m"
_LIGHT_GREEN = "\033[1;32m"
_LIGHT_CYAN = "\033[1;36m"

if __name__ == "__main__":
    # ─── 日期解析 ───
    if len(sys.argv) > 1:
        try:
            parts = sys.argv[1].split("-")
            year, month, day = int(parts[0]), int(parts[1]), int(parts[2])
            date_str = f"{year:04}-{month:02}/{month:02}-{day:02}"
            ymd = f"{year:04}-{month:02}-{day:02}"
        except (ValueError, IndexError):
            print(f"日期格式错误: {sys.argv[1]} (需为 YYYY-MM-DD)", file=sys.stderr)
            sys.exit(1)
    else:
        date_str = time.strftime("%Y-%m/%m-%d")
        ymd = time.strftime("%Y-%m-%d")

    base = os.path.join(os.path.expanduser("~"), "mygithub/everyday-record")

    # ─── 路径 (修复 #3: 不再硬编码 /cygdrive/c/...) ───
    question_dir = os.path.join(base, date_str)
    todolist_path = os.path.join(base, date_str, "todolist.txt")

    # arrangement 和 record 从两个可能位置查找
    possible_arragement = [
        os.path.join(base, date_str, "plan.txt"),             # 新位置
        os.path.join(base, "study-app", date_str, "plan.txt"),  # 旧位置
    ]
    possible_record = [
        os.path.join(base, date_str, "record.txt"),
        os.path.join(base, "study-app", date_str, "record.txt"),
    ]

    arragement_path = None
    for p in possible_arragement:
        if os.path.exists(p):
            arragement_path = p
            break

    record_path = None
    for p in possible_record:
        if os.path.exists(p):
            record_path = p
            break

    # ─── 计算各项分数 ───
    q_l_score = get_question_and_learn_score(question_dir)
    arragement_score = get_arragement_score(arragement_path) if arragement_path else 0
    record_score = get_record_score(record_path) if record_path else 0
    todolist_score = get_todolist_score(todolist_path)

    # ─── 加权总分 ───
    weights = [0.4, 0.2, 0.2, 0.2]
    total = int(
        arragement_score * weights[0]
        + record_score * weights[1]
        + todolist_score * weights[2]
        + q_l_score * weights[3]
    )

    # ─── 写回 score.txt ───
    score_path = os.path.join(base, date_str, "score.txt")
    os.makedirs(os.path.dirname(score_path), exist_ok=True)
    with open(score_path, "w", encoding="utf-8") as f:
        f.write(str(total))

    # ─── 显示 ───
    line_len = 65
    sep = "-" * line_len
    print(f"{'':─^{line_len}}")
    print(f"{' Performance  ({ymd})':^{line_len}}")
    print(f"{'':─^{line_len}}")
    print()
    print(f"  等级: BAD (0~59) | NICE (60~79) | GOOD (80~89) | EXCELLENT (90~100)")
    print()

    items = [
        ("TOTAL SCORE", total),
        ("arrangement", arragement_score),
        ("record", record_score),
        ("todolist", todolist_score),
        ("question & learn", q_l_score),
    ]

    for name, score in items:
        is_total = name == "TOTAL SCORE"
        label = f"\033[46;31m{name}\033[0m" if is_total else name
        print(f"  {label:<22}:    {score:3}  {rank_label(score)}")
        print()

    print(sep)
