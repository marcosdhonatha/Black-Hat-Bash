#!/bin/bash

DIR_NAME="dir_test"

mkdir "${DIR_NAME}"

if [[ -f "${DIR_NAME}" ]] || [[ -d "${DIR_NAME}" ]];then
	echo "${DIR_NAME} is a file or a directory"
fi



