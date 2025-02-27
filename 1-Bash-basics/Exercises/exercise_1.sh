#!/bin/bash
   
# 1. Accepts two arguments on the command line and assigns them to variables.
# The first argument should be your first name, and the second should be your last name.

 first_name=""
 last_name=""

get_arguments(){
	echo "What is your first name?"
	read -r first_name

	echo "what is your last name?"
	read -r last_name
}
get_arguments

echo "Hi, ${first_name} ${last_name}!"

