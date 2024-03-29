import json
import os
import argparse
from utils import *
import readline

# the color
no_color = "\033[0m"
dark = "\033[0;30m"
light_dark = "\033[1;30m"
red = "\033[0;31m"
light_red = "\033[1;31m"
green = "\033[0;32m"
light_green = "\033[1;32m"
orange = "\033[0;33m"
yellow = "\033[1;33m"
blue = "\033[0;34m"
light_blue = "\033[1;34m"
purple = "\033[0;35m"
light_purple = "\033[1;35m"
cayon = "\033[0;36m"
light_cayon = "\033[1;36m"
light_gray = "\033[0;37m"
white = "\033[1;37m"

def color(color_, content):
    return color_ + content + no_color

# change the workspace to the responding dir
parser = argparse.ArgumentParser(description="for the type!")
parser.add_argument("-workspace", help="the workspace for the program")
args = parser.parse_args()
if args.workspace:
    os.chdir(args.workspace)

def cls():
    os.system("clear")

def hyphen(num):
    return "-" * num

if __name__ == "__main__":
# the global variables
    # change workspace to the current dir
    print("current dir is the: ", os.getcwd())
    cmd_ls = ["add", "sub", "show", "exit", "help", "clear", "save", "backen", "swtich", "sudo"]
    json_file_path = r"./words.json"
    txt_file_path = r"./words.txt"
    sep_line = "--------------------------------------"
    show_number = 20
    mode = "type" # or the "English"
    num_sort_sign = 1
    word_sort_sign = 1
    #
    print("------ words type practice! ------")
    while True:
        command = input(f"{newline(1)}[{color(yellow, 'Type')}] {color(light_blue, 'Please input the command')}: ")
        command = command.strip(" ")
        # check the command if len == 0
        if len(command)==0:
            cls()
            print(f"[ {hyphen(22)} {color(light_cayon, 'Type Pratice System')} {hyphen(22)} ]")
            continue
        # check if the command is right
        if command not in cmd_ls and "show" not in command:
            print(f"[W] {command} is not the command! Try again!")
            continue
        # the right command
        ## add command
        if command == "add":
            print("[##] Add the words to your database: ")
            add_words_str = input("->: ").strip(" ")
            # str -> list
            add_words_ls = add_words_str.split(" ")
            # load the dict and then renew the number
            word_dict = loadFile(json_file_path)
            for word in add_words_ls:
                if word == "":
                    continue
                if word in word_dict.keys():
                    word_dict[word] += 1
                else:
                    word_dict[word] = 1
            # dump
            dumpFile(word_dict, json_file_path)
        ## sub command
        elif command == "sub":
            print("[##] sub the words from the database: ")
            sub_words_str = input("->: ")
            # str -> list
            sub_words_str = sub_words_str.split(" ")
            sub_words_str = [word for word in sub_words_str if word != ""]
            # if sub_words_str not none, load the file
            if len(sub_words_str)>=1:
                word_dict = loadFile(json_file_path)
            else:
                continue
            for word_number in sub_words_str:
                try:
                    word, number = word_number.split(":")
                    number = int(number)
                    if word not in word_dict.keys():
                        continue
                    # has the key, number>0: renew, number<=0: pop
                    renew_number = word_dict[word] - number
                    if renew_number <= 0:
                        word_dict.pop(word)
                    else:
                        word_dict[word] = renew_number
                except:
                    print("[WW]Must use the : to separate the word and num, for example: the:2")
                    continue
            # save the file
            dumpFile(word_dict, json_file_path)
        ## show command
        elif "show" in command:
        # check if exist the number
            command_ls = command.split(" ")
            if len(command_ls) == 1:
                pass
            elif len(command_ls) == 2:
                show_number_o = show_number
                try:
                    show_number = int(command_ls[-1])
                except:
                    show_number = show_number_o
            else:
                print("[#W] your show command no right!")
                continue
            #
            cls()
            # load the file
            word_dict = loadFile(json_file_path)
            total_num = len(word_dict)
            show_num = min(total_num, show_number)
            print(f"---------------{color(light_cayon, 'Words Show')} ({show_num}/{total_num})--------------\n")
            # sort first
            word_dict = sorted(word_dict.items(), key=lambda x:(num_sort_sign * x[1],word_sort_sign * x[0]), reverse=True)
            # print
            for i, (word, number) in enumerate(word_dict, 1):
                if i > show_number:
                    break
                print(f" {i:>3}.{tab(1)}{word:<18} {number}")
            print(sep_line)

        ## exit command
        elif command == "exit" or command == "save":
        # save the file to the txt file
            content = ""
            word_dict = loadFile(json_file_path)
            word_dict = sorted(word_dict.items(), key=lambda x:(x[1],x[0]), reverse=True)
            for i, (word, number) in enumerate(word_dict, 1):
                content += f"{i:>3}.{tab(1)}{word:<18} {number}\n"
            # save the content
            with open(txt_file_path, "w+") as f:
                f.write(content)
            if command == "exit":
                print("exit!")
                break
            else:
                print("save!")
                continue
        #
        elif command == "clear":
            cls()

        #
        elif command == "backen":
            os.system(f"cp {json_file_path} word.json.bd")
            print("backup successfully!")
        #
        elif command == "switch":
            mode = "English"
        #
        elif command == "sudo":
            print(f"now: w={word_sort_sign}; n={num_sort_sign}")
            command_get = input("(python statement:)")
            try:
                exec(command_get)
                word_sort_sign = w
                num_sort_sign = n
            except:
                print(f"python statement: {command_get} is wrong, fail to modify!")
        #
        elif command == "help":
            help_information = f"---------------help information--------------{newline(2)}" \
                               f"->add: add the words, separate with the space.{newline(2)}" \
                               f"->sub: sub the words number after you pratice.{newline(2)}" \
                               f"->show: show the words.{newline(2)}" \
                               f"->clear: clean the screen.{newline(2)}" \
                               f"->help: show the help information.{newline(2)}" \
                               f"->exit: exit the program.{newline(2)}" \
                               f"->save: save the json file to the txt file!{newline(2)}" \
                               f"->backen: backend the json file{newline(2)}" \
                               f"->sudo: change the show sort of the word.\n"
            cls()
            print(help_information)
            print(sep_line)
