#! /bin/bash
# time: Mon Sep 27 14:49:05 2021

# >>>>>>>>>>>>>>>> the design explanation <<<<<<<<<<<<<<<<<<<<<
#{{{
# design and the function:
# 1) set up the different task and the layout. You just need to type the <mytmux task_name> to 
# enter the corresponding task; 
# if the task session has been created, then open it, else, create it and then open them! 
# -> the possible task may be the:
# c++; 
# python;
# vim;
# shell;
# markdown;
# isp;
# mars;
# project;
# paper;
# fun( to show the rest, moyu, fish picture ).
# 2) touch the task list for every task sessions. this task file is for record the task, or your 
# ideas or your thinking that you want to do something!
# 3) try to use more simple command to achieve that!
#}}}

# >>>>>>>>>>>>>>>> the global variables <<<<<<<<<<<<<<<<<<<<<
#{{{
sessions_list=(
    "ssh" \
    "code" \
    "c++" \
    "python" \
    "shell" \
    "vim" \
    "cmake" \
    "markdown" \
    "isp" \
	"mars" \
	"mars3" \
    "cc" \
    "project" \
    "fun" \
    "chore" \
    "plan" \
    "paper" \
    "work" \
    "question" \
    "English" \
    "type" \
    "clock"
)
tmux_action="create"
source_dir=~/mygithub/shell-script/tmux-manager
source_name="${source_dir}/tmux-manager.sh"
install_dir=~/opt/myscript/tmux-manager
mode_control_path=~/opt/myscript/tmux-manager/mode-control.sh
# the path of the goals inside the mode
# the file directories
goal_list_dir=~/mygithub/tmux_treasure/${mode}/goal-list
goal_all_dir=~/mygithub/tmux_treasure/${mode}/goal-all
counter_path=$goal_list_dir/../counter
goal_index_dir=~/mygithub/tmux_treasure/${mode}/goal-index
# get the full name of the action
#}}}

# >>>>>>>>>>>>>>>> the  tmux's layout <<<<<<<<<<<<<<<<<<<<<
#{{{
# 3 panes
tmux_template_3panes()
{
    
    # new the session;
    # split the window;
    # resize the pane's size
    # send-keys to execute the commamd
    #|-----------------------------------------
    #|   0     |           1         |   2    |
    #|         |                     |        |
    #|         |                     |        |
    #| rain    |         edit        |  rain  |
    #|         |                     |        |
    #|         |                     |        |
    #|         |     < maximum >     |        |
    #|         |                     |        |
    #|         |                     |        |
    #|-----------------------------------------
    
    # the parameters
    # $1 ->: the session's name <note: the follow lines cannot be split with the comment line>
    tmux new-session -s "$1" -n "$1" \; \
    split-window -h \; \
    split-window -h \; \
    resize-pane -t 1 -x95% \; \
    send-keys -t 0 'wr rain' C-m\; \
    send-keys -t 2 'wr rain' C-m\; \
    send-keys -t 1 'love you' C-m\; \
    select-pane -t 1

}

tmux_tempalte_3panes_for_chore()
{
    # add the work to the tmux_chore
    source_dir=~/mygithub/shell-script/tmux-manager
    work_data_dir=~/mygithub/data-shared/work_management/data
    tmux_work_command="cd $source_dir/work_management/; ./bin/main*"
    # the tmux command
    tmux new-session -s "$1" -n "$1" \; \
    new-window -n "ql" \; \
    new-window -n "program" \; \
    new-window -n "work" \; \
    new-window -n "paper" \; \
    new-window -n "review" \; \
    select-window -t 0 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    split-window -v \; \
    select-pane -t 2 \; \
    split-window -v \; \
    send-keys -t 0 'wr record' C-m\; \
    send-keys -t 1 'wr todo' C-m\; \
    send-keys -t 2 'wr arragement' C-m\; \
    send-keys -t 3 'wr plan' C-m\; \
    select-window -t 1 \; \
    split-window -h \; \
    send-keys -t 0 'wr learn' C-m\; \
    send-keys -t 1 'wr question' C-m\; \
    select-window -t 2 \; \
    split-window -h \; \
    select-window -t 3 \; \
    split-window -h \; \
    send-keys -t 0 "$tmux_work_command" C-m\; \
    select-window -t 4 \; \
    split-window -h \; \
    select-window -t 5 \; \
    split-window -h \; \
    send-keys -t 0 'wr review' C-m\; \
    send-keys -t 1 'wr diary' C-m\; \
    select-window -t 0 \; \
    select-pane -t 1
}

tmux_tempalte_3panes_for_plan()
{
    # add the work to the tmux_plan
    source_dir=~/mygithub/shell-script/tmux-manager
    work_data_dir=~/mygithub/data-shared/work_management/data
    tmux_work_command="cd $source_dir/work_management/; ./bin/main*"
    # the tmux command
    tmux new-session -s "$1" -n "day" \; \
    new-window -n "week" \; \
    new-window -n "month" \; \
    new-window -n "year" \; \
    new-window -n "idea" \; \
    new-window -n "program" \; \
    select-window -t 0 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    send-keys -t 0 'wr plan' C-m\; \
    select-window -t 1 \; \
    split-window -h \; \
    send-keys -t 0 'wr plan -w' C-m\; \
    select-pane -t 0 \; \
    select-window -t 2 \; \
    split-window -h \; \
    send-keys -t 0 'wr plan -m' C-m\; \
    select-pane -t 0 \; \
    select-window -t 3 \; \
    split-window -h \; \
    send-keys -t 0 'wr plan -y' C-m\; \
    select-pane -t 0 \; \
    select-window -t 4 \; \
    split-window -h \; \
    send-keys -t 0 'wr idea' C-m\; \
    select-pane -t 0 \; \
    select-window -t 5 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 0 \; \
    select-pane -t 0
}

