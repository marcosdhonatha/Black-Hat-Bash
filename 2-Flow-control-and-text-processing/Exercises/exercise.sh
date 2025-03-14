##################################################################################################
#################################### Exercise 2: Pinging a Domain ################################
##################################################################################################


# In this exercise, you’ll write a bash script that accepts two arguments: 
# a name (for example, mysite) and a target domain (for example, nostarch.com).
# The script should be able to do the following:

# 1. Throw an error if the arguments are missing and exit using the right exit code.
# 2. Ping the domain and return an indication of whether the ping was successful.
# To learn about the ping command, run man ping.
# 3. Write the results to a CSV file containing the following information:
# a. The name provided to the script
# b. The target domain provided to the script
# c. The ping result (either success or failure)
# d. The current date and time


#/bin/bash

if [[ "$#" != 2  ]]; then
	echo "You must provide two arguments to this script."
	echo "Example: ${0} mysite nostarch.com"
	exit 1
fi

NAME="${1}"
DOMAIN="${2}"
OUTPUT_FILE="results.csv"

# Write a CSV reader to the file
echo "STATUS,NAME,DOMAIN,DATE/TIME" > ${OUTPUT_FILE}

if ping -c 1 "${DOMAIN}" &> /dev/null; then
	echo "Sucess,${NAME},${DOMAIN},$(date)" >> ${OUTPUT_FILE}
else
        echo "Failure,${NAME},${DOMAIN},$(date)" >> ${OUTPUT_FILE}
fi
echo "################################"
echo "############  DONE  ############"
echo "#### Check results.csv file ####"
echo "################################"

