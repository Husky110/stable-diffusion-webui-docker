#!/bin/bash
#Menu options
options[0]="Rerun install-script and Download-Container"
options[1]="A1111-WebUI (GPU)"
options[2]="A1111-WebUI (CPU)"
options[3]="ComfyUI (GPU)"
options[4]="ComfyUI (CPU)"
options[5]="InvokeAI (GPU)"
options[6]="InvokeAI (CPU)"

#Actions to take based on selection
function ACTIONS {
    if [[ ${choices[0]} ]]; then
        ./install.sh
    fi
    if [[ ${choices[1]} ]]; then
        docker compose --profile auto up
    fi
    if [[ ${choices[2]} ]]; then
        docker compose --profile auto-cpu up
    fi
    if [[ ${choices[3]} ]]; then
        echo 'TO BE DONE'
    fi
    if [[ ${choices[4]} ]]; then
        echo 'TO BE DONE'
    fi
    if [[ ${choices[5]} ]]; then
        echo 'TO BE DONE'
    fi
    if [[ ${choices[6]} ]]; then
        echo 'TO BE DONE'
    fi
}

#Variables
ERROR=" "

#Clear screen for menu
clear

#Menu function
function MENU {
    echo "Menu Options"
    for NUM in ${!options[@]}; do
        echo "[""${choices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
    done
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Please make your selection with 00-06. Multiple selections possible (press Enter to confirm): " -n2 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done

ACTIONS