tmux_tempalte_3panes_for_ssh()
{
    # the tmux command
    tmux new-session -s "$1" -n "dear" \; \
    new-window -n "1080" \; \
    new-window -n "2080" \; \
    new-window -n "3080" \; \
    new-window -n "M5000" \; \
    select-window -t 0 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    send-keys -t 0 'c-dear_' C-m\; \
    select-window -t 1 \; \
    select-pane -t 0 \; \
    split-window -h \; \
    send-keys -t 0 'c-s1' C-m\; \
    select-pane -t 0 \; \
    select-window -t 2 \; \
    split-window -h \; \
    send-keys -t 0 'c-s2' C-m\; \
    select-pane -t 0 \; \
    select-window -t 3 \; \
    split-window -h \; \
    send-keys -t 0 'c-s3' C-m\; \
    select-pane -t 0 \; \
    select-window -t 4 \; \
    split-window -h \; \
    send-keys -t 0 'ssh ${scut_M5000}' C-m\; \
    select-pane -t 0 \; \
    select-window -t 0 \; \
    select-pane -t 0
}

tmux_tempalte_3panes_for_code()
{
    # the tmux command
    tmux new-session -s "$1" -n "c++" \; \
    new-window -n "python" \; \
    new-window -n "shell" \; \
    new-window -n "vim" \; \
    new-window -n "cmake" \; \
    select-window -t 0 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 1 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 2 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 3 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 4 \; \
    split-window -h \; \
    select-pane -t 0 \; \
    select-window -t 0 \; \
    select-pane -t 0
}

tmux_tempalte_3panes_for_question()
{
    tmux new-session -s "$1" -n "$1" \; \
    split-window -h \; \
    send-keys -t 0 'wr question' C-m\; \
    send-keys -t 1 'wr learn' C-m\; \
    select-pane -t 0
}

# 2 panes
tmux_template_2panes()
{
    
    # new the session;
    # split the window;
    # resize the pane's size
    # send-keys to execute the commamd
    #|-----------------------------------------
    #|        0                      |   1    |
    #|                               |        |
    #|       edit                    |        |
    #|                               |  rain  |
    #|                               |        |
    #|       70%                     |        |
    #|                               |        |
    #|                               |  30%   |
    #|                               |        |
    #|-----------------------------------------

    # the parameters
    # $1: sessioin name
    # $2: left part big or the right part big
    if [ "$2" == "left_big" ];then
        part_percent=40%
    else
        part_percent=50%
    fi
    tmux new-session -s "$1" -n "$1" \; \
    split-window -h \; \
    resize-pane -t 0 -x$part_percent \; \
    send-keys -t 1 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love you' C-m\; \
    select-pane -t 0

}

# for 40.3 server
tmux_template_for_isp()
{
	tmux new-session -s "$1" -n "ISP" \; \
		split-window -h \; \
		new-window -n "device" \; \
		split-window -h \; \
		new-window -n "edge" \; \
		split-window -h \; \
		new-window -n "pqtool" \; \
		split-window -h \; \
		new-window -n "chore" \; \
		split-window -h \; \
		new-window -n "mars3" \; \
		split-window -h \; \
		select-window -t 1 \; \
		send-keys -t 0 'cd ~/a2/middleware/v2/modules/isp/cv186x;clear' C-m\; \
		send-keys -t 1 'cd ~/a2/middleware/v2/modules/isp/cv186x;clear' C-m\; \
		select-window -t 2 \; \
		send-keys -t 0 'cd ~/edge/middleware/v2/modules/isp/cv186x;clear' C-m\; \
		send-keys -t 1 'cd ~/edge/middleware/v2/modules/isp/cv186x;clear' C-m\; \
		select-window -t 3 \; \
		send-keys -t 0 'cd ~/pqtool/isp-tool;clear' C-m\; \
		send-keys -t 1 'cd ~/pqtool/isp-tool;clear' C-m\; \
		select-window -t 5 \; \
		send-keys -t 0 'cd ~/isp/mars3' C-m\; \
		send-keys -t 1 'cd ~/isp/mars3' C-m\; \
		select-window -t 0 \; \
		send-keys -t 0 'date' C-m
}

tmux_template_for_mars()
{
	tmux new-session -s "$1" -n "MARS" \; \
		split-window -h \; \
		new-window -n "v4.1" \; \
		split-window -h \; \
		new-window -n "v4.2" \; \
		split-window -h \; \
		new-window -n "chore" \; \
		split-window -h \; \
		select-window -t 1 \; \
		send-keys -t 0 'cd ~/mars_v4.1.0;clear' C-m\; \
		send-keys -t 1 'cd ~/mars_v4.1.0;clear' C-m\; \
		select-window -t 2 \; \
		send-keys -t 0 'cd ~/mars_v4.2.0;clear' C-m\; \
		send-keys -t 1 'cd ~/mars_v4.2.0;clear' C-m\; \
		select-window -t 0 \;
}

tmux_template_for_cc()
{
	tmux new-session -s "$1" -n "mygithub" \; \
		split-window -h \; \
		new-window -n "knowledge" \; \
		split-window -h \; \
		new-window -n "cc" \; \
		split-window -h \; \
		new-window -n "nvim" \; \
		split-window -h \; \
		new-window -n "autotest" \; \
		split-window -h \; \
		new-window -n "chore" \; \
		split-window -h \; \
		select-window -t 0 \; \
		send-keys -t 0 'cd ~/mygithub;clear' C-m\; \
		send-keys -t 1 'cd ~/mygithub;clear' C-m\; \
		select-window -t 1 \; \
		send-keys -t 0 'cd ~/mygithub/knowledge;clear' C-m\; \
		send-keys -t 1 'cd ~/mygithub/knowledge;clear' C-m\; \
		select-window -t 2 \; \
		send-keys -t 0 'cd ~/.claude;clear' C-m\; \
		send-keys -t 1 'cd ~/.claude;clear' C-m\; \
		select-window -t 3 \; \
		send-keys -t 0 'cd ~/.config/nvim;clear' C-m\; \
		send-keys -t 1 'cd ~/.config/nvim;clear' C-m\; \
		select-window -t 4 \; \
		send-keys -t 0 'cd /mnt/nfs/test;clear' C-m\; \
		send-keys -t 1 'cd /mnt/nfs/test;clear' C-m\; \
		select-window -t 5 \; \
		send-keys -t 0 'cd ~;clear' C-m\; \
		send-keys -t 1 'cd ~;clear' C-m\; \
		select-window -t 0 \;
}

