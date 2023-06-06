#! /bin/bash


function yn_sh(){
            echo "$1"
                while :
                do
                    read -e -p "> " yn_option
                    yn_opt=$yn_option
                    if [[ "$yn_option" == "y" ]] || [[ "$yn_option" == "yes" ]] ; then
                        if [[ -n ${yn_sh[y]} ]] && [[ -z ${yn_sh[yes]} ]]; then
                            exec ${yn_sh[y]}
                        elif [[ -z ${yn_sh[y]} ]] && [[ -n ${yn_sh[yes]} ]]; then
                            exec ${yn_sh[yes]}
                        elif [[ -n ${yn_sh[y]} ]] && [[ -n ${yn_sh[yes]} ]]; then
                            exec ${yn_sh[y]} 
                        else
                            echo "Command to option \"y/yes\" not defined."
                        fi
                        break
                    elif ([[ "$yn_option" == "n" ]] || [[ "$yn_option" == "no" ]]) ||
                         ([[ "$yn_opt" == "n" ]] || [[ "$yn_opt" == "no" ]]); then
                        if [[ -n ${yn_sh[n]} ]] && [[ -z ${yn_sh[no]} ]]; then
                            exec ${yn_sh[n]}
                        elif [[ -z ${yn_sh[n]} ]] && [[ -n ${yn_sh[no]} ]]; then
                            exec ${yn_sh[no]}
                        elif [[ -n ${yn_sh[n]} ]] && [[ -n ${yn_sh[no]} ]]; then
                            exec ${yn_sh[n]} 
                        else
                            echo "Command to option \"n/no\" not defined."
                        fi
                        break
                    fi
                    echo "Please, write \"y/yes\" or \"n/no\""
                    continue
                done
        }

