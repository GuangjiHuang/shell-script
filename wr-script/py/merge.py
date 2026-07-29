import re
import time
import os

def get_merge_gap(merge_record_path):
    "1622476800.0: 2021-06-01"
    now_time = time.time()
    prev_time = 0
    if os.path.exists(merge_record_path):
        with open(merge_record_path, "r", encoding="utf-8") as f:
            prev_time = float(f.read())
    else:
        prev_time = now_time
    delta_time = now_time - prev_time
    DAY_SECONDS = 24 * 60 * 60
    date_str_ls = list()
    while delta_time > DAY_SECONDS:
        prev_time += DAY_SECONDS
        # convert seconds to the date
        date_str = time.strftime("%Y/%Y-%m/%m-%d", time.localtime(prev_time))
        #print(date_str)
        date_str_ls.append(date_str)
        # sub
        delta_time -= DAY_SECONDS
    # return the date
    return date_str_ls

def merge_by_date(date_dir):
    # get the date from the date_dir
    date_str_ls = date_dir.split("/")
    year, month, day = date_str_ls[-3], date_str_ls[-2], date_str_ls[-1]
    month = month.split("-")[-1]
    day = day.split("-")[-1]
    print(f"-------- {year}-{month}-{day} --------")
    # re pattern 
    pattern = r"\d{4}-\d{2}-\d{2}"
    # read the merge file, check and then merge
    file_ty_ls = ["learn", "question", "review", "idea"]
    for fl in file_ty_ls:
        # read the file
        fl_path = os.path.join(date_dir, fl+".md")
        print(fl_path)
        # check the path first
        if not os.path.exists(fl_path):
            print(f"{fl}: not merge!")
            continue
        with open(fl_path, "r", encoding="utf-8") as f:
            fl_lines = f.readlines()
            not_empty_lines = [line for line in fl_lines if line.strip()]
            if len(not_empty_lines) < 4:
                print(f"{fl}: not merge!")
                continue
            else:
                print(f"{fl}: merge!")
            fl_content = "".join(fl_lines)
            #print(fl_content)
            match = re.search(pattern, fl_content)
            date = None
            if match:
                date = match.group()
        # read the merge_file
        merge_path = os.path.join(merge_dir, fl+"-a.md")
        lines = list()
        if os.path.exists(merge_path):
            with open(merge_path, "r", encoding="utf-8") as f:
                lines = f.readlines()
        # try to find if has the same date in the merge file
        is_in_merge_file = False
        for i in range(len(lines)-1, -1, -1):
            if date in lines[i]:
                is_in_merge_file = True
                break
        if is_in_merge_file:
            with open(merge_path, "w", encoding="utf-8") as f:
                original_content = "".join(lines[:i-1])
                f.write(original_content + fl_content)
        else:
            with open(merge_path, "a", encoding="utf-8") as f:
                f.write("\n" + fl_content)

if __name__ == "__main__":
    # about the dir and the file type 
    user_name = os.getenv("USER", "hgj")
    up_dir = os.path.join(os.path.expanduser("~"), "mygithub/everyday-record");
    merge_dir = f"{os.getenv('HOME')}/mygithub/everyday-record/compress"
    merge_record_path = os.path.join(merge_dir, "merge.record")
    today_dir = os.path.join(up_dir, time.strftime("%Y-%m/%m-%d"))
    # merge today's dir
    #merge_by_date(today_dir)
    # check the previous date
    date_ls = get_merge_gap(merge_record_path)
    for date_str in date_ls:
        date_dir = os.path.join(up_dir, date_str)
        # write the date_dir's question and learn to the merge file
        try:
            merge_by_date(date_dir)
        except:
            pass
    # merge today
    merge_by_date(today_dir)
    # after write merge all, write the merge record to the file
    with open(merge_record_path, "w", encoding="utf-8") as f:
        f.write(str(time.time()))