tmux_template_for_mars3()
{
	tmux new-session -s "$1" -n "single" \; \
		split-window -h \; \
		new-window -n "dual_os" \; \
		split-window -h \; \
		new-window -n "chore" \; \
		split-window -h \; \
		select-window -t 0 \; \
		send-keys -t 0 'cd ~/mars3l;clear' C-m\; \
		send-keys -t 1 'cd ~/mars3l;clear' C-m\; \
		select-window -t 1 \; \
		send-keys -t 0 'cd ~/mars3d;clear' C-m\; \
		send-keys -t 1 'cd ~/mars3d;clear' C-m\; \
		select-window -t 0 \;
}

tmux_cpp()
{
    tmux_template_2panes "c++"
}

tmux_vim()
{
    tmux_template_2panes "vim"
}

tmux_shell()
{
    tmux_template_2panes "shell"
}

tmux_markdown()
{
    tmux_template_2panes "markdown"
    echo "this is the markdown's tmux"
}

tmux_isp()
{
    tmux_template_for_isp "isp"
    echo "this is the isp's tmux"
}

tmux_cc()
{
    tmux_template_for_cc "cc"
    echo "this is the cc's tmux"
}

tmux_mars()
{
    tmux_template_for_mars "mars"
    echo "this is the mars's tmux"
}

tmux_mars3()
{
    tmux_template_for_mars3 "mars3"
    echo "this is the mars3's tmux"
}

tmux_entertainment()
{
    tmux_template_2panes "fun"
    echo "this is the fun's tmux"
}

tmux_type()
{
    # rewrite the layout
    #tmux_template_2panes "type"
    python_main_dir=${HOME}/mygithub/shell-script/tmux-manager/type-code
    type_data_dir="~/mygithub/data-shared/type"
    tmux new-session -s "type" -n "type" \; \
    split-window -h \; \
    send-keys -t 1 'wr type' C-m\; \
    send-keys -t 0 "python ${python_main_dir}/main.py -workspace $type_data_dir" C-m\; \
    select-pane -t 1
    #echo "this is the type's tmux"
}

tmux_question()
{
    tmux_tempalte_3panes_for_question "question"
    echo "this is the question's tmux"
}

tmux_cmake()
{
    tmux_template_2panes "cmake"
    echo "this is the cmake's tmux"
}

# 2 panes
tmux_template_2panes()
{
    
    # new the session;
    # split the window;
    # resize the pane's size
    # send-keys to execute the commamd
    #|-----------------------------------------
    #|        0                      |   1    |
    #|                               |        |
    #|       edit                    |        |
    #|                               |  rain  |
    #|                               |        |
    #|       70%                     |        |
    #|                               |        |
    #|                               |  30%   |
    #|                               |        |
    #|-----------------------------------------

    # the parameters
    # $1: sessioin name
    # $2: left part big or the right part big
    if [ "$2" == "left_big" ];then
        part_percent=40%
    else
        part_percent=50%
    fi
    tmux new-session -s "$1" -n "$1" \; \
    split-window -h \; \
    resize-pane -t 0 -x$part_percent \; \
    send-keys -t 1 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love you' C-m\; \
    select-pane -t 0

}

tmux_python()
{
    #tmux_template_2panes "python" "left_big"
    tmux_template_2panes "python"
}

tmux_project()
{
    tmux_template_2panes "project"
    echo "this is the project's tmux"
}

tmux_paper()
{
    tmux_template_2panes "paper"
    echo "this is the paper's tmux"
}

tmux_English()
{
    # rewrite the layout
    python_English_dir=${HOME}/mygithub/shell-script/tmux-manager/English-code
    English_data_dir="~/mygithub/data-shared/English"
    # add the type as the window
    python_type_dir=${HOME}/mygithub/shell-script/tmux-manager/type-code
    type_data_dir="~/mygithub/data-shared/type"
    #
    tmux new-session -s "English" -n "English" \; \
    new-window -n "type" \; \
    select-window -t 0 \; \
    split-window -h \; \
    send-keys -t 1 'wr English' C-m\; \
    send-keys -t 0 "python ${python_English_dir}/main.py -workspace $English_data_dir" C-m\; \
    select-window -t 1 \; \
    split-window -h \; \
    send-keys -t 1 'wr type' C-m\; \
    send-keys -t 0 "python ${python_type_dir}/main.py -workspace $type_data_dir" C-m\; \
    select-pane -t 0 \; \
    select-window -t 0 \; \
    select-pane -t 0
    #echo "this is the type's tmux"
}

tmux_chore()
{
    tmux_tempalte_3panes_for_chore "chore"
    echo "this is the chore's tmux"
}

tmux_plan()
{
    tmux_tempalte_3panes_for_plan "plan"
    echo "this is the plan's tmux"
}

tmux_ssh()
{
    tmux_tempalte_3panes_for_ssh "ssh"
    echo "this is the question's tmux"
}

tmux_code()
{
    tmux_tempalte_3panes_for_code "code"
    echo "this is the question's tmux"
}

# 2 panes
tmux_template_2panes()
{
    
    # new the session;
    # split the window;
    # resize the pane's size
    # send-keys to execute the commamd
    #|-----------------------------------------
    #|        0                      |   1    |
    #|                               |        |
    #|       edit                    |        |
    #|                               |  rain  |
    #|                               |        |
    #|       70%                     |        |
    #|                               |        |
    #|                               |  30%   |
    #|                               |        |
    #|-----------------------------------------

    # the parameters
    # $1: sessioin name
    # $2: left part big or the right part big
    if [ "$2" == "left_big" ];then
        part_percent=40%
    else
        part_percent=50%
    fi
    tmux new-session -s "$1" -n "$1" \; \
    split-window -h \; \
    resize-pane -t 0 -x$part_percent \; \
    send-keys -t 1 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love go-goal;clear' C-m\; \
    send-keys -t 0 'love you' C-m\; \
    select-pane -t 0

}

