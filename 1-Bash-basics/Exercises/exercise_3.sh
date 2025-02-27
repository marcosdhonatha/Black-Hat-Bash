#!/bin/bash

# 3. Writes the current date to output.txt by using the date command.
# (Bonus points if you can make the date command print the date in the DD-MM-YYYY format; use man date to learn how this works.)

echo "Adding the current  date in the 'output.txt' file"

date +"%d-%m-%Y" >output.txt

echo "..."
echo "Done"
