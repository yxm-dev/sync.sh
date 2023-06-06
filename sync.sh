#! /bin/bash

install_dir="$HOME/.config/sync.sh"

# DATA
## declaring arrays
    declare -a source_file
    declare -a target_file
    declare -a source_dir
    declare -a target_dir
    declare -a alias_dir
    declare -a source_file
    declare -a target_file
    declare -a git_dir
    declare -a Ngit_dir
    declare -a Ngit_st
    declare -A git_init_dir
    declare -A git_remote
    declare -A git_branch
    declare -A git_commit
    declare -A source_dir_git
    declare -A target_dir_git
    declare -A alias_git
## including data
    source  $install_dir/cfile
## defining inverse arrays
    declare -A git_remote_name
    for s in ${git_remote[@]}; do
        for i in ${!git_dir[@]}; do
            for (( j=0; j<=${Ngit_dir[$i]}; j++ )); do
                if [[ "${git_remote[$i,$j]}" == "$s" ]]; then
                    git_remote_name[$i,$j]="ok"
                else
                    git_remote_name[$i,$j]=""
                fi
            done
        done
    done

# SYNC
    function sync() {
## Auxiliary Functions
        function sync_core(){
            echo "Synchronizing \"$1\" with \"$2\"..."
            sudo rsync -av --progress --delete --exclude '.git/*' --exclude 'README.md' $1 $2
        }
        function create_dir(){
            echo "Target directory \"$2\" does not exists. Create it? (y/n)"
                    while :
                    do
                        read -e -p "> " create_dir
                        if [[ "$create_dir" == "y" ]] || [[ "$create_dir" == "yes" ]]; then
                            echo "Creating \"$2\"..."
                            mkdir -p $2
                            sync_core $1 $2
                            break
                        elif [[ "$create_dir" == "n" ]] || [[ "$create_dir" == "no" ]]; then
                            echo "Target directory was not create. Exiting..."
                            break
                        fi
                        echo "Please, write y/yes or n/no"
                        continue
                    done
        }
        function sync_dir_file(){
            if [[ -d "$2" ]] && [[ -d "$1" ]]; then
                sync_core $1 $2
            elif [[ -d "$2" ]] && [[ -f "$1" ]] ||
                 [[ -f "$2" ]] && [[ -d "$1" ]]; then
                echo "You are trying to sync a dir with a file."
            elif [[ -f "$2" ]] && [[ -f "$1" ]]; then 
                sync_core $1 $2
            elif [[ -d "$1" ]] || [[ ! -d "$2" ]]; then
                create_dir $1 $2
            fi
        }
        function sync_push(){
            echo "Entering in $1..."
            cd $1
            echo "Changing to branch \"$4\"..."
            git branch -m $4
            echo "Adding the files..."
            git add .
            echo "Commiting..."
            git commit -m "$2"
            echo "Pulling remote \"$3\" from branch \"$4\"..."
            git pull $3 $4
            echo "Pushing remote \"$3\" to branch \"$4\"..."
            git push $3  $4
            echo "Done!"
        }
## SYNC Function Propertly
### local-local sync from aliases
            for i in ${!alias_dir[@]}; do
                if [[ "$1" == "${alias_dir[$i]}" ]]; then
                    sync_core ${source_dir[$i]} ${target_dir[$i]}
                fi
            done
            for i in ${!git_dir[@]}; do
                 for (( j=0; j<=${Ngit_st[$i]}; j++ )); do
                    if [[ "$1" ==  "${alias_git[$i,$j]}" ]]; then
                        sync_dir_file ${source_dir_git[$i,$j]} ${target_dir_git[$i,$j]}
                    fi
                done
            done
### local-git sync from git initialized dir name 
            for i in ${!git_dir[@]}; do
                if ([[ "$1" == "--git" ]] || [[ "$1" == "-g" ]]) && 
                   ([[ "$2" == "$i" ]] || [[ "$2" == "${git_dir[$i]}" ]]); then
                     for (( j=0; j<=${Ngit_st[$i]}; j++ )); do
                         sync_dir_file ${source_dir_git[$i,$j]} ${target_dir_git[$i,$j]}
                    done
                fi
            done
### push from git initialized dir name
            for i in ${!git_dir[@]}; do
                if ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) && 
                    ([[ "$2" == "$i" ]] || [[ "$2" == "${git_dir[$i]}" ]]); then
                    for (( j=0; j<=${Ngit_st[$i]}; j++ )); do
                        sync_push ${git_init_dir[$i,$j]} ${git_commit[$i,$j]} ${git_remote[$i,$j]} ${git_branch[$i,$j]}
                    done
                fi
            done
### push from git initialized dir name AND remote 
            for i in ${!git_dir[@]}; do
                for (( j=0; j<=${Ngit_dir[$i]}; j++ )); do
                    if ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) && 
                       ([[ "$2" == "$i" ]] || [[ "$2" == "$i" ]]) &&
                       ([[ "$3" == "--remote" ]] || [[ "$3" == "-r" ]]) &&
                       ([[ "$3" == "$j" ]] || [[ "$3" == "${git_remote[$i,$j]}" ]]); then
                        sync_push ${git_init_dir[$i,$j]} ${git_commit[$i,$j]} ${git_remote[$i,$j]}  ${git_branch[$i,$j]}
                    fi
                done
            done
