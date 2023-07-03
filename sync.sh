#! /bin/bash

<<<<<<< HEAD
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
=======
SYNC_install_dir=$HOME/.config/sync.sh

## including data
    source  $SYNC_install_dir/config/cfile

# SYNC
    function sync() {
## Auxiliary Functions 
        function cmd_function(){
            if [[ -n "$1" ]]; then
                exec $1
            fi
        }

        function sync_core(){ 
            echo "Synchronizing \"$1\" with \"$2\"..."
            if [[ -n $3 ]]; then
                sudo rsync -av --progress --delete --exclude-from $3 $1 $2
            else
                sudo rsync -av --progress --delete $1 $2
            fi
            echo "-------------------------"
        }

>>>>>>> a7fef8e (...)
        function create_dir(){
            echo "Target directory \"$2\" does not exists. Create it? (y/n)"
                    while :
                    do
                        read -e -p "> " create_dir
                        if [[ "$create_dir" == "y" ]] || [[ "$create_dir" == "yes" ]]; then
                            echo "Creating \"$2\"..."
<<<<<<< HEAD
                            mkdir -p $2
                            sync_core $1 $2
                            break
                        elif [[ "$create_dir" == "n" ]] || [[ "$create_dir" == "no" ]]; then
                            echo "Target directory was not create. Exiting..."
=======
                            mkdir -p $3
                            sync_core $1 $2 $3
                            break
                        elif [[ "$create_dir" == "n" ]] || [[ "$create_dir" == "no" ]]; then
                            echo "Target directory was not created."
                            echo "Aborting..."
>>>>>>> a7fef8e (...)
                            break
                        fi
                        echo "Please, write y/yes or n/no"
                        continue
                    done
<<<<<<< HEAD
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
=======
        } 

        function sync_dir_file(){
            if [[ -d "$1" ]] && [[ -d "$2" ]]; then
                sync_core $1 $2 $3
            elif [[ -d "$2" ]] && [[ -f "$1" ]] ||
                 [[ -f "$2" ]] && [[ -d "$1" ]]; then
                echo "You are trying to sync a dir with a file."
            elif [[ -f "$2" ]] && [[ -f "$1" ]]; then
                sync_core $1 $2 $3
            elif [[ -d "$2" ]] || [[ ! -d "$2" ]]; then
                create_dir $1 $2 $3
            fi
        }

        function sync_push(){
            echo "Entering in $1..."
            cd $1
            echo "Moving to branch \"$4\"..."
            git branch -m $4
            echo "Pulling remote \"$3\" from branch \"$4\"..."
            git pull $3 $4
>>>>>>> a7fef8e (...)
            echo "Adding the files..."
            git add .
            echo "Commiting..."
            git commit -m "$2"
<<<<<<< HEAD
            echo "Pulling remote \"$3\" from branch \"$4\"..."
            git pull $3 $4
=======
>>>>>>> a7fef8e (...)
            echo "Pushing remote \"$3\" to branch \"$4\"..."
            git push $3  $4
            echo "Done!"
        }
## SYNC Function Propertly
### clean temporary files
<<<<<<< HEAD
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
=======
        if [[ "$1" == "--config" ]] || [[ "$1" == "-c" ]]; then
                echo "executing the config file..."
### display help
        elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
                cat $SYNC_install_dir/config/help.txt 
        elif [[ "$1" == "--clean" ]] || [[ "$1" == "-cl" ]]; then
            echo "Cleaning temporary files..."
            find $HOME -type f -iname ".*.*.??????" -delete
            echo "Done!"
### local-local sync for files
        elif [[ "$1" == "--files" ]] || [[ "$1" == "-f" ]]; then
            for block in ${SYNC_blocks[@]}; do
                if [[ "$block" == "files" ]]; then
                    declare -i bound_1
                    bound_1=${SYNC_max[$block]}
                    for (( j=0; j <= $bound_1; j++ )); do
                        declare -i bound_2
                        bound_2=${SYNC_max_cmd_before[$block,$j]}
                        for (( k=0; k <= $bound_2; k++ )); do
                            cmd_function ${SYNC_cmd_before[$block,$j,$k]}
                        done
                        exclude_file=$SYNC_install_dir/files/excludes/${block}_$j
                        if [[ -n "$exclude_file" ]]; then
                            sync_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            sync_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} 
                        fi
                        declare -i bound_3
                        bound_3=${SYNC_max_cmd_after[$block,$j]}
                        for (( l=0; l <= $bound_3; l++ )); do
                            cmd_function ${SYNC_cmd_after[$block,$j,$l]}
                        done
                    done
                fi
            done

