#!/usr/bin/env python3
"""
merge.py — 将 learn/question/review/idea 合并到 compress/xxx-a.md
修复: #5 裸 except → 具体异常处理 + 日志
     #15 使用 datetime 替代 time.time() 做日期推算
"""

import datetime
import os
import re
import sys

RECORD_BASE = os.path.join(os.path.expanduser("~"), "mygithub/everyday-record")
MERGE_DIR = os.path.join(RECORD_BASE, "compress")
MERGE_RECORD = os.path.join(MERGE_DIR, "merge.record")
FILE_TYPES = ["learn", "question", "review", "idea"]
DATE_PATTERN = re.compile(r"\d{4}-\d{2}-\d{2}")


def get_merge_dates():
    """根据 merge.record 找出需要合并的日期 (修复 #15: 用 datetime)"""
    os.makedirs(MERGE_DIR, exist_ok=True)
    now = datetime.date.today()

    if os.path.exists(MERGE_RECORD):
        with open(MERGE_RECORD, "r", encoding="utf-8") as f:
            try:
                last_ts = float(f.read().strip())
                last_date = datetime.date.fromtimestamp(last_ts)
            except (ValueError, OSError):
                last_date = now
    else:
        last_date = now

    dates = []
    current = last_date + datetime.timedelta(days=1)
    while current <= now:
        dates.append(current)
        current += datetime.timedelta(days=1)
    return dates


def merge_file(date_dir, file_type):
    """合并单个文件到 compress/xxx-a.md"""
    fl_path = os.path.join(date_dir, f"{file_type}.md")

    if not os.path.exists(fl_path):
        print(f"  {file_type}: 跳过(文件不存在)")
        return

    with open(fl_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    non_empty = [l for l in lines if l.strip()]
    if len(non_empty) < 4:
        print(f"  {file_type}: 跳过(内容不足)")
        return

    content = "".join(lines)
    match = DATE_PATTERN.search(content)
    date_str = match.group() if match else "unknown"

    merge_path = os.path.join(MERGE_DIR, f"{file_type}-a.md")

    # 读取已有合并文件
    existing_lines = []
    if os.path.exists(merge_path):
        with open(merge_path, "r", encoding="utf-8") as f:
            existing_lines = f.readlines()

    # 检查是否已有相同日期的内容
    found_idx = None
    for i in range(len(existing_lines) - 1, -1, -1):
        if date_str in existing_lines[i]:
            found_idx = i
            break

    if found_idx is not None:
        # 替换该日期之后的内容
        prefix = "".join(existing_lines[: max(0, found_idx - 1)])
        with open(merge_path, "w", encoding="utf-8") as f:
            f.write(prefix + "\n" + content)
        print(f"  {file_type}: 更新 ({date_str})")
    else:
        with open(merge_path, "a", encoding="utf-8") as f:
            f.write("\n" + content)
        print(f"  {file_type}: 追加 ({date_str})")


def merge_date(date_obj):
    """合并某一天的文件"""
    date_str = date_obj.strftime("%Y/%Y-%m/%m-%d")
    date_dir = os.path.join(RECORD_BASE, date_str)

    if not os.path.isdir(date_dir):
        print(f"跳过 {date_str}: 目录不存在")
        return

    print(f"合并 {date_obj.strftime('%Y-%m-%d')}:")
    for ft in FILE_TYPES:
        merge_file(date_dir, ft)


if __name__ == "__main__":
    dates = get_merge_dates()
    if not dates:
        print("没有需要合并的日期。")
        sys.exit(0)

    for d in dates:
        try:
            merge_date(d)
        except Exception as e:
            # 修复 #5: 不再裸 except，打印具体错误
            print(f"  合并 {d} 时出错: {e}", file=sys.stderr)

    # 更新记录
    with open(MERGE_RECORD, "w", encoding="utf-8") as f:
        f.write(str(datetime.datetime.now().timestamp()))

    print("\n合并完成。")
