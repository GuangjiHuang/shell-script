import time
import os
import sys

up_dir = os.path.join(os.getenv("HOME"), "mygithub/everyday-record/")
# get the first day of the week, month and the  year of today
tm_s = time.localtime()
year, month, y_day, m_day, w_day = tm_s.tm_year, tm_s.tm_mon, tm_s.tm_yday, tm_s.tm_mday, tm_s.tm_wday

first_week_day = m_day - w_day
plan_year_path = f"{year}/{year}-01/01-01/plan-y.md"
plan_year_path = os.path.join(up_dir, plan_year_path)
plan_month_path = f"{year}/{year}-{month:02}/{month:02}-01/plan-m.md"
plan_month_path = os.path.join(up_dir, plan_month_path)
plan_week_path = f"{year}/{year}-{month:02}/{month:02}-{first_week_day:02}/plan-w.md"
plan_week_path = os.path.join(up_dir, plan_week_path)
#print(plan_year_path)
#print(plan_month_path)
#print(plan_week_path)
# check if today is the first day of the week, month, year
#if y_day == 1:
is_force_write = False
# touch the file
if not os.path.exists(plan_year_path) or is_force_write:
    os.makedirs(os.path.dirname(plan_year_path), exist_ok=True)
    with open(plan_year_path, "w", encoding="utf-8") as f:
        content = f"====================================\n"\
                f"{year}-01-01 ~ {year}-12-31    YEAR PLAN\n"\
                f"====================================\n"
        f.write(content)
#if m_day == 1:
# touch the file
if not os.path.exists(plan_month_path) or is_force_write:
    os.makedirs(os.path.dirname(plan_month_path), exist_ok=True)
    if month in [1, 3, 5, 7, 8, 10, 12]:
        n_day = 31
    elif month in [4, 6, 9, 11]:
        n_day = 30
    elif (year%4==0 and year%100!=0) or (year%400==0):
        n_day = 29
    else:
        n_day = 28
    with open(plan_month_path, "w", encoding="utf-8") as f:
        content = f"=====================================\n"\
                f"{year}-{month:02}-01 ~ {year}-{month:02}-{n_day:02}    MONTH PLAN\n"\
                f"=====================================\n"
        f.write(content)
#if w_day == 0:
# touch the file
if not os.path.exists(plan_week_path) or is_force_write:
    os.makedirs(os.path.dirname(plan_week_path), exist_ok=True)
    now_ts = time.time()
    next_ts = now_ts + (6 - time.localtime(now_ts).tm_wday) * 3600 * 24
    n_t = time.localtime(next_ts)
    n_year, n_month, n_day = n_t.tm_year, n_t.tm_mon, n_t.tm_mday
    with open(plan_week_path, "w", encoding="utf-8") as f:
        content = f"====================================\n"\
                f"{year}-{month:02}-{first_week_day:02} ~ {n_year}-{n_month:02}-{n_day:02}    WEEK PLAN\n"\
                f"====================================\n"
        f.write(content)
# the argument
if len(sys.argv) == 1:
    exit(0)
arg = sys.argv[1]
if  arg == "-w":
    print(plan_week_path)
    os.system(f"vim {plan_week_path}")
elif  arg == "-m":
    print(plan_month_path)
    os.system(f"vim {plan_month_path}")
elif  arg == "-y":
    print(plan_year_path)
    os.system(f"vim {plan_year_path}")
