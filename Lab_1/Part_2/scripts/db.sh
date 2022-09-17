#!/bin/bash

# File configuration
typeset fileName=users.db
typeset fileDir=../data
typeset filePath=$fileDir/$fileName

# store input in variable
INPUT_COMMAND=$1

# check db file and create if does not exists
if [[ "$INPUT_COMMAND" != "help" && "$INPUT_COMMAND" != "" && ! -f $filePath ]]; then
    read -r -p "users.db file does not exist. Do you want to create it? [Y/n] " answer
    answer=${answer,,}
    if [[ "$answer" =~ ^(yes|y)$ ]]; then
        touch $filePath
        echo "File ${fileName} created."
    else
        echo "File ${fileName} must be created in order to continue." >&2
        exit 1
    fi
fi

# check if string conatins only latin letters
function validateLatinLetters {
    if [[ $1 =~ ^[A-Za-z_]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# REQ 1
# add in DB file
function addUser {
    # take user name
    echo "Enter the user name: "
    read userName

    # validate user name
    validateLatinLetters $userName
    if [[ "$?" == 1 ]]; then
        echo "Name must have only latin letters. Try again."
        exit 1
    fi

    # take user role
    echo "Enter the user role: "
    read userRole

    # validate user role
    validateLatinLetters $userRole
    if [[ "$?" == 1 ]]; then
        echo "Role must have only latin letters. Try again."
        exit 1
    fi

    # store data in DB file
    echo "${userName}, ${userRole}" >>$filePath
}

# REQ 2
# prints help
function help {
    echo "db.sh [command]"
    echo
    echo "Commands available:"
    echo
    echo "add       Adds a new line to the users.db. Script must prompt user to type a
                    username of new entity. After entering username, user must be prompted to
                    type a role."
    echo "backup    Creates a new file, named" $filePath".backup which is a copy of
                    current" $fileName
    echo "find      Prompts user to type a username, then prints username and role if such
                    exists in users.db. If there is no user with selected username, script must print:
                    “User not found”. If there is more than one user with such username, print all
                    found entries."
    echo "list      Prints contents of users.db in format: N. username, role
                    where N – a line number of an actual record
                    Accepts an additional optional parameter inverse which allows to get
                    result in an opposite order – from bottom to top"
}

# REQ 3
# backup db file
function backupFile {
    backupFileName=$(date +'%Y-%m-%d-%H-%M-%S')-users.db.backup
    cp $filePath $fileDir/$backupFileName

    echo "File backup completed..."
}

# REQ 4
# take latest backup file and restore users.db
function restoreFile {
    latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

    if [[ ! -f $latestBackupFile ]]; then
        echo "No backup file found."
        exit 1
    fi

    cat $latestBackupFile >$filePath

    echo "File restored from latest backup file."
}

# REQ 5
# find user from db file
function findUser {
    echo "Enter username to search: "
    read userName

    output=$(awk -F, -v x=$userName '$1 ~ x' $filePath)
    echo $output

    if [[ "$output" == "" ]]; then
        echo "User not found."
        exit 1
    fi
}

# REQ 6 & 7
inverseParam="$2"
echo $inverseParam
function listUser {
    if [[ $inverseParam == "--inverse" ]]; then
        cat --number $filePath | tac
    else
        cat --number $filePath
    fi
}

case $INPUT_COMMAND in
    # REQ 1
    add) addUser ;;

    # REQ 3
    backup) backupFile ;;

    # REQ 4
    restore) restoreFile ;;

    # REQ 5
    find) findUser ;;

    # REQ 6 & 7
    list) listUser ;;

    # REQ 2
    help | '' | *) help ;;
esac
