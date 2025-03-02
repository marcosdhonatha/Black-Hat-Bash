#!/bin/bash

VARIABLE_ONE="nostartch"
VARIABLE_TWO="nostartch"

if [[ "${VARIABLE_ONE}" == "${VARIABLE_TWO}" ]]; then
	echo "They are equal!"
else
	echo "They are not equal!"
fi

