#! /bin/bash
#! /usr/bin/python

# add the alias

# define the functi{{2}
func_goal()
{
    arg1=$1
    arg2=$2
    arg3=$3
    # deal with the directories
    # check if exists the ~/mygithub/goal/
    goal_dir=~/mygithub/goal/
    goal-info_path=~/opt/myscript/wr-script/goal-info
    if [ ! -d "${goal_dir}" ]; then
        mkdir -p ${goal_dir}
        # copy the goal.list to the directory
        cp ${goal-info_path}/goal.list ${goal_dir}
        # mkdir that in the goal.list
        cd ${goal_dir}
        for line in $(cat "${goal_dir}/goal.list")
        do
            if [ ${line:0:2} == "./" ]; then
                mkdir ${line}
            fi
        done
    fi
    # the $2 can be the
    # list -> list all the goal
    # the specification goal, such as the code, English, reading and so on. and then jump to it;
    case ${arg2} in
        "list")
            # list all the goal
            echo -e "${YELLOW}------ GOALS ------${NOCOLOR}"
            for line in $(cat "${goal_dir}/goal.list")
            do
                if [ ${line:0:2} == "./" ]; then
                    line_rid_left=${line#*/}
                    line_rid_left_right=${line_rid_left%/}
                    # show the goal
                    echo -e "-> ${GREEN}${line_rid_left_right}${NOCOLOR}"
                fi
            done
            echo -e "${YELLOW}-------------------${NOCOLOR}"
            ;;

        "create")
            mkdir -p ${goal_dir}${arg3}
            # and then add the goal to the goal.list
            echo "./${arg3}/" >> "${goal_dir}/goal.list"
            echo "Create the goal: ${arg3} successfully!"
            ;;

        "help")
            clear
            echo -e "${GREEN}------ HELP INFORMATION ------${NOCOLOR}"
            echo
            echo -e "${GREEN}: list->${NOCOLOR}: list the all goal"
            echo
            echo -e "${GREEN}: create->${NOCOLOR}: create the new goal"
            echo
            echo -e "${GREEN}: help->${NOCOLOR}: show the command information"
            echo
            echo -e "${GREEN}: xxx(the goal)->${NOCOLOR}: show the specification goal"
            ;;

        *)
            if [ -d ${goal_dir}${arg2} ]; then
                cd ${goal_dir}${arg2}
                vim ${goal_dir}${arg2}
            else
                echo -e "${RED}Warming, ${arg2} not exist!${NOCOLOR}"
                echo -e "Note: you can use the ${GREEN}< wr goal creat xxx >${NOCOLOR} to create the goal directory"
            fi
            ;;

    esac

}

copy_sth()
{
    # the var
    file_dir=~/opt/myscript/wr-script/register-clipboard
    file_dir_source=$HOME/mygithub/shell-script/wr-script/register-clipboard
    # cygwin -> /dev/clipboard; others -> ~/opt/myscript/wr-script/middle_station.clipboard
    if [ "$(uname -o)" == "Cygwin" ];then
        middle_station=/dev/clipboard
    else
        middle_station=~/opt/myscript/wr-script/middle_station.clipboard
    fi

    if [ -z "$2" ];then
        # no the second argument, just to copy to the /dev/clipboard or the middle_station
        pwd | tr -d "\n" > $middle_station
    else
        case "$2" in
            "help")
                clear
                echo -e "${GREEN}------ wr -c help information ------${NOCOLOR}"
                echo -e "${GREEN}: (no argumetn)->${NOCOLOR}: copy the path to the middle_station."
                echo -e "${GREEN}: hlep->${NOCOLOR}: give the help information of the < wr -v xxx>."
                echo -e "${GREEN}: [a-z] ->${NOCOLOR}: copy the path to the register [a-z]."
                echo -e "${GREEN}: [a-z] - ->${NOCOLOR}: copy, register[a-z] -> middle_station."
                echo -e "${GREEN}: [a-z] [a-z] ->${NOCOLOR}: copy, register[a-z] -> register[a-z]."
                ;;

                *)
                if [ "$2" == "-" ]; then
                    file_path=$middle_station
                else
                    file_path=$file_dir/$2 # this is the file name
                fi
                file_path_source=$file_dir_source/$2 # this is the souce file name
                if [ -f $file_path ] || [ "$2" == "-" ]; then
                    # if the $3 exist, the register -> to the middle station
                    if [ -z "$3" ]; then
                        pwd | tr -d "\n" > $file_path # exist
                        # if exists the source directory, means that you have not deleted the source
                        if [ -f $file_path_source ]; then
                            pwd | tr -d "\n" > $file_path_source # exist
                        fi

                    elif [ "$3" == "-" ];then
                        # a...z -> middle_station, for example: a -> /dev/clipboard
                        cat $file_path > $middle_station
                    else
                        # copy to the other register <a-z>
                        # need to check if your input is the register
                        to_file_path=$file_dir/$3
                        if [ -f $to_file_path ]; then
                            cat $file_path > $to_file_path # exist
                        else
                            echo "Note: for the argument 3 you should input \"-\"or the <a-z>, instead of the $3!"
                        fi
                    fi
                    # and then renew the whole_path_information.list
                else
                    echo "\$2 must be the <a-z>, your input $2 is wrong!"
                fi
                ;;

        esac
    fi
}

