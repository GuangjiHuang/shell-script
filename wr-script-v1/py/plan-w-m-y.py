#!/usr/bin/env python3
"""
plan-w-m-y.py — 创建周/月/年计划文件
修复: #16 使用 calendar.monthrange() 替代手动计算
     #17 使用 python3
"""

import calendar
import os
import sys
import time

up_dir = os.path.join(os.path.expanduser("~"), "mygithub/everyday-record/")

# 获取今天日期信息
tm = time.localtime()
year, month, day = tm.tm_year, tm.tm_mon, tm.tm_mday
wday = tm.tm_wday  # 0=Monday

# 周一的日期
monday_day = day - wday
if monday_day < 1:
    # 周一在上个月
    prev_month = month - 1 if month > 1 else 12
    prev_year = year if month > 1 else year - 1
    _, last_day = calendar.monthrange(prev_year, prev_month)
    monday_day = last_day + monday_day

# 构建路径
plan_year_path = os.path.join(up_dir, f"{year:04}", f"{year:04}-01", "01-01", "plan-y.md")
plan_month_path = os.path.join(up_dir, f"{year:04}", f"{year:04}-{month:02}", f"{month:02}-01", "plan-m.md")
plan_week_path = os.path.join(up_dir, f"{year:04}", f"{year:04}-{month:02}", f"{month:02}-{monday_day:02}", "plan-w.md")

# 检查是否需要创建（修复 #15: 用 calendar.monthrange 计算月末）
for plan_path, is_week in [(plan_year_path, False), (plan_month_path, False), (plan_week_path, True)]:
    if os.path.exists(plan_path):
        continue
    os.makedirs(os.path.dirname(plan_path), exist_ok=True)

    if plan_path == plan_year_path:
        header = (
            f"====================================\n"
            f"{year:04}-01-01 ~ {year:04}-12-31    YEAR PLAN\n"
            f"====================================\n"
        )
    elif plan_path == plan_month_path:
        _, last_day = calendar.monthrange(year, month)
        header = (
            f"=====================================\n"
            f"{year:04}-{month:02}-01 ~ {year:04}-{month:02}-{last_day:02}    MONTH PLAN\n"
            f"=====================================\n"
        )
    else:
        # 周日 = 周一 + 6 天
        sunday_ts = time.time() + (6 - wday) * 86400
        sun = time.localtime(sunday_ts)
        header = (
            f"====================================\n"
            f"{year:04}-{month:02}-{monday_day:02} ~ {sun.tm_year:04}-{sun.tm_mon:02}-{sun.tm_mday:02}    WEEK PLAN\n"
            f"====================================\n"
        )

    with open(plan_path, "w", encoding="utf-8") as f:
        f.write(header)

# 命令行参数处理
if len(sys.argv) == 1:
    sys.exit(0)

arg = sys.argv[1]
arg_map = {"-w": plan_week_path, "-m": plan_month_path, "-y": plan_year_path}
target = arg_map.get(arg)
if target:
    print(target)
    os.system(f'vim "{target}"')
else:
    print(f"未知参数: {arg}", file=sys.stderr)
    sys.exit(1)