tmux_paper()
{
    tmux_template_2panes "paper"
    echo "this is the paper's tmux"
}

tmux_entertainment()
{
    tmux_template_2panes "fun"
    echo "this is the fun's tmux"
}


tmux_work()
{
    source_dir=~/mygithub/shell-script/tmux-manager
    work_data_dir=~/mygithub/data-shared/work_management/data
    tmux_work_command="cd $source_dir/work_management/; ./bin/main*"
    # rewrite the layout
    tmux new-session -s "work" -n "work" \; \
    split-window -h \; \
    send-keys -t 0 "$tmux_work_command" C-m\; \
    select-pane -t 0
    #echo "this is the type's tmux"
}

tmux_clock()
{
    shell_script_path=$install_dir/love-clock-switch-rain-clock.sh
    shell_script_command=". $shell_script_path"
    #echo "the command is the: $shell_script_command"
    tmux new-session -s "clock" \; \
    setw status off \; \
    clock \;
    #send-keys "while [ 1 ];do;" C-m
    #send-keys "$shell_script_command" C-m
    #clock \; \

    #tmux send-keys 'q' C-m
    #while [ 1 ]
    #do
    #    tmux send-keys 'q' C-m
    #    tmux clock
    #    sleep 5
    #    tmux send-keys 'q' C-m
    #    tmux send-keys 'wr rain' C-m
    #done
}