past_sth()
{
    # the var
    file_dir=~/opt/myscript/wr-script/register-clipboard
    # cygwin -> /dev/clipboard; others -> ~/opt/myscript/wr-script/middle_station.clipboard
    if [ "$(uname -o)" == "Cygwin" ];then
        middle_station=/dev/clipboard
    else
        middle_station=~/opt/myscript/wr-script/middle_station.clipboard
    fi

    if [ -z "$2" ]; then
        # no the second argument, show the middle_sation
        cat $middle_station
        echo # output the new line
    else
        case "$2" in
            "go")
                dst_go=$(cat $middle_station)
                cd $dst_go
                echo "->$dst_go"
                ;;

            "list")
                # loop and then show all the file and the file's content
                for i in $file_dir/*
                do
                    content_path=$(cat $i)
                    # if the $3 is the all, then show all the register even it is empty
                    if [ -z "$content_path" ]  && [ "$3" != "all" ];then
                            continue
                    else
                        echo "${i##*/}: $content_path"
                    fi
                done
                ;;

            "help")
                clear
                echo -e "${GREEN}------ wr -v help information ------${NOCOLOR}"
                echo
                echo -e "${GREEN}: (no argument)->${NOCOLOR}: show the middle_station's path."
                echo
                echo -e "${GREEN}: list->${NOCOLOR}: list all the regsiter content, reg<a-z>."
                echo
                echo -e "${GREEN}: go->${NOCOLOR}: cd to the middle_station, for example cd cat$(/dev/clipboard)."
                echo
                echo -e "${GREEN}: hlep->${NOCOLOR}: give the help information of the < wr -v xxx>."
                echo
                echo -e "${GREEN}: [a-z] ->${NOCOLOR}: show the [a-z] register's content."
                echo
                echo -e "${GREEN}: [a-z] go ->${NOCOLOR}: cd to the register [a-z] path."
                ;;

                *)
                # check the file path
                file_path=$file_dir/$2
                if [ -f $file_path ]; then
                    # do something
                    if [ -z "$3" ]; then
                        # just show the path
                        #echo "${file_path##*/}: $(cat $file_path)"
                        echo "$(cat $file_path)"
                    elif [ "$3" == "go" ];then
                        cd $(cat $file_path)
                        echo "->$(pwd)"
                    fi
                else
                    echo "\$2 must be the <a-z>, your inpout $2 is wrong!"
                fi
                ;;

        esac
    fi
}

#check if there are the directory
dir_name=$(date "+%Y")/$(date "+%Y-%m")/$(date "+%m-%d")
# when you use the command: wr, it will creat the environment varialbe that records the path
# of the today_record path, so you can easily to open it inside the vim using the :e $p_today
export p_today=~/mygithub/everyday-record/${dir_name}/
#if you want to use the date-pointer's path, you have to specify the -p as the $2
if [ "$2" == "-p" ]; then
    dir_name=$(cat ~/opt/myscript/wr-script/date-pointer.txt)
    # check if $dir_name is empty
    if [ -z ${dir_name} ]; then
        echo -e "->${RDD}ERROR:${NOCOLOR}the dir_name is empty! Please key ctrl+c to stop!"
        read
    fi
