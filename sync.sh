#! /bin/bash

# SYNC FUNCTION
    function sync() {
## Includes
    source ${BASH_SOURCE%/*}/pkgfile
    if [[ -f "$PKG_install_dir/config/syncrc" ]]; then
        source $PKG_install_dir/config/syncrc
    else
        echo "error: A configuration file was not identified."
        echo "Try:"
        echo "* \"sync -t\" to create it from a template;"
        echo "* \"sync -c\" to generate it with the help of a TUI interface."
    fi
## Auxiliary Functions 
        function SYNC_cmd(){
            if [[ -f "$2" ]]; then
                if [[ -n "$2" ]]; then
                    eval "$(cat $2)"
                fi
            fi
        }
        function SYNC_src(){ 
            echo "Synchronizing \"$1\" with \"$2\"..."
            if [[ -n $3 ]]; then
                sudo rsync -av --progress --delete --exclude-from $3 $1 $2
            else
                sudo rsync -av --progress --delete $1 $2
            fi
            echo "-------------------------"
        }
        function SYNC_create_dir(){
            echo "Target directory \"$2\" does not exists. Create it? (y/n)"
                    while :
                    do
                        read -e -p "> " SYNC_create_dir
                        if [[ "$SYNC_create_dir" == "y" ]] || [[ "$SYNC_create_dir" == "yes" ]]; then
                            echo "Creating \"$2\"..."
                            mkdir -p $2
                            SYNC_src $1 $2 $3
                            break
                        elif [[ "$SYNC_create_dir" == "n" ]] || [[ "$SYNC_create_dir" == "no" ]]; then
                            echo "Target directory was not created."
                            echo "Aborting..."
                            break
                        fi
                        echo "Please, write y/yes or n/no"
                        continue
                    done
        } 
        function SYNC_dir_file(){
            if [[ -d "$1" ]] && [[ -d "$2" ]]; then
                SYNC_src $1 $2 $3
            elif [[ -d "$2" ]] && [[ -f "$1" ]] ||
                 [[ -f "$2" ]] && [[ -d "$1" ]]; then
                echo "You are trying to sync a dir with a file."
            elif [[ -f "$2" ]] && [[ -f "$1" ]]; then
                SYNC_src $1 $2 $3
            elif [[ -d "$2" ]] || [[ ! -d "$1" ]]; then
                SYNC_create_dir $1 $2 $3
            fi
        }
# SYNC Function Propertly
### enter in interactive mode
        if [[ -z "$1" ]]; then
            echo "interactive mode..."
### enter in configuration mode
        elif [[ "$1" == "--config" ]] || [[ "$1" == "-c" ]] || [[ "$1" == "-cfg" ]]; then
                echo "configuration mode..."
### display help
        elif [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
                cat $PKG_install_dir/config/src/help.txt 
        elif [[ "$1" == "--clean" ]] || [[ "$1" == "-cl" ]]; then
            echo "Cleaning temporary files..."
            find $HOME -type f -iname ".*.*.??????" -delete
            echo "Done!"
### sync files
        elif [[ "$1" == "--files" ]] || [[ "$1" == "-f" ]]; then
            for block in ${SYNC_blocks[@]}; do
                if [[ "$block" == "files" ]]; then
                    declare -i bound
                    bound=${SYNC_max[$block]}
                    for (( j=1; j <= $bound; j++ )); do
                        SYNC_cmd $PKG_install_dir/files/cmd_before/${block}_$j
                        exclude_file=$PKG_install_dir/files/excludes/${block}_$j
                        if [[ -f "$exclude_file" ]]; then
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} 
                        fi
                        SYNC_cmd $PKG_install_dir/files/cmd_after/${block}_$j
                    done
                fi
            done
### sync dirs
        elif [[ "$1" == "--dirs" ]] || [[ "$1" == "-d" ]]; then
            for block in ${SYNC_blocks[@]}; do
                if [[ ! "$block" == "files" ]]; then
                    declare -i bound
                    bound=${SYNC_max[$block]}
                    for (( j=1; j <= $bound; j++ )); do
                        SYNC_cmd $PKG_install_dir/files/cmd_before/${block}_$j
                        exclude_file=$PKG_install_dir/files/excludes/${block}_$j
                        if [[ -f "$exclude_file" ]]; then
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} 
                        fi
                        SYNC_cmd $PKG_install_dir/files/cmd_after/${block}_$j
                    done
                fi
            done
        elif [[ "$1" == "--all" ]] || [[ "$1" == "-a" ]]; then
            sync -cl
            sync -f
            sync -d
### "-t", "-tpl" and "--template" to create a template for the config
        elif [[ "$1" == "-t" ]] || [[ "$1" == "-tpl" ]] || [[ "$1" == "--template" ]]; then
            if [[ -f "$PKG_install_dir/config/syncrc" ]]; then
                echo "There already exists a configuration file."
                read -p -r "> " replace_config
                while :
                do
                    echo "Want to replace it by a template? (y/n)"
                    if [[ "$replace_config" == "yes" ]] || [[ "$replace_config" == "y" ]]; then
                        cp $PKG_install_dir/files/syncrc.tpl $PKG_install_dir/config/syncrc
                        break
                    elif [[ "$replace_config" == "no" ]] || [[ "$replace_config" == "n" ]]; then
                        Aborting...
                        break
                    else
                        echo "Please, write y/yes or n/no."
                        continue
                    fi
                done
            else
                cp $PKG_install_dir/files/syncrc.tpl $PKG_install_dir/config/syncrc
                echo "A template for the configuration file was created."
                cd $PKG_install_dir/files
            fi
### "-l" and "--list" to list blocks and aliases, etc.
        elif [[ "$1" == "-l" ]] || [[ "$1" == "--list" ]]; then
            if [[ -z "$2" ]]; then
                echo "Try:"
                echo "* \"sync -l -b\" to get the list of blocks;"
                echo "* \"sync -l -p\" to get the list of pairs."
### "-l -b" to list the blocks
            elif [[ "$2" == "-b" ]] || [[ "$2" == "--blocks" ]]; then
                if [[ -n "${SYNC_blocks[@]}" ]]; then
                    echo "The following is the list blocks:"
                    echo ""
                    for block in ${SYNC_blocks[@]}; do
                        echo "* $block"
                    done
                else
                    echo "None block was defined."
                fi
### "-l -a" to list aliases
            elif [[ "$2" == "-p" ]] || [[ "$2" == "--pair" ]] || [[ "$2" == "--pairs" ]]; then
                echo "The following is the list of source/target pairs with their aliases:"
                for block in ${SYNC_blocks[@]}; do
                    declare -i bound
                    bound=${SYNC_max[$block]}
                    for (( j=1; j <= $bound; j++ )); do
                        echo "${SYNC_alias[$block,$j]}: ${SYNC_source[$block,$j]} -> ${SYNC_target[$block,$j]}"
                    done
                done
            else
                echo "Option not defined for the \"sync()\" function."
            fi
        else
### sync from blocks
            for block in ${SYNC_blocks[@]}; do
                if [[ "$1" == "$block" ]]; then
                    declare -i bound
                    bound=${SYNC_max[$block]}
                    for (( j=1; j <= $bound; j++ )); do
                        SYNC_cmd $PKG_install_dir/files/cmd_before/${block}_$j
                        exclude_file=$PKG_install_dir/files/excludes/${block}_$j
                        if [[ -f "$exclude_file" ]]; then
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]}
                        fi
                        SYNC_cmd $PKG_install_dir/files/cmd_after/${block}_$j
                    done
                fi
            done
### sync from aliases
            for block in ${SYNC_blocks[@]}; do
                declare -i bound
                bound=${SYNC_max[$block]}
                for (( j=1; j <= $bound; j++ )); do
                    if [[ "$1" == "${SYNC_alias[$block,$j]}" ]]; then
                        SYNC_cmd $PKG_install_dir/files/cmd_before/${block}_$j
                        exclude_file=$PKG_install_dir/files/excludes/${block}_$j
                        if [[ -f "$exclude_file" ]]; then
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} $exclude_file
                        else
                            SYNC_dir_file ${SYNC_source[$block,$j]} ${SYNC_target[$block,$j]} 
                        fi
                        SYNC_cmd $PKG_install_dir/files/cmd_after/${block}_$j
                    fi
                done
            done
        fi
}

# ALIASES
    alias syncf="sync -f"
    alias syncd="sync -d"
    alias synca="sync -a"
    alias syncc="sync -c"
    alias synch="sync -h"
    alias syncl="sync -cl"
    alias syncl="sync -l"
    alias synclb="sync -l -b"
    alias synclp="sync -l -p"