#}}}
# >>>>>>>>>>>>>>>> the ulity funciton <<<<<<<<<<<<<<<<<<<<<
#{{{
action_status_show()
{
    # the parameters:
    # $1: mode
    # $2: goal_index
    # $3: action_full_name
    # $4: concrete_action_full_name
    # get the goal_index to check
    show_arg_2=$2
    show_arg_3=$3
    show_arg_4=$4
    goal_index=$(cat $goal_index_dir/goal_current.index 2>/dev/null)
    if [ -z "$2" ]; then
        show_arg_2=x
        show_arg_3=$2
        show_arg_4=$3
    fi
    echo -e "--------------> ${RED}$1${NOCOLOR} | ${GREEN}goal $show_arg_2${NOCOLOR} | ${CYAN}$show_arg_3${NOCOLOR}-> ${CYAN}$show_arg_4${NOCOLOR}<--------------"
}
create_mode_dir()
{
    # the paramters:
    # $1: mode
    # the parameters: no 
    mode_path=~/mygithub/tmux_treasure/$1
    if [ ! -d ${mode_path} ];then
        mkdir -p $mode_path
        # copy the template to it
        cp -r $source_dir/mode/* $mode_path
    fi
}
#}}}
# >>>>>>>>>>>>>>>> the action function <<<<<<<<<<<<<<<<<<<<<
#{{{
action()
{
    # the variables
    # the file directories
    goal_list_dir=~/mygithub/tmux_treasure/${mode}/goal-list
    goal_all_dir=~/mygithub/tmux_treasure/${mode}/goal-all
    # the goal index
    goal_index=$(cat $goal_index_dir/goal_current.index 2>/dev/null)
    # the actions array
    action_array=("goal" "action" "question" "task" "conclusion" "progess")
    # the path of the goal or the goal_list
    goal_path=$goal_all_dir/$3.goal # this is may be exsitent, have to check!
    goal_list_path=$goal_list_dir/goal_$2.txt # have to be specified!
    counter_path=$goal_list_dir/../counter
    # get the full name of the action
    for i in ${action_array[@]}
    do
        if [ "${1:0:1}" == "${i:0:1}" ]; then
            action_full_name=$i
        fi
    done
    #
    # confirm the index 
    if [ -z "$2" ];then
        goal_path=$goal_all_dir/$goal_index.goal
    else
        goal_path=$goal_all_dir/$2.goal
    fi
    # output the goals information and the action
    # --------------> Vim | Goal 12 | question; <--------------
    #echo -e "--------------> ${RED}$mode${NOCOLOR} | ${GREEN}goal $goal_index${NOCOLOR} | ${CYAN}$action_full_name${NOCOLOR} <--------------"
    case "$1" in
        "gs") # goal show
        #{{{
            #
            # show all the goals, finished goals, not finished goals
            case "$2" in
                #
                "a" | "y" | "n" | "d" | "w" | "m")
                    # action_status_show
                    action_status_show $mode $goal_index $action_full_name "show goals(cat)"
                    # show all the goals
                    #vim $goal_list_path
                    cat $goal_list_path 2>/dev/null
                    ;;
                "a-" | "y-" | "n-" | "d-" | "w-" | "m-")
                    # action_status_show
                    action_status_show $mode $goal_index $action_full_name "show goals(vim)"
                    # show all the goals
                    goal_list_path=$goal_list_dir/goal_${2:0:1}.txt # delete the -
                    #cat $goal_list_path
                    vim $goal_list_path
                    ;;

                "c+")
                    # set the current index
                    # action_status_show
                    action_status_show $mode $goal_index $action_full_name "set current index"
                    read -p "-> Set current goal index: " current_index
                    echo $current_index > $goal_index_dir/goal_current.index
                    ;;
                "d+" | "w+" | "m+")
                    # the var: goal_index_path
                    goal_index_path=$goal_index_dir/goal_${2:0:1}.index
                    goal_list_path=$goal_list_dir/goal_${2:0:1}.txt
                    # add the index for it
                    # generate the time
                    case "$2" in # there is no wrong with the $2!
                        "d+")
                            # action_status_show
                            action_status_show $mode $goal_index $action_full_name "set today index"
                            time_part=$(date "+%Y/%m/%d")
                            ;;
                        "w+")
                            # action_status_show
                            action_status_show $mode $goal_index $action_full_name "set week index"
                            if [ "$(date "+%w")" == "0" ]; then
                                # renew the time
                                time_part=$(date "+%Y/%m/%d")-$(date -d "7 days" +%Y/%m/%d)
                            else
                                off_day_left=$(date "+%w") # get the weekday based on the Sunday=0
                                let off_day_right=6-off_day_left
                                time_part=$(date -d "${off_day_left} days ago" +%Y/%m/%d)-$(date -d "${off_day_right} days" +%Y/%m/%d)
                            fi
                            ;;
                        "m+")
                            # action_status_show
                            action_status_show $mode $goal_index $action_full_name "set month index"
                            time_part=$(date "+%Y/%m")
                            ;;
                    esac
                    # append the content to the file
                    read -p "->Add goals index: " index_part
                    #
                    # make sure append or the new, so you can check the time
                    origin_line=$(grep "$time_part" $goal_index_path)
                    if [ "$?" == 0 ];then
                        # append, so to substitude
                        all_part="$origin_line $index_part"
                        sed -i '$d' $goal_index_path
                        echo $all_part >> $goal_index_path
                    else
                        # new add, so >>
                        all_part="$time_part $index_part"
                        echo $all_part >> $goal_index_path
                    fi
                    # show the content you add
                    echo "->:"
                    echo "$all_part"
                    # renew the goal_list_path
                    array_line=($all_part)
                    for index in ${array_line[@]}
                    do
                        if [ ${#index} -le 3 ]; then
                            # read the gaol through the index
                            sed -n "/^${index}\./,/^$/p" $goal_list_dir/goal-a.txt >> $goal_list_path
                        fi
                    done
                    ;;
                "help")
                    # action_status_show
                    action_status_show $mode $goal_index $action_full_name "show goals help"
                    echo " --------------------------------- help option ---------------------------------" 
                    echo "a/y/n/d/w/m ->: all/yes/not/day/week/month's goals, vim xxx"
                    echo
                    echo "a-/y-/n-/d-/w-/m- ->: all/yes/not/day/week/month's goals, cat xxx"
                    echo
                    echo "[1-...] ->: show the indox of the goal, for example the 88.goal"
                    echo
                    echo "help ->: give the help information"
                    echo
                    echo " -------------------------------------------------------------------------------" 
                    ;;

                *)
                # check if the goal index, right-> show the goal, not-> make the error
                    if [ -f $goal_path ]; then
                        vim $goal_path
                    else
                        echo "Error: the <$2> not exist! Fail to show the goal!"
                    fi
                    ;;
            esac
            ;;
            
        #}}}       
        "gc") # goal create 
        #{{{
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "create"

            # create the new goal
            ## read the counter first
            counter_line_1=$(head -1 $counter_path)
            goal_number=${counter_line_1##*:}
            ### vim open the file
            let goal_number_new=goal_number+1
            create_goal_path=$goal_all_dir/$goal_number_new.goal
            cp $goal_list_dir/goal-template.txt $create_goal_path
            sed -i "/^\*/s/\*/${goal_number_new}/g" $create_goal_path
            vim $create_goal_path
            # check the number of the goals
            goal_number_new_check=$(ls $goal_all_dir | wc -w)
            if [ ! "$goal_number_new_check" == "$goal_number_new" ];then
                echo "The goals number may be wrong! For counter: $goal_number_new_check, but the index: $goal_number_new"
            fi
            sed -i "/^1/s/:${goal_number}/:${goal_number_new_check}/g" $counter_path

            # after ceate the goal, run the < love -> command to renew the goal of all!
            love -
            ;;
        #}}}
        # show the action/quesion/task/conclusion/progress
        "a" | "q" | "t" | "c" | "p") # action
        #{{{   
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "show"
            sed -n "/^>>$1/,/^<<$1/p" $goal_path # use the ">>$1 and the <<$1" as the anchor
                ;;
        #}}}
        # add the action/quesion/task/conclusion/progress
        "aa" | "qa" | "ta" | "ca" | "pa") # action
        #{{{
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "add"
            # get the number of them
            number_line=$(sed -n "/^-> .*${action_full_name}.*:.*[0-9].*$/p" $goal_path)
            x_number=${number_line##*:}
            let x_number_new=x_number+1
            # then replace the nubmer
            sed -i "/^-> .*${action_full_name}.*[0-9]\{1,3\}$/s/[0-9]\{1,3\}/${x_number_new}/g" $goal_path
            #
            echo "Add the $action_full_name: GOOD JOB ^_^"
            read -e append_content
            # if is the aa, insert the time before the append_content
            if [ "$1" == "aa" ]; then
                time_start=$(date "+%Y/%m/%d %X")
                append_content="$time_start - xxx\\n$append_content"  # add the time and the new line before the content
            fi
            # add the number oder to the append_content
            append_content="($x_number_new) $append_content"
            sed -i "/^<<${1:0:1}/i${append_content}" $goal_path # insert above the last line fo the action
            sed -i "/^<<${1:0:1}/{x;p;x}" $goal_path # insert the newline 
            sed -n "/^>>${1:0:1}/,/^<<${1:0:1}/p" $goal_path # use the ">>$1 and the <<$1" as the anchor
            ;;
        #}}}
        "aa+") # add the time to the action
        #{{{
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "end action"
            echo "---> Done!"
            time_end=$(date "+%X")
            sed -i "s/xxx/${time_end}/g" $goal_path
            # show the finished action
            number_line=$(sed -n "/^-> .*${action_full_name}.*:.*[0-9].*$/p" $goal_path)
            x_number=${number_line##*:}
            #sed -n "/^($x_number)/,/^<<a/p" $goal_path
            end_line=$(sed -n '/^<<a/{=;p}' $goal_path)
            let end_before_line_number=end_line-1
            sed -n "/([$number_line]).*:.*:.*/,${end_before_line_number}p" $goal_path
            ;;
        #}}}

        "note") # use the temp, for each goal
            # goal_note_dir
            goal_index=$(cat $goal_index_dir/goal_current.index 2>/dev/null)
            if [ -z "$goal_index" ];then
                echo "No goal index, please set the goal index first, uset the command < * gs c+>"
            else
                goal_note_dir=~/mygithub/tmux_treasure/${mode}/miscellaneous/goal_${goal_index}
                goal_note_path=$goal_note_dir/note.txt
                if [ ! -d $goal_note_dir ];then
                    mkdir $goal_note_dir
                fi
                if [ ! -f $goal_note_path ]; then
                    touch $goal_note_path
                fi
            fi
            cd $goal_note_dir
            vim $goal_note_path
            ;;
        
        "help")
        #{{{
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "help"
            echo " --------------------------------- help option ---------------------------------" 
            echo "gs xxx ->: show the goals"
            echo
            echo "gc ->: create the goals"