elif [ "$2" == "-z" ]; then
    dir_name="compress"
fi
today_path=~/mygithub/everyday-record/${dir_name}
if [ ! -d "${today_path}" -o ! -f "${today_path}/plan.md" ]; then
    mkdir -p ${today_path}
    echo "creat the ${today_path} successfully!"
    separate_sign="=================================="
    touch ${today_path}/plan.md && echo -e  "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  PLAN\n${separate_sign}\n" > ${today_path}/plan.md
    touch ${today_path}/learn.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  LEARN\n${separate_sign}\n" > ${today_path}/learn.md
    touch ${today_path}/code.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  CODE\n${separate_sign}\n" > ${today_path}/code.md
    touch ${today_path}/question.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  QUESTION\n${separate_sign}\n" > ${today_path}/question.md
    touch ${today_path}/review.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  REVIEW\n${separate_sign}\n" > ${today_path}/review.md
    touch ${today_path}/idea.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  IDEA\n${separate_sign}\n" > ${today_path}/idea.md
    touch ${today_path}/temp.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  TEMP\n${separate_sign}\n" > ${today_path}/temp.md
    touch ${today_path}/diary.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  DIARY\n${separate_sign}\n" > ${today_path}/diary.md
    touch ${today_path}/code_task.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  CODE-TASK\n${separate_sign}\n" > ${today_path}/code_task.md
    touch ${today_path}/arragement.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  ARRAGEMENT\n${separate_sign}\n" > ${today_path}/arragement.md
    touch ${today_path}/record.md && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  RECORD\n${separate_sign}\n" > ${today_path}/record.md
    touch ${today_path}/type.pratice && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  PRATICE\n${separate_sign}\n" > ${today_path}/type.pratice
    touch ${today_path}/English.pratice && echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")  PRATICE\n${separate_sign}\n" > ${today_path}/English.pratice
    # add the todolist.md (copy the template to it );
    separate_sign_2="--------------------------------------"
    touch ${today_path}/todolist.md && echo -e "${separate_sign_2}\n$(date "+%Y-%m-%d %a %X") TODOLIST\n${separate_sign_2}" > ${today_path}/todolist.md
    cat ~/opt/myscript/wr-script/todolist/todolist.template >> ${today_path}/todolist.md
    echo "${today_path}/todolist.md" > ~/opt/myscript/wr-script/todolist/date-path.md
    # copy the type.template to the type.pratice
    cat ~/opt/myscript/wr-script/type.template >> ${today_path}/type.pratice
    echo $separate_sign_2 >> ${today_path}/type.pratice

    # if today is the  first day of the week, month, and year, and then creat the plan-w.md, plan-m.md and the plan-y.md
    python "$HOME/opt/myscript/wr-script/py/plan-w-m-y.py"
fi