### local-local sync for dirs
        elif [[ "$1" == "--dirs" ]] || [[ "$1" == "-d" ]]; then
            for block in ${SYNC_blocks[@]}; do
                if [[ ! "$block" == "files" ]]; then
                    declare -i bound_1
                    bound_1=${SYNC_max[$block]}
                    for (( j=0; j <= $bound_1; j++ )); do
                        declare -i bound_2
                        bound_2=${SYNC_max_cmd_before[$block,$j]}
                        for (( k=0; k <= $bound_2; k++ )); do
                            cmd_function ${SYNC_cmd_before[$block,$j,$k]}
                        done
                        exclude_file=$SYNC_install_dir/files/excludes/${block}_$j
                        if [[ -n "$exclude_file" ]]; then
                            sync_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            sync_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} 
                        fi
                        declare -i bound_3
                        bound_3=${SYNC_max_cmd_after[$block,$j]}
                        for (( l=0; l <= $bound_3; l++ )); do
                            cmd_function ${SYNC_cmd_after[$block,$j,$l]}
                        done
                    done
                fi
            done
### local-git sync
        elif [[ "$1" == "--git" ]] || [[ "$1" == "-g" ]] && [[ -z $2 ]]; then
            for parent in ${SYNC_git_parent[@]}; do
                parent_name=${parent##*/}
                declare -i bound_1
                bound_1=${SYNC_max_git[$parent_name]}
                for (( j=0; j <= $bound_1; j++ )); do
                    declare -i bound_2
                    bound_2=${SYNC_max_git_cmd_before[$parent_name,$j]}
                    for (( k=0; k <= $bound_2; k++ )); do
                        cmd_function ${SYNC_git_cmd_before[$parent_name,$j,$k]}
                    done
                    exclude_file=$SYNC_install_dir/files/excludes_git/${parent_name}_$j
                    if [[ -n "$exclude_file" ]]; then
                            sync_dir_file ${SYNC_git_source[$parent_name,$j]} ${SYNC_git_target[$parent_name,$j]} $exclude_file
                        else
                            sync_dir_file ${SYNC_git_source[$parent_name,$j]} ${SYNC_target[$parent_name,$j]} 
                        fi
                    declare -i bound_3
                    bound_3=${SYNC_max_git_cmd_after[$parent_name,$j]}
                    for (( m=0; m <= $bound_3; m++ )); do
                        cmd_function ${SYNC_git_cmd_after[$parent_name,$j,$m]}
                    done
                done
           done
### initialize git dirs
        elif [[ "$1" == "--git-init" ]] ||
             [[ "$1" == "-gi" ]] || 
             ([[ "$1" == "--git" ]] && [[ "$2" == "--init" ]]) ||
             ([[ "$1" == "-g" ]] && [[ "$2" == "-i" ]]); then
                for parent in ${SYNC_git_parent[@]}; do
                    parent_name=${parent##*/}
                    declare -i bound
                    bound=${SYNC_max_git_init[$parent_name]}
                   for (( j=0; j <= $bound; j++ )); do
                       SYNC_git_init_path=$parent/${SYNC_git_init[$parent_name,$j]}
                       if [[ -d $SYNC_git_init_path ]]; then
                            cd $SYNC_git_init_path 
                            has_git=$(find . -maxdepth 1 -name ".git" -type d )
                            if [[ -z $has_git ]]; then
                                echo "Initializing git-dir \"$SYNC_git_init_path\"..."
                                git init
                            else
                                echo "Directory \"$SYNC_git_init_path\" already git initialized. Re-initialize it? (y/n)"
>>>>>>> a7fef8e (...)
                                while :
                                do
                                    read -e -p "> " reinitialize_dir
                                    if [[ "$reinitialize_dir" == "y" ]] || [[ "$reinitialize_dir" == "yes" ]]; then
<<<<<<< HEAD
                                        echo "Re-initilizing dir \"${git_init_dir[$i,$j]}\"..."
                                        git init
                                        break
                                    elif [[ "$reinitialize_dir" == "n" ]] || [[ "$reinitialize_dir" == "no" ]]; then
                                        echo "Directory \"${git_init_dir[$i,$j]}\" was not re-initialized. Exiting..."
=======
                                        echo "Re-initilizing dir \"$SYNC_git_init_path\"..."
                                        git init
                                        break
                                    elif [[ "$reinitialize_dir" == "n" ]] || [[ "$reinitialize_dir" == "no" ]]; then
                                        echo "Directory \"$SYNC_git_init_path\" was not re-initialized."
                                        echo "Aborting..."
>>>>>>> a7fef8e (...)
                                        break
                                    fi
                                    echo "Please, write y/yes or n/no"
                                    continue
                                done
                        
                            fi
<<<<<<< HEAD
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
                       ([[ "$4" == "$j" ]] || [[ "$4" == "${git_remote[$i,$j]}" ]]); then
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
            
=======
                        elif [[ -f ${SYNC_git_init_path} ]]; then
                            echo "\"$SYNC_git_init_path\" is a file..."
                        else
                            echo "Directory \"$SYNC_git_init_path\" does not exists."
                        fi
                    done
                done
### add remotes
        elif [[ "$1" == "--git-remote-add" ]] || [[ "$1" == "-gra" ]]; then
            for parent in ${SYNC_git_parent[@]}; do
                parent_name=${parent##*/}
                declare -i bound
                bound=${SYNC_max_git_init[$parent_name]}
                for (( j=0; j <= $bound; j++ )); do
                    if [[ -n "${SYNC_git_remote_add[$parent_name,$j]}" ]]; then
                        has_git=$(find . -maxdepth 1 -name ".git" -type d )
                        if [[ -n $has_git ]]; then
                            echo "Adding \"${SYNC_git_remote[$parent_name,$j]}\" as a remote to \"${SYNC_git_remote_add[$parent_name,$j]}\"..."
                            cd $parent/${SYNC_git_init[$parent_name,$j]}
                            git remote add ${SYNC_git_remote[$parent_name,$j]} ${SYNC_git_remote_add[$parent_name,$j]}
                        else
                            echo "The directory \"$parent/${SYNC_git_init[$parent_name,$j]}\" is not a git initialized dir."
                            echo "Try \"sync --git-init ${SYNC_git_init[$parent_name,$j]}\"."
                        fi
                    else
                        echo "Destination for remote \"${SYNC_git_remote[$parent_name,$j]}\" was not defined."
                    fi
                done
            done
### full local-local and local-git sync           
        elif [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
            sync -cl
            sync -f 
            sync -d 
            sync -g
### push git initialized dirs
        elif [[ "$1" == "--push" ]] || [[ "$1" == "-p" ]] && [[ -z "$2" ]]; then
            for parent in ${SYNC_git_parent[@]}; do
                parent_name=${parent##*/}
                declare -i bound
                bound=${SYNC_max_git_init[$parent_name]}
                for (( j=0; j <= $bound; j++ )); do
                    sync_push $parent/${SYNC_git_init[$parent_name,$j]} ${SYNC_git_commit[$parent_name,$j]} ${SYNC_git_remote[$parent_name,$j]} ${SYNC_git_branch[$parent_name,$j]}
                done
            done
        fi

### sync from aliases
        for block in ${SYNC_blocks[@]}; do
            declare -i bound_1
            bound_1=${SYNC_max[$block]}
            for (( j=0; j <= $bound_1; j++ )); do
                if [[ "$1" == "${SYNC_alias[$block,$j]}" ]]; then
                    for (( j=0; j <= $bound_1; j++ )); do
                        declare -i bound_2
                        bound_2=${SYNC_max_cmd_before[$block,$j]}
                        for (( k=0; k <= $bound_2; k++ )); do
                            cmd_function ${SYNC_cmd_before[$block,$j,$k]}
                        done
                        exclude_file=$SYNC_install_dir/files/excludes/${block}_$j
                        sync_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        declare -i bound_3
                        bound_3=${SYNC_max_cmd_after[$block,$j]}
                        for (( l=0; m <= $bound_3; l++ )); do
                            cmd_function ${SYNC_cmd_after[$block,$j,$l]}
                        done
                    done
                fi
            done
        done

### sync from git aliases
        for parent in ${SYNC_git_parent[@]}; do
            parent_name=${parent##*/}
            declare -i bound_1
            bound_1=${SYNC_max_git[$parent_name]}
            for (( j=0; j <= $bound_1; j++ )); do
                if [[ "$1" == "${SYNC_alias[$block,$j]}" ]]; then
                    declare -i bound_2
                    bound_2=${SYNC_max_git_cmd_before[$parent_name,$j]}
                    for (( k=0; k <= $bound_2; k++ )); do
                        cmd_function ${SYNC_git_cmd_before[$parent_name,$j,$k]}
                    done
                    exclude_file=$SYNC_install_dir/files/excludes_git/${parent_name}_$j
                    sync_dir_file ${SYNC_git_source[$parent_name,$j]} ${SYNC_git_target[$parent_name,$j]} $exclude_file
                    declare -i bound_4
                    bound_4=${SYNC_max_git_cmd_after[$parent_name,$j]}
                    for (( m=0; m <= $bound_4; m++ )); do
                        cmd_function ${SYNC_git_cmd_after[$parent_name,$j,$m]}
                    done
                 fi
            done
        done

### push from git initialized dir name
        for parent in ${SYNC_git_parent[@]}; do
            declare -i bound
            parent_name=${parent##*/}
            bound=${SYNC_max_git_init[$parent_name]}
            for (( j=0; j <= $bound; j++ )); do
                if ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) && 
                   ([[ "$2" == "$i" ]] || [[ "$2" == "${SYNC_git_init[$parent_name,$j]}" ]]); then
                        sync_push $parent/${SYNC_git_init[$parent_name,$j]} ${SYNC_git_commit[$parent_name,$j]} ${SYNC_git_remote[$parent_name,$j]} ${SYNC_git_branch[$parent_name,$j]}
                fi
            done
        done

### push from git initialized dir name AND remote 
        for parent in ${SYNC_git_parent[@]}; do
            parent_name=${parent##*/}
            declare -i bound
            bound=${SYNC_max_git_init[$parent_name]}
            for (( j=0; j <= $bound; j++ )); do
                if ( ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) && ([[ "$2" == "$parent_name" ]]) &&
                     ([[ "$3" == "--remote" ]] || [[ "$3" == "-r" ]]) && 
                     ([[ "$4" == "$j" ]] || [[ "$4" == "${SYNC_git_remote[$parent_name,$j]}" ]]) ) ||
                   ( ([[ "$3" == "--push" ]] || [[ "$3" == "-p" ]]) && ([[ "$4" == "$parent_name" ]]) &&
                     ([[ "$1" == "--remote" ]] || [[ "$1" == "-r" ]]) &&
                     ([[ "$2" == "$j" ]] || [[ "$2" == "${SYNC_git_remote[$parent_name,$j]}" ]]) ); then
                       sync_push $parent/${SYNC_git_init[$parent_name,$j]} ${SYNC_git_commit[$parent_name,$j]} ${SYNC_git_remote[$parent_name,$j]} ${SYNC_git_branch[$parent_name,$j]}
                fi
            done
        done
### push from remote
        for parent in ${SYNC_git_parent[@]}; do
            parent_name=${parent##*/}
            declare -i bound
            bound=${SYNC_max_git_init[$parent_name]}
            for (( j=0; j <= $bound; j++ )); do
                if  ( ([[ "$1" == "--push" ]] || [[ "$1" == "-p" ]]) &&
                     ([[ "$2" == "--remote" ]] || [[ "$2" == "-r" ]]) && 
                     ([[ "$3" == "${SYNC_git_remote[$parent_name,$j]}" ]]) ) ||
                     ([[ "$1" == "-pr" ]] && [[ "$2" == "${SYNC_git_remote[$parent,$j]}" ]]) ; then
                       sync_push $parent/${SYNC_git_init[$parent_name,$j]} ${SYNC_git_commit[$parent_name,$j]} ${SYNC_git_remote[$parent_name,$j]} ${SYNC_git_branch[$parent_name,$j]}
                fi
            done
        done            
>>>>>>> a7fef8e (...)
### push from branch

## unset auxiliaty functions
    unset -f create_dir
    unset -f sync_core
    unset -f sync_dir_file
<<<<<<< HEAD
=======
    unset -f create_dir_git
    unset -f sync_core_git
    unset -f sync_dir_file_git
>>>>>>> a7fef8e (...)
    unset -f sync_push
}

# ALIASES
    alias syncf="sync -f"
    alias syncd="sync -d"
    alias syncg="sync -g"
    alias syncgi="sync -gi"
<<<<<<< HEAD
=======
    alias syncgra="sync -gra"
>>>>>>> a7fef8e (...)
    alias synca="sync -a"
    alias syncp="sync -p"
    alias syncap="sync -a && sync -p"
    alias syncc="sync -c"
    alias synch="sync -h"
    alias syncl="sync -cl"

