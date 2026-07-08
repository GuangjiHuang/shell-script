#!/usr/bin/env python3
"""
vr_score_lib.py — 评分系统共享工具库
修复: #14 消除 todo_score.py 和 count_score.py 中的重复代码
"""

import os
import re

# ─── 颜色 ───
_NO_COLOR = "\033[0m"
_LIGHT_RED = "\033[1;31m"
_YELLOW = "\033[1;33m"
_LIGHT_BLUE = "\033[1;34m"
_LIGHT_GREEN = "\033[1;32m"


def color(code, text):
    return f"{code}{text}{_NO_COLOR}"


def rank_label(score):
    """根据分数返回排名标签 (带颜色)"""
    if score < 60:
        return color(_LIGHT_RED, "BAD")
    elif score < 80:
        return color(_YELLOW, "NICE")
    elif score < 90:
        return color(_LIGHT_BLUE, "GOOD")
    else:
        return color(_LIGHT_GREEN, "EXCELLENT")


def extract_line_number(line):
    """从行首提取数字编号 (例如 '(y) 3. xxx # 5' → '3')"""
    for i, ch in enumerate(line):
        if ch.isdigit():
            break
    else:
        return "0"
    num = 0
    while i < len(line) and line[i].isdigit():
        num = num * 10 + int(line[i])
        i += 1
    return str(num)


# ─── 评分器 ───

def get_todolist_score(todolist_path):
    """解析 todolist 计算分数，并回写更新后的文件"""
    if not os.path.exists(todolist_path):
        return 0

    with open(todolist_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    x_ls, y_ls = [], []
    scores = 0
    x_line = y_line = score_line = -1

    for l, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("(x)"):
            x_ls.append(extract_line_number(stripped))
        elif stripped.startswith("(y)"):
            y_ls.append(extract_line_number(stripped))
            if "#" in stripped:
                try:
                    scores += int(stripped.split("#")[-1].strip())
                except ValueError:
                    pass
        elif stripped.startswith("x") and not stripped.startswith("(x)"):
            x_line = l
        elif stripped.startswith("y") and not stripped.startswith("(y)"):
            y_line = l
        elif stripped.startswith("Scores"):
            score_line = l

    # 回写
    if x_line >= 0:
        lines[x_line] = f"{'x':^6}:  {', '.join(x_ls)}\n"
    if y_line >= 0:
        lines[y_line] = f"{'y':^6}:  {', '.join(y_ls)}\n"
    if score_line >= 0:
        lines[score_line] = f"{'Scores':6}:  {scores} points\n"

    with open(todolist_path, "w", encoding="utf-8") as f:
        f.write("".join(lines))

    return scores


def get_record_score(record_path, full_record_all_time=45 * 9):
    """解析 record.txt，计算有效学习时间占比分数"""
    if not os.path.exists(record_path):
        return 0

    with open(record_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # 按空行分块
    blocks = []
    block = ""
    for line in lines:
        if line.strip() == "":
            if "min" in block:
                blocks.append(block)
            block = ""
        else:
            block += line
    if "min" in block:
        blocks.append(block)

    effective_time = 0
    all_time = 0

    for block in blocks:
        time_lines = [l for l in block.split("\n") if l.strip()]
        if len(time_lines) <= 3 and "min" in time_lines[0]:
            time_line = time_lines[0]
        else:
            time_line = time_lines[1] if len(time_lines) > 1 else time_lines[0]

        try:
            duration = int(time_line.split()[1])
        except (IndexError, ValueError):
            continue

        # 提取效率百分比
        percent = 60
        if "%" in block:
            idx = block.index("%")
            i = idx - 1
            while i >= 0 and block[i].isdigit():
                i -= 1
            try:
                percent = int(block[i:idx])
                percent = min(percent, 100)
            except ValueError:
                pass

        all_time += duration
        effective_time += int(percent * duration / 100)

    if all_time < full_record_all_time:
        all_time = full_record_all_time

    return int(effective_time / all_time * 100)


def get_arragement_score(arragement_path, full_score_all_time=45 * 9):
    """解析 arrangement/plan，计算任务完成占比"""
    if not os.path.exists(arragement_path):
        return 0

    with open(arragement_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    work_time = 0
    all_time = 0

    for line in lines:
        line = line.strip()
        if not (line.startswith("t") or line.startswith("[Y]")):
            continue

        tmp_time = 0
        if "#" not in line:
            tmp_time = 45
        else:
            time_part = line.split("#")[-1].strip()
            for ch in time_part:
                if ch.isdigit():
                    tmp_time = tmp_time * 10 + int(ch)
                else:
                    break
            if not tmp_time:
                tmp_time = 45

        all_time += tmp_time
        if line.startswith("[Y]"):
            work_time += tmp_time

    if all_time < full_score_all_time:
        all_time = full_score_all_time

    return int(work_time / all_time * 100)


def get_question_and_learn_score(base_dir, full_score_number=10):
    """统计 question.txt 和 learn.txt 中的编号条目数"""
    fl_types = ["question", "learn"]
    pattern = re.compile(r"\d{1,2} *\.")
    total = 0

    for ft in fl_types:
        fl_path = os.path.join(base_dir, ft + ".txt")
        if not os.path.exists(fl_path):
            continue
        with open(fl_path, "r", encoding="utf-8") as f:
            content = f.read()
        matches = pattern.findall(content)
        count = min(len(matches), full_score_number // len(fl_types))
        total += count

    return int(100 // full_score_number * total)