# check the argumet and then open the corresponding file
case "$1" in

    "plan")
        # -w: week plan, -m: month plan, -y: year plan
        if [ "$2" == "-w" ]; then
            python "$HOME/opt/myscript/wr-script/py/plan-w-m-y.py" "-w"
        elif [ "$2" == "-m" ]; then
            python "$HOME/opt/myscript/wr-script/py/plan-w-m-y.py" "-m"
        elif [ "$2" == "-y" ]; then
            python "$HOME/opt/myscript/wr-script/py/plan-w-m-y.py" "-y"
        else
            vim ${today_path}/plan.md
        fi
        ;;

    "record")
        #record_path=/cygdrive/c/Users/${USER}/Desktop/study-app/data/everyday/$(date "+%Y")/$(date "+%Y-%m")/$(date "+%m-%d")/record.txt
        #vim ${record_path}
		vim ${today_path}/record.md
        ;;

    "arragement")
        #arragement_path=/cygdrive/c/Users/${USER}/Desktop/study-app/data/everyday/$(date "+%Y")/$(date "+%Y-%m")/$(date "+%m-%d")/plan.txt
        #vim ${arragement_path}
		vim ${today_path}/arragement.md
        ;;

    "learn")
        if [ "$2" == "-z" ]; then
            vim ${today_path}/learn-a.md
        else
            vim ${today_path}/learn.md
        fi
        ;;

    "code")
        if [ "$2" == "-z" ]; then
            vim ${today_path}/code-a.md
        else
            vim ${today_path}/code.md
        fi
        ;;

    "question")
        if [ "$2" == "-z" ]; then
            vim ${today_path}/question-a.md
        else
            vim ${today_path}/question.md
        fi
        ;;

    "temp")
        vim ${today_path}/temp.md
        ;;

    "diary")
        vim ${today_path}/diary.md
        ;;

    "code_task")
        vim ${today_path}/code_task.md
        ;;

    "review")
        if [ "$2" == "-z" ]; then
            vim ${today_path}/review-a.md
        else
            vim ${today_path}/review.md
        fi
        ;;

    "idea")
        if [ "$2" == "-z" ]; then
            vim ${today_path}/idea-a.md
        else
            vim ${today_path}/idea.md
        fi
        ;;

    "pointer-check")
        echo -e "Point to -> $(cat ~/opt/myscript/wr-script/date-pointer.txt)"
        ;;

    "pointer")
        dir_name=$2-$3/$3-$4
        pointer_path=~/mygithub/everyday-record/${dir_name}
        # check if the path exists?
        if [ -d "${pointer_path}" ]; then
            echo ${dir_name} > ~/opt/myscript/wr-script/date-pointer.txt
            echo -e "->Successfully points to the ${dir_name}"
        else
            echo -e "->${RED}ERROR${NOCOLOR}: ${dir_name} not exist! Fail!"
        fi
        ;;

    "go-e")
        # go to the everyday-record path
        #e_dest=~/mygithub/everyday-record/compress/
        e_dest=${today_path}/
        cd $e_dest
        echo "->: $e_dest"
        ;;

    "go-wr")
        # go to the everyday-record path
        wr_dest=~/mygithub/shell-script/wr-script/
        cd $wr_dest
        echo "->: $wr_dest"
        ;;

    "go-install")
        # go to the ~/opt/myscript/wr-script/
        install_dest=~/opt/myscript/wr-script/
        cd $install_dest
        echo "->: $install_dest"
        ;;

    "go-goal")
        # go to the /mygithub/goal/
        goal_dst=~/mygithub/goal/
        cd ${goal_dst}
        echo "->: ${goal_dst}"
        ;;
    "go-linux_basic_cfg")
        # go to the ~/mygithub/shell-script/linux-basic-cfg/
        linux_basic_cfg_path=~/mygithub/linux_basic_cfg/files.cfg
        cd $linux_basic_cfg_path
        ;;

    "merge")
        #cat ${today_path}/question.md >> ~/mygithub/everyday-record/compress/question-a.md
        #cat ${today_path}/learn.md >> ~/mygithub/everyday-record/compress/learn-a.md
        #cat ${today_path}/code.md >> ~/mygithub/everyday-record/compress/code-a.md
        # use the python script
        python ~/opt/myscript/wr-script/py/merge.py
        #echo "Good job! Has been merging xxx.md to xxx-a.md! Successfully!"
        ;;

    "all")
        vim ~/mygithub/everyday-record/compress/
        ;;

    "rest")
        . ~/opt/myscript/wr-script/font/rest.sh
        ;;

    "year")
        . ~/opt/myscript/wr-script/font/year.sh
        ;;

    "moyu")
        . ~/opt/myscript/wr-script/font/moyu.sh
        ;;

    "xiaban")
        wr merge
        cd ~/mygithub/everyday-record/
        . ~/mygithub/everyday-record/xiaban.sh
        ;;

    "todo")
        # first execute the rewrite program
        python ~/opt/myscript/wr-script/py/todo_score.py
        vim ${today_path}/todolist.md
        ;;

    "score")
        clear
        # first execute the rewrite program
        python ~/opt/myscript/wr-script/py/count_score.py $2
        #vim ${today_path}/todolist.md
        ;;

    "todo-cfg")
        cd ~/opt/myscript/wr-script/todolist/
        vim .
        ;;

    "todo-exe")
        echo "deprecated by hgj, just use the wr todo is ok!"
        #cd ~/opt/myscript/wr-script/todolist/src/
        #if [ ! -f r_c_w.exe ]; then
        #    g++ main.cpp util.cpp -o r_c_w.exe
        #fi
        #./r_c_w.exe && echo ">>>>>> Execute the program successfully! <<<<<<"
        #cd -
        #wr todo
        ;;

    "wr")
        vim ~/mygithub/shell-script/wr-script/write.sh
        ;;

    "goal")
        func_goal $1 $2 $3
        ;;

    "English")
        vim ${today_path}/English.pratice
        ;;

    "type")
        if [ -z $2 ] || [ "$2" == "-p" ]; then
            #open the type.pratice, the -p option is for the previous path depending on the date of the $(wr pointer-check)
             vim ${today_path}/type.pratice
        elif [ "$2" == "m" ]; then
             #open the type.template
             vim ~/opt/myscript/wr-script/type.template
        elif [ "$2" == "c" ]; then
             # copy the ~/opt/myscirpt/wr-script/type.template to the ~/mygithub/shell-script/wr-script/type.tempate
             cp ~/opt/myscript/wr-script/type.template ~/mygithub/shell-script/wr-script/type.template
             echo ":->Successfully renew the type.template!"
         elif [ "$2" == "renew" ]; then
             # copy the type.template to the type.pratice, because the type.tempate has been renew
             echo -e "${separate_sign}\n$(date "+%Y-%m-%d %a %X")\n${separate_sign}\n" > ${today_path}/type.pratice
             cat ~/opt/myscript/wr-script/type.template >> ${today_path}/type.pratice
             echo $separate_sign_2 >> ${today_path}/type.pratice
             echo ":->Has been renew the ${today_path}/type.pratice"
             # if you want to open it, add the $3
             if [ "$3" == "o" ]; then
                 vim ${today_path}/type.pratice
             fi
        else
             echo -e "Error: no the command: \" wr type $2 \""
        fi
        ;;

    "pretend")
        # execute the program
        ~/opt/myscript/wr-script/c++-interesting-program/pretend-to-do-something.exe $2 $3 $4
        ;;

    "reinstall")
        # to install the file again to cover the original file
        wr go-wr
        ./install.sh && echo "----------------- reinstall successfully --------------------"
        ;;

    "-")
        # go to the important place that you want
        vim $HOME/mygithub/goal/paper/determine_title_report.ddl
        ;;

    "-c")

        # pwd | tr -d "\n" > /dev/clipboard
        # call  the copy_sth()
        copy_sth $1 $2 $3
        ;;

    "-v")
        # >>>>>>>>>>>>>  obsolete <<<<<<<<<<<<<<<<<<<<<<
        ## if the $3 exist and equal to the "go", then jump to the path
        #if [ "$3" == "go" ];then
        #    cd $(cat /dev/clipboard)
        #    echo "->:$(pwd)"
        #else
        #    cat /dev/clipboard
        #    echo  # output the new line
        #fi
        # >>>>>>>>>>>>>>>>>>>>> <<<<<<<<<<<<<<<<<<<<<<
        # call the past_sth()
        past_sth $1 $2 $3
        ;;

    "preview_md_exe")
        # >>>>>>> the window's when-change.exe <<<<<<<<
        # the variables and the arguments
        typora_dir=/cygdrive/d/Typora
        when_changed_option=$3
        document_name=$2
        document_path=$(pwd)/$2

        # check the $2 argument
        echo "the document's name is the: ${document_name}"
        if [ -n "${document_name}" ]; then
            # the command
            cd $typora_dir # to the directory first
            # for the window, you can not use the ./ as the prefix
            when-changed.exe ${when_changed_option} "${document_path}" Typora.exe "${document_path}"
        else
            echo "Lack the document, fail to run!"
        fi
        echo "Finish to run!"
        ;;

    "preview_md")
        # >>>>>>>>>> fail to execute:
        # N) no matter what the when-changed is(the window or the unix), it will use the window's
        # python(python3.7 not the python3.8);
        # <<<<<<<<<

        # >>>>>>> the cygwin's when-change <<<<<<<<
        # the variables and the arguments
        typora_path=/cygdrive/d/Typora/Typora.exe
        when_changed_option=$3
        document_name=$2
        # cygwin_path -> window path
        document_path_cygwin=$(pwd)/$2
        document_path_window=$(cygpath -w "$(pwd)/$2")

        # check the $2 argument
        echo "the document's name is the: ${document_path_cygwin}"
        if [ -n "${document_name}" ]; then
            # the command
            #cd $typora_dir # to the directory first
            # in the unix, just to use the full path is ok to execute the typora
            # the typora is the window's program, it just recognize the window's path
            /usr/local/bin/when-changed ${when_changed_option} "${document_path_cygwin}" ${typora_path} "${document_path_window}"
            #/usr/local/bin/when-changed ${when_changed_option} "${document_path_cygwin}" echo "execute"
        else
            echo "Lack the document, fail to run!"
        fi
        echo "Finish to run!"
        ;;

    "fish")
        # execute the asciiquarium
        if [ "$(uname -o)" == "Cygwin" ];then
            echo "------ No Fish --------"
        else
            asciiquarium
        fi
        ;;

    "weather")
        duration=$2
        last_counter=$3
        if [ -z "$duration" ];then
            duration=10
        fi
        if [ -z "$last_counter" ];then
            last_counter=10
        fi
        for ((i=1; i<$last_counter; i++))
        do
            clear
            # show the weather and the date and the time
            exe_path=~/opt/myscript/wr-script/weather/show-weather.sh
            bash ${exe_path}
            sleep $duration
        done
        ;;

    "rain")
        select_mode=$2
        case "$select_mode" in
            "1")
                unimatrix -n -s 96 -l "q"
                ;;
            "2")
                unimatrix -n -c blue -l "q"
                ;;
            "3")
                unimatrix -c yellow -l "e"
                ;;
            *)
                #unimatrix -n -s 96 -l "o"
                unimatrix -n -c blue -s 66 -l "o"
                #unimatrix -n -c blue -s 10 -u "123689abcedfghijklmnopqrstuvwxyz!@#$%^&*"
                ;;
        esac
        ;;

    "gpu")
        # source the .bash_aliases file to get the aliases
        . ~/.bashrc
        # show the gpu's usage
        #gpu_usage=$(ssh $2 nvidia-smi | grep -io [0-9][0-9]*%)
        gpu_usage=$(c-$2 nvidia-smi | grep -io [0-9][0-9]*%)
        gpu_usage=${gpu_usage##* }
        echo "$2's usage is the $gpu_usage"
        ;;

    "help")
        clear
        echo -e "${YELLOW}-------------------------------> OPTION <---------------------------------------${NOCOLOR}"
        #echo -e "--------------------${GREEN}OPTION${NOCOLOR}--------------------"

        echo -e "${GREEN}: -->:${NOCOLOR} go to the direct place!"
        echo
        echo -e "${GREEN}: all->:${NOCOLOR} use .../compress/, you can edit the compress's file"
        echo
        echo -e "${GREEN}: fish->:${NOCOLOR} execute the command < asciiquarium > in the linux system"
        echo
        echo -e "${GREEN}: go-e->${NOCOLOR}: cd to the everyday-record"
        echo
        echo -e "${GREEN}: go-wr->${NOCOLOR}: cd to the write-scritp.sh"
        echo
        echo -e "${GREEN}: go-goal->${NOCOLOR}: cd to the goal directroy"
        echo
        echo -e "${GREEN}: go-linux_basic_cfg->${NOCOLOR}: cd to the linux_basic_cfg"
        echo
        echo -e "${GREEN}: goal xxx.md${NOCOLOR}: about the goal, you can use the command < wr goal help > for more information"
        echo
        echo -e "${GREEN}: gpu computer_name${NOCOLOR}: show the computer's gpu's usage"
        echo
        echo -e "${GREEN}: help->${NOCOLOR}: get the help"
        echo
        echo -e "${GREEN}: learn->${NOCOLOR}: go to the learn.md"
        echo
        echo -e "${GREEN}: code->${NOCOLOR}: go to the code.md"
        echo
        echo -e "${GREEN}: merge->${NOCOLOR}: merge the today's question, plan to the compress's directory"
        echo
        echo -e "${GREEN}: moyu->${NOCOLOR}: show the moyu as the screen"
        echo
        echo -e "${GREEN}: pointer-check->${NOCOLOR}: to show the pointer"
        echo
        echo -e "${GREEN}: pointer->${NOCOLOR}: year-month-day-> to set the pointer"
        echo
        echo -e "${GREEN}: pretend->${NOCOLOR}: run the fake program in the terminal to pretend to do something!"
        echo
        echo -e "${GREEN}: preview_md->${NOCOLOR}:(the cygwin mode)use the when-changed command, when you write the markdwon in the vim, save it, show in the typora immediately"
        echo
        echo -e "${GREEN}: preview_md_exe->${NOCOLOR}:(the window mode)use the when-changed command, when you write the markdwon in the vim, save it, show in the typora immediately"
        echo
        echo -e "${GREEN}: question->${NOCOLOR}: go the question.md"
        echo
        echo -e "${GREEN}: rain mode->${NOCOLOR}: emulate the rain in the screen"
        echo
        echo -e "${GREEN}: reinstall->${NOCOLOR}: reinstall the file, to cover the original file"
        echo
        echo -e "${GREEN}: rest->${NOCOLOR}: show the rest as the screen"
        echo
        echo -e "${GREEN}: score->${NOCOLOR}: get the score of the today, including the arragement, todolist, and so on!"
        echo
        echo -e "${GREEN}: temp->${NOCOLOR}: go the temp.md"
        echo
        echo -e "${GREEN}: diary->${NOCOLOR}: go the diary.md"
        echo
        echo -e "${GREEN}: code_task->${NOCOLOR}: go the code_task.md"
        echo
        echo -e "${GREEN}: record->${NOCOLOR}: go the record.md"
        echo
        echo -e "${GREEN}: arragement->${NOCOLOR}: go the arragement.md"
        echo
        echo -e "${GREEN}: review [-z]->${NOCOLOR}: go the review.md, if with -z, go to the merge file."
        echo
        echo -e "${GREEN}: todo->${NOCOLOR}: edit the todolist.md"
        echo
        echo -e "${GREEN}: todo-cfg->${NOCOLOR}: modify the todo configuration"
        echo
        echo -e "${GREEN}: todo-exe->${NOCOLOR}: execute the prgrom to read, count, and then write"
        echo
        echo -e -e "${GREEN}: type x y->${NOCOLOR}: 1) no x: open the type.pratice; 2) x=m: change the type.template manually;\n"\
        "             3) x=c: copy the ~/opt/.../type.template to the ~/mygithub/.../type.template;\n"\
        "             4)x=renew: renew the today's type.pratice, if the y=o, it will open the type.pratice"
        echo
        echo -e "${GREEN}: xiaban->${NOCOLOR}: Upload the file to the github reposity, and then off duty"
        echo
        echo -e "${GREEN}: weather->${NOCOLOR}: show the weather and the other information"
        echo
        echo -e "${GREEN}: wr->${NOCOLOR}:modify the write.sh"
        echo
        echo -e "${GREEN}: -c->${NOCOLOR}:copy something! Type <wr -c help> for more information!"
        echo
        echo -e "${GREEN}: -v->${NOCOLOR}:past something! Type <wr -v help> for more information!"
        echo
        echo -e "${YELLOW}--------------------------------------------------------------------------------${NOCOLOR}"
        ;;

    *)
        echo -e "-> ${RED}ERROR:${NOCOLOR} Wrong input! You can just input the following option:\n-> ${GREEN}OPTION:${NOCOLOR} plan, learn, code, question, temp, help, pointer %Y-%m-%d, pointer-check, go-e, go-wr, review, all, rest, todo, todo-cfg, todo-exe, type x... and so on "
        echo -e "${GREEN}You can use the wr help for more information!${NOCOLOR}"
        ;;
esac
