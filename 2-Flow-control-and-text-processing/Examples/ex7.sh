#!/bin/bash

SIGNAL_TO_STOP_FILE="stoploop"

while [[ ! -f "${SIGNAL_TO_STOP_FILE}" ]];do
	echo "The file ${SIGNAL_TO_STOP_FILE} was not find..."
	echo "Checking again in 2 seconds..."
	echo "------------------------------------------------"
	sleep 2
done

echo "The file was found! Exiting..."

