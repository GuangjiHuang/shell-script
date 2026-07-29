import os
import time

def get_line_number(line):
    for i in range(len(line)):
        if line[i].isdigit():
            break
    # now i is the digit or the end of the line
    l_num = 0
    while line[i].isdigit() and i<len(line):
        l_num = l_num * 10  + int(line[i])
        i += 1
    return str(l_num)

def get_todolist_score(todolist_path):
    with open(todolist_path, "r", encoding="utf-8") as f:
        lines = f.readlines()
    # get the x, and the y, and the score
    x_ls = list()
    y_ls = list()
    scores = 0
    #
    x_line_number = -1
    y_line_number = -1
    score_line_number = -1
    for l, line in enumerate(lines):
        line = line.strip()
        if line.startswith("(x)"):
            x_ls.append(get_line_number(line))
        elif line.startswith("(y)"):
            y_ls.append(get_line_number(line))
            # get the score
            tmp_score = 0
            if "#" in line:
                tmp_score = int(line.split("#")[-1])
            scores += tmp_score
        elif line.startswith("x"):
            x_line_number = l
        elif line.startswith("y"):
            y_line_number = l
        elif line.startswith("Scores"):
            score_line_number = l
    #print("x_ls: ", x_ls)
    #print("y_ls: ", y_ls)
    #print(f"-> todolist: {scores} points")
    # rewirte the todolist
    lines[x_line_number] = f"{'x':^6}:  {', '.join(x_ls)}\n"
    lines[y_line_number] = f"{'y':^6}:  {', '.join(y_ls)}\n"
    lines[score_line_number] = f"{'Scores':6}:  {scores} points\n"
    with open(todolist_path, "w", encoding="utf-8") as f:
        f.write("".join(lines))
    return scores
if __name__ == "__main__":
    today_date = time.strftime("%Y-%m/%m-%d")
    user_name = os.getenv("USER", "hgj")
    everyday_record_dir = f"/home/{user_name}/mygithub/everyday-record/"
    todolist_path = os.path.join(everyday_record_dir, today_date, "todolist.md")
    # the todolist
    todolist_score = get_todolist_score(todolist_path)