#            echo
#            echo "a/q/t/c/p/v ->: action/question/task/conclusion/progress/verbose(open the goal file)"
            echo
            echo "aa/qa/ta/ca/pa ->: add the action/question/task/concludion/progress "
            echo
            echo "help ->: show the help information"
            echo
            echo " -------------------------------------------------------------------------------" 
            ;;
        #}}}
        *)
        #{{{
            # action_status_show
            action_status_show $mode $goal_index $action_full_name "Hello, world"
            #echo "Error: no command < $2 >, please use the <help> to get more information!"
            ;;
        #}}}
    esac

    # >>> some custom part for the specifying goal <<<
    case "$mode" in
        "c++")
            ;;

        "python")
            ;;

        "vim")
            ;;

        "markdown")
            ;;

        "cc")
            ;;

        "isp")
            ;;

        "mars")
            ;;

        "mars3")
            ;;

        "shell")
            ;;

        "paper")
            ;;

        "project")
            ;;
            
        "fun")
            ;;

        "chore")
            ;;

        "English")
            case "$1" in
                "w-e")
                    # the word enchancment
                    English_word_enhancement_path=~/mygithub/tmux_treasure/English/word_enhancement.txt
                    vim $English_word_enhancement_path
                    ;;

                "s-e")
                    # the sentence enchancement
                    English_sentence_enhancement_path=~/mygithub/tmux_treasure/$mode/sentence_enhancement.txt
                    vim $English_sentence_enhancement_path
                    ;;

                "help")
                    ;;
            esac
            ;;

        *)
            ;;

    esac
}
#}}}

# >>>>>>>>>>>>>>>> the main script <<<<<<<<<<<<<<<<<<<<<
#{{{
# just check the session_list's argument
echo "${sessions_list[@]}" | grep -wq "$1" >/dev/null
if [ "$?" == 0 ];then
    # check the $1, make sure that into session or create the new session
    tmux ls 2>/dev/null | grep "$1" >/dev/null
    if [ "$?" == 0 ]; then
        tmux_action="into"
        echo " >> into $1"
    else
        tmux_action="create"
        echo " >> create $1"
    fi
fi

