#!/bin/sh

echo ".------------------------"
echo -e "| .pre.sh begin.\n"

EM_TIMESTAMP1="$(date -d "@$EM_TIMESTAMP" "+%Y-%m-%d %T %:z")"
EM_YEAR1="$(date -d "@$EM_TIMESTAMP" "+%Y")"


mv src/skeleton.sh "src/${EM_PRJ_NAME}"
sed -i \
    "s/@@skeleton@@/${EM_PRJ_NAME}/g;`
    `s/@@timestamp@@/${EM_TIMESTAMP1}/g;`
    `s/@@username@@/${EM_USER_NAME}/g;`
    `s/@@useremail@@/${EM_USER_EMAIL}/g;`
    `s/@@year@@/${EM_YEAR1}/g" \
        "src/${EM_PRJ_NAME}"

sed -i "s/@@skeleton@@/${EM_PRJ_NAME}/g;" "src/Makefile"

[ -f .gitignore ] && echo "${EM_SCRIPT_NAME}.log" >> .gitignore 

echo -e "\n| .pre.sh end."
echo "'------------------------"
