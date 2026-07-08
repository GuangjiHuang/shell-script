#!/usr/bin/env python3
"""
todo_score.py — 打开 todolist 前自动计分并回写
修复: #14 使用共享库
"""

import os
import sys
import time

# 添加共享库路径
script_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, script_dir)
from vr_score_lib import get_todolist_score

if __name__ == "__main__":
    today = time.strftime("%Y-%m/%m-%d")
    base = os.path.join(os.path.expanduser("~"), "mygithub/everyday-record")
    todolist_path = os.path.join(base, today, "todolist.txt")

    score = get_todolist_score(todolist_path)
    print(f"→ todolist: {score} points")