### push from remote
            for s in ${git_remote[@]}; do
                for i in ${!git_dir[@]}; do
                    for (( j=0; j<=${Ngit_dir[$i]}; j++ )); do
                        if ( ( ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) &&
                            ([[ "$2" == "--remote" ]] || [[ "$2" == "-r" ]]) ) && 
                            [[ "$3" == "$s" ]] ) ||
                            ([[ "$1" == "-pr" ]] && [[ "$2" == "$s" ]]); then
                                if [[ "$s" == "${git_remote[$i,$j]}" ]]; then
                                    sync_push ${git_init_dir[$i,$j]} ${git_commit[$i,$j]} ${git_remote[$i,$j]} ${git_branch[$i,$j]}
                                fi
                        fi
                    done
                done
            done
            
### push from branch

### clean temporary files
            if [[ "$1" == "--clean" ]] || [[ "$1" == "-cl" ]]; then
                echo "cleaning temporary files..."
                find $HOME -type f -iname ".*.*.??????" -delete
                echo "done!"
### local-local sync all dirs
            elif [[ "$1" == "--dirs" ]] || [[ "$1" == "-d" ]]; then
                for j in ${!alias_dir[@]}; do
                    sync_dir_file ${source_dir[$j]} ${target_dir[$j]}
                done
### local-local sync all files
            elif [[ "$1" == "--files" ]] || [[ "$1" == "-f" ]]; then
                for k in  ${!source_file[@]}; do
                    sync_dir_file ${source_file[$k]} ${target_file[$k]}
                done
### initialize git dirs
            elif [[ "$1" == "--git-init" ]] ||
                 [[ "$1" == "-gi" ]] || 
                 [[ "$1" == "--git" ]] && [[ "$2" == "--init" ]] ||
                 [[ "$1" == "-g" ]] && [[ "$2" == "-i" ]]; then
                for i in ${!git_dir[@]}; do
                     for (( j=0; j<=${Ngit_dir[$i]}; j++ )); do
                        if [[ -d ${git_init_dir[$i,$j]} ]]; then
                            cd ${git_init_dir[$i,$j]}
                            x=$(find . -maxdepth 1 -name ".git" -type d )
                            if [[ -z $x ]]; then
                                echo "Initializing git-dir \"${git_init_dir[$i,$j]}\"..."
                                git init
                            else
                                echo "Directory \"${git_init_dir[$i,$j]}\" already initialized. Re-initialize it? (y/n)"
                                while :
                                do
                                    read -e -p "> " reinitialize_dir
                                    if [[ "$reinitialize_dir" == "y" ]] || [[ "$reinitialize_dir" == "yes" ]]; then
                                        echo "Re-initilizing dir \"${git_init_dir[$i,$j]}\"..."
                                        git init
                                        break
                                    elif [[ "$reinitialize_dir" == "n" ]] || [[ "$reinitialize_dir" == "no" ]]; then
                                        echo "Directory \"${git_init_dir[$i,$j]}\" was not re-initialized. Exiting..."
                                        break
                                    fi
                                    echo "Please, write y/yes or n/no"
                                    continue
                                done
                        
                            fi
                        elif [[ -f ${git_init_dir[$i,$j]} ]]; then
                            echo "\"${git_init_dir[$i,$j]}\" is a file..."
                        fi
                    done
                done
### local-git sync all git initialized dirs
            elif [[ "$1" == "--git" ]] || [[ "$1" == "-g" ]] && [[ -z $2 ]]; then
                for i in ${!git_dir[@]}; do
                     for (( j=0; j<=${Ngit_st[$i]}; j++ )); do
                        sync_dir_file ${source_dir_git[$i,$j]} ${target_dir_git[$i,$j]}
                    done
                done
### full local-local and local-git sync           
            elif [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
                sync -cl
                sync -f 
                sync -d 
                sync -g
            elif [[ "$1" == "--push" ]] || [[ "$1" == "-p" ]] && [[ -z "$2" ]]; then
                for i in ${!git_dir[@]}; do
                    for (( j=0; j<=${Ngit_dir[$i]}; j++ )); do
                         sync_push ${git_init_dir[$i,$j]} ${git_commit[$i,$j]} ${git_remote[$i,$j]}  ${git_branch[$i,$j]}
                    done
                done
### start configuration
            elif [[ "$1" == "--config" ]] || [[ "$1" == "-c" ]]; then
                    echo "executing the config file..."
### display help
            elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
                    echo "showing help..."
### display error
            else
                    echo "option not defined for the \"sync\" function."
            fi
## unset auxiliaty functions
    unset -f create_dir
    unset -f sync_core
    unset -f sync_dir_file
    unset -f sync_push
}

# ALIASES
    alias syncf="sync -f"
    alias syncd="sync -d"
    alias syncg="sync -g"
    alias syncgi="sync -gi"
    alias synca="sync -a"
    alias syncp="sync -p"
    alias syncap="sync -a && sync -p"
    alias syncc="sync -c"
    alias synch="sync -h"
    alias syncl="sync -cl"