case "$1" in
    "c++")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_cpp 
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "python")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_python
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "vim")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_vim
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "shell")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_shell
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "cc")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_cc
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "markdown")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_markdown
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "isp")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_isp
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "mars")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_mars
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "mars3")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_mars3
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "project")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
         # create the tmux layout
            tmux_project
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "paper")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_paper
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "fun")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_entertainment
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "English")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_English
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "work")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_work
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "type")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_type
            # check the file if exists, if not touch the files
            create_mode_dir $1 
        fi
        ;;
    #}}}

    "chore")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_chore
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "plan")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_plan
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "ssh")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_ssh
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "code")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_code
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "question")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_question
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "cmake")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1
        else
            # create the tmux layout
            tmux_cmake
            # check the file if exists, if not touch the files
            create_mode_dir $1
        fi
        ;;
    #}}}

    "clock")
    #{{{
        # set the environment variable
        echo "export mode=$1" > $mode_control_path
        if [ "$tmux_action" == "into" ]; then
            tmux attach -t $1\; clock # into the mode, and then show the clock
        else
            # create the tmux layout
            tmux_clock
        fi
        ;;
    #}}}

    "kill-all")
    #{{{
        tmux kill-server >/dev/null 2>&1
        if [ "$?" == 0 ];then
            echo "Successfully to kill all the sessions!"
        else
            echo "No tmux sessions to kill!"
        fi
        ;;
    #}}}

    "kill")
    #{{{
        tmux kill-session -t $2 >/dev/null 2>&1
        if [ "$?" == 0 ];then
            echo "Successfully to kill: $2"
        else
            echo "No tmux sessions to kill: $2!"
        fi
        ;;
    #}}}

    "ls")
    #{{{
        # list all the existent sessions
        has_or_not=0
        mark_task_has_or_not="-"
        tmux ls > $install_dir/temp.txt 2>&1 && has_or_not=1
        if [ -z "$2" ] && [ "$has_or_not" == 1 ]; then
            while read -r line
            do
                echo ${line%%:*}
            done < $install_dir/temp.txt
        elif [ -z "$2" ] && [ "$has_or_not" == 0 ]; then
            echo "No tmux sessions!"
        elif [ "$2" == "all" ];then
            # check the task has or not
            for task in ${sessions_list[@]}
            do
                grep -qw $task $install_dir/temp.txt
                if [ "$?" == 0 ]; then
                    echo -e " (+) ${GREEN}$task${NOCOLOR}"
                else
                    echo -e " (-) $task"
                fi
            done
        else
            echo "I don't know what are you doing?"
        fi
        ;;
    #}}}

    "go-love")
    #{{{
        cd $source_dir
        echo "->:${source_dir}"
        ;;
    #}}}

    "go-install")
    #{{{
        cd $install_dir
        echo "->:${install_dir}"
        ;;
    #}}}

    "go-goal")
    #{{{
        cd ~/mygithub/tmux_treasure/${mode}
        echo "->:~/mygithuu/tmux_treasure/${mode}"
        ;;
    #}}}

    "love")
    #{{{
        vim $source_name
        echo "Remember to execute the < love reinstall > to make it effect!"
        ;;
    #}}}

    "reinstall"|"ri")
    #{{{
        # to install the file again to cover the original file
        path_record=$(pwd)
        clear
        love go-love
        ./install.sh && echo "----------------- reinstall successfully --------------------" && cd $path_record
        ;;
    #}}}

    "mode")
    #{{{
        # show the mode
        echo "mode ->: $mode"
        ;;
    #}}}

    "you")
    #{{{
        clear
        # show the important message, the mode, your day goal, your progress
        # read the index of the today
        today_date=$(date "+%Y/%m/%d")
        today_goal_index=$(grep "$today_date" $goal_index_dir/goal-d.index 2>/dev/null)
        if [ -z "$today_goal_index" ];then
            today_goal_promote="Not set"
        else
            today_goal_promote=${today_goal_index#* }
        fi
        # get the current goal promote
        current_goal_promote=$(cat $goal_index_dir/goal_current.index 2>/dev/null)
        if [ -z "$current_goal_promote" ];then
            current_goal_promote="Not set"
        fi
        # the message stored in the file
        echo -e "|-------------------------------------------------------------------------------"
        echo -e "|                        ${PURPLE} Good luck, guy!${NOCOLOR}               ($(date "+%Y/%m/%d %a %X"))"
        # use the sed to read the message and then show the message
        echo -e "|-------------------------------------------------------------------------------"
        echo -e "|  ${YELLOW}Mode${NOCOLOR}: ${RED}$mode${NOCOLOR}"
        echo -e "|"  
        echo -e "|  ${YELLOW}Today Goal${NOCOLOR}: $today_goal_promote"
        echo -e "|" 
        echo -e "|  ${YELLOW}Current Goal${NOCOLOR}: $current_goal_promote"
        echo -e "|" 
        echo -e "|  ${YELLOW}Tips${NOCOLOR}: "
        echo -e "|-------------------------------------------------------------------------------"
        # show the goal through the goal index
        # the current goal show
        echo -e "|< ${GREEN}Current Goal${NOCOLOR} >"
        if [ "$current_goal_promote" == "Not set" ];then
            echo "| Note: current goal index not set!"
        else
            # read the goal's progress first in the goal_all_dir/$index.goal
            goal_progress_line=$(sed -n "/^->.*progress.*:/p" $goal_all_dir/${current_goal_promote}.goal)
            goal_progress=${goal_progress_line//[^0-9\/]/}
            goal_progress=${goal_progress/\//\\/}
            # index + progress
            show_goal_prefix="${current_goal_promote}. [${goal_progress}]"
            sed -n "/^${current_goal_promote}/,/^$/s/^${current_goal_promote}.*Goal.*:/| ${show_goal_prefix} /p" $goal_list_dir/goal-a.txt
        fi
        echo "|"
        # today goal show
        echo -e "|< ${GREEN}Today Goal${NOCOLOR} >"
        if [ -z "$today_goal_index" ]; then
            echo "| Note: today goal index not set!"
        else
            goal_index_list=($today_goal_promote)
            for index in ${goal_index_list[@]}
            do
                # read the goal's progress first in the goal_all_dir/$index.goal
                goal_progress_line=$(sed -n "/^->.*progress.*:/p" $goal_all_dir/${index}.goal)
                goal_progress=${goal_progress_line//[^0-9\/]/}
                goal_progress=${goal_progress/\//\\/}
                # read the goal from the goal_list_dir/goal-a.txt
                #echo $index
                sed -n "/^${index}/,/^$/s/^${index}.*Goal.*:/| ${index}\. [${goal_progress}] /p" $goal_list_dir/goal-a.txt
            done
        fi
        # show the current action
        echo "|"
        echo -e "|< ${GREEN}Current Action${NOCOLOR} >"
        action_flag=$(sed -n '/^([0-9].*:.*:.*xxx/p' $goal_all_dir/${current_goal_promote}.goal)
        if [ -z "$action_flag" ];then
            echo "| Note: no action now!"
        else
            sed -n '/^([0-9].*:.*:.*xxx/,/^$/s/^/| /p' $goal_all_dir/${current_goal_promote}.goal
        fi
        echo -e "|-------------------------------------------------------------------------------"
        ;;
    #}}}

    "mode-select")
    #{{{
        # select mode
        # check the $2, if the valid mode
        echo ${sessions_list[@]} | grep -qw "$2"
        if [ "$?" == 0 ]; then
            echo "mode ->: $2"
            export mode=$2
        else
            echo "Note: Invalid mode <$2>"
        fi
        ;;
    #}}}

    "action")
    #{{{
        # this is the action, the most important part
        action $2 $3 $4
        ;;
    #}}}

    "renew-goal-list" | "-")
    #{{{
        # renew the goal lists, including the goals number, the goals finished and not finished
        # scan the directory and then counter them
        num_all=0
        num_finished=0
        num_not_finished=0
        # the goal_list_x path
        goal_alllist_path=$goal_list_dir/goal-a.txt
        goal_finished_path=$goal_list_dir/goal-y.txt
        goal_notfinished_path=$goal_list_dir/goal-n.txt
        # empty the file
        echo "" > $goal_alllist_path
        echo "" > $goal_finished_path
        echo "" > $goal_notfinished_path
        # loop 
        for i in $(ls $goal_all_dir | sort -h)
        do 
            # add the prefix
            i=$goal_all_dir/$i # xxx/xx.goal
            let num_all+=1
            # check the goals's progress if the xxx/xxx, only if the xxx+xxx=20, that is finished
            progress_value=$(sed -n '/^->.*progress.*/s/[^0-9/]//gp' $i) # locate the line and then delete the other character
            #echo $progress_value
            # then read the goals and store it as the string
            #goal-info=$(sed -n '1,/^$/p' $i)
            #echo -e $goal-info >> $goal_alllist_path
            sed -n '1,/^$/p' $i >> $goal_alllist_path
            #
            if [ ! "$progress_value" == "10/10" ]; then
               let num_not_finished+=1
               sed -n '1,/^$/p' $i >> $goal_notfinished_path
               #echo -e $goal-info >> $goal_notfinished_path # add the goal to the not finished
           else
               sed -n '1,/^$/p' $i >> $goal_finished_path
               #echo -e $goal-info >> $goal_finished_path # add the goal to the finished
            fi
        done
        let num_finished=num_all-num_not_finished
        # renew the counter
        sed -i "/^2/s/:.*/:${num_finished}/g" $counter_path
        sed -i "/^3/s/:.*/:${num_not_finished}/g" $counter_path
        #
        echo -e "----------------- ${RED}$mode${NOCOLOR} | ${YELLOW}Goal information${NOCOLOR} -----------------"
        echo -e "(*) ${CYAN}ALL${NOCOLOR}: $num_all "
        echo
        echo -e "(+) ${GREEN}YES${NOCOLOR}: $num_finished "
        echo
        echo -e "(-) ${RED}NOT${NOCOLOR}: $num_not_finished "
        echo
        echo -e "----------------------------------------------------------"
        ;;
    #}}}

    "help")
    #{{{
        clear
        echo -e "${YELLOW}-------------------------------> OPTION <---------------------------------------${NOCOLOR}"
        echo -e "${GREEN}: cc->:${NOCOLOR} create or into the cc tmux session"
        echo
        echo -e "${GREEN}: vim->:${NOCOLOR} create or into the vim tmux session"
        echo
        echo -e "${GREEN}: c++->:${NOCOLOR} create or into the c++ tmux session"
        echo
        echo -e "${GREEN}: python->:${NOCOLOR} create or into the python tmux session"
        echo
        echo -e "${GREEN}: markdown->:${NOCOLOR} create or into the markdown tmux session"
		echo
        echo -e "${GREEN}: isp->:${NOCOLOR} create or into the isp tmux session"
        echo
        echo -e "${GREEN}: mars->:${NOCOLOR} create or into the mars tmux session"
        echo
        echo -e "${GREEN}: mars3->:${NOCOLOR} create or into the mars3 tmux session"
        echo
        echo -e "${GREEN}: shell->:${NOCOLOR} create or into the shell tmux session"
        echo
        echo -e "${GREEN}: fun->:${NOCOLOR} create or into the fun tmux session"
        echo
        echo -e "${GREEN}: project->:${NOCOLOR} create or into the project tmux session"
        echo
        echo -e "${GREEN}: paper->:${NOCOLOR} create or into the paper tmux session"
        echo
        echo -e "${GREEN}: kill-all->:${NOCOLOR} the same as the <tmux kill-server>, to kill all the sessions"
        echo
        echo -e "${GREEN}: kill->:${NOCOLOR} for example: love kill chore, just like the tmux kill-session -t chore."
        echo
        echo -e "${GREEN}: go-love->:${NOCOLOR} go to the source dir: ~/mygithub/shell-script/..."
        echo
        echo -e "${GREEN}: go-install->:${NOCOLOR} go to the install dir: ~/opt/.../..."
        echo
        echo -e "${GREEN}: go-goal->:${NOCOLOR} go to the goal dir: ~/mygithub/tmux_treasure/..."
        echo
        echo -e "${GREEN}: love->:${NOCOLOR} edit the tmux-manager.sh"
        echo
        echo -e "${GREEN}: ls [all]->:${NOCOLOR} list all the existent sessions, is with the all argument, show all"
        echo
        echo -e "${GREEN}: mode->:${NOCOLOR} show the mode, for example the c++, vim..."
        echo
        echo -e "${GREEN}: help->:${NOCOLOR} show the help information"
        echo
        echo -e "${YELLOW}--------------------------------------------------------------------------------${NOCOLOR}"
        ;;
    #}}}

    "@")
    #{{{
    # the var
    goal_all_mode_dir=~/mygithub/tmux_treasure/ALL
    goal_all_mode_path=~/mygithub/tmux_treasure/ALL/goal_all_mode.txt
    goal_all_format_path=~/mygithub/tmux_treasure/ALL/goal_all_format.txt
    # test if the file exeists
    if [ ! -f $goal_all_mode_path ];then
        touch $goal_all_mode_path
    fi
    #
    if [ "$2" == "@" ];then
        #echo "" > $goal_all_mode_path
        echo "========== ALL GOAL (renew time: $(date "+%Y/%m/%d %X"))==========" > $goal_all_mode_path
        # scan the whole file of the .../goal-a.txt again
        for i in $(find $goal_all_mode_dir/../ -name "goal-a.txt")
        do
            mode_name=${i#*../}
            mode_name=${mode_name%%/*}
            if [ -f $goal_all_format_path ];then
                cat $goal_all_format_path >> $goal_all_mode_path 2>/dev/null
            else
                echo "------------> $mode_name <------------" >> $goal_all_mode_path
            fi
            echo "#{{{" >> $goal_all_mode_path
            cat $i >> $goal_all_mode_path 2>/dev/null
            echo "#}}}" >> $goal_all_mode_path
            # replace the mode to the real mode name
            sed -i "/---.*mode.*---/s/mode/${mode_name}/" $goal_all_mode_path
        done
    fi
    # show the file of the goal_all_mode
    vim $goal_all_mode_path
    ;;
    #}}}

    "more")
    #{{{
        # represent that there are more than one mode to open
        let args_index=1
        for arg in $@
        do
            if [ $args_index -lt 2 ];then
                let args_index+=1
                continue
            else
                love $arg
                #tmux detach
                #tmux send-keys 'tmux detach'
            fi
        done
        ;;
    #}}}
    
    *)
    #{{{
        echo "Error: No such tmux task!"
        ;;
    #}}}
esac
#}}}
