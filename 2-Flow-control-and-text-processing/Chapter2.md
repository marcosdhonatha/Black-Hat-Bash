# 2 - FLOW CONTROL AND TEXT PROCESSING

This chapter covers bash concepts that can make your scripts more intelligent. You’ll
learn how to test conditions, use loops, consolidate code into functions, send commands to
the background, and more. You’ll also learn some ways of customizing your bash environment for penetration testing.

### Test Operators

Bash lets us selectively execute commands when certain conditions of interest are met. We can use test operators to craft a wide variety of conditions, such as whether one value equals another value, whether a file is of a certain type, or whether one value is greater than another. We often rely on such tests to determine whether to continue running a block of code, so being able to construct them is fundamental to bash programming.
Bash has multiple kinds of test operators. File test operators allow us to perform tests against files on the filesystem, such as checking whether a file is executable or whether a certain directory exists.

#### File Test Operators:


| Operator | Description                                       |
| -------- | ------------------------------------------------- |
| -d       | Checks whether the file is a directory            |
| -r       | Checks whether the file is readable               |
| -x       | Checks whether the file is executable             |
| -w       | Checks whether the file is writable               |
| -f       | Checks whether the file is a regular file         |
| -s       | Checks whether the file size is greater than zero |

#### String Comparison Operators:


| Operator | Description                                                                 |
| -------- | --------------------------------------------------------------------------- |
| =        | Checks whether a string is equal to another string                          |
| ==       | Synonym of = when used within [[ ]] constructs                              |
| <        | Checks whether a string comes before another string (in alphabetical order) |
| >        | Checks whether a string comes after another string (in alphabetical order)  |
| -z       | Checks whether a string is null                                             |
| -n       | Checks whether a string is not null                                         |

#### Integer Comparison Operators:


| Operator | Description                                                        |
| -------- | ------------------------------------------------------------------ |
| -eq      | Checks whether a number is equal to another number                 |
| -ne      | Checks whether a number is not equal to another number             |
| -ge      | Checks whether a number is greater than or equal to another number |
| -gt      | Checks whether a number is greater than another number             |
| -lt      | Checks whether a number is less than another number                |
| -le      | Checks whether a number is less than or equal to another number    |

## If Conditions

In bash, we can use an if condition to execute code only when a certain condition is met.

```
if [[ condition ]]; then
# Do something if the condition is met.
else
# Do something if the condition is not met.
fi
```

We start with the if keyword, followed by a test condition between
double square brackets ([[ ]]). We then use the ; character to separate the
if keyword from the then keyword, which allows us to introduce a block of
code that runs only if the condition is met.
Next, we use the else keyword to introduce a fallback code block that
runs if the condition is not met. Note that else is optional, and you may not
always need it. Finally, we close the if condition with the fi keyword (which
is if inversed).

> n some operating systems, such as those often used in containers, the default shell
> might not necessarily be bash. To account for these cases, you may want to use single
> square brackets ([...]) rather than double to enclose your condition. This use of single brackets meets the Portable Operating System Interface standard and should work
> on almost any Unix derivative, including Linux.

```
#!/bin/bash
FILENAME="flow_control_with_if.txt"
if [[ -f "${FILENAME}" ]]; then
30 Chapter 2
echo "${FILENAME} already exists."
exit 1
else
touch "${FILENAME}"
fi
```

We first create a variable named FILENAME containing the name of the
file we need. This saves us from having to repeat the filename in the code.
We then introduce the if statement, which includes a condition that uses
the -f file test operator to test for the existence of the file. If this condition
is true, we use echo to print to the screen a message explaining that the file
already exists and then use the status code 1 (failure) to exit the program.
In the else block, which will execute only if the file does not exist, we create
the file by using the touch command.

```
#!/bin/bash
FILENAME="flow_control_with_if.txt"
if [[ ! -f "${FILENAME}" ]]; then
touch "${FILENAME}"
fi
```

Let’s explore if conditions that use some of the other kinds of test
operators we’ve covered. Listing 2-4 shows a string comparison test. It tests
whether two variables are equal by performing string comparison with the
equal-to operator (==).

```
#!/bin/bash
VARIABLE_ONE="nostarch"
VARIABLE_TWO="nostarch"
if [[ "${VARIABLE_ONE}" == "${VARIABLE_TWO}" ]]; then
echo "They are equal!"
else
echo "They are not equal!"
fi
```

The script will compare the two variables, both of which have the value
nostarch, and print They are equal! by using the echo command.

```
#!/bin/bash
VARIABLE_ONE="10"
VARIABLE_TWO="20"
if [[ "${VARIABLE_ONE}" -gt "${VARIABLE_TWO}" ]]; then
echo "${VARIABLE_ONE} is greater than ${VARIABLE_TWO}."
else
echo "${VARIABLE_ONE} is less than ${VARIABLE_TWO}."
fi
```

We create two variables, VARIABLE_ONE and VARIABLE_TWO, and assign them
values of 10 and 20, respectively. We then use the -gt operator to compare
the two values and print the result based on an integer comparison.

### Linking Conditions

So far, we’ve used if to check whether a single condition is met. But as with most programming languages, we can also use the OR (||) and AND (&&) operators to check for multiple conditions at once.
For example, what if we want to check that a file exists and that its size is greater than zero?

```apache
#!/bin/bash
echo "Hello World!" > file.txt
if [[ -f "file.txt" ]] && [[ -s "file.txt" ]]; then
echo "The file exists and its size is greater than zero."
fi
```

To demonstrate an OR condition, Listing 2-7 checks whether a variable
is either a file or a directory:

```apache
#!/bin/bash
DIR_NAME="dir_test"
mkdir "${DIR_NAME}"
if [[ -f "${DIR_NAME}" ]] || [[ -d "${DIR_NAME}" ]]; then
32 Chapter 2
echo "${DIR_NAME} is either a file or a directory."
fi
```

### Testing Command Success

We can even test the exit code of commands to determine whether they were successful:

```apache
if command; then
# command was successful.
fi
if ! command; then
# command was unsuccessful.
fi
```

You’ll often find yourself using this technique in bash, as commands aren’t guaranteed to succeed. Failures could happen for reasons such as these:

• A lack of the necessary permissions when creating resources
• An attempt to execute a command that is not available on the operating system
• The disk being full when downloading a file
• The network being down while executing network utilities

To see how this technique works, execute the following in your terminal:

```apache
if touch test123; then
echo "OK: file created"
fi
OK: file created
```

### Checking Subsequent Conditions

If the first if condition fails, you can check for other conditions by using the elif keyword (short for else if ). To show how this works, let’s write a program that checks the arguments passed to it on the command line.

**if_elif.sh:**

```apache
#!/bin/bash
USER_INPUT="${1}"
if [[ -z "${USER_INPUT}" ]]; then
echo "You must provide an argument!"
exit 1
fi
if [[ -f "${USER_INPUT}" ]]; then
echo "${USER_INPUT} is a file."
elif [[ -d "${USER_INPUT}" ]]; then
echo "${USER_INPUT} is a directory."
else
 echo "${USER_INPUT} is not a file or a directory."
fi
```

## Functions

Functions help us reuse blocks of code so we can avoid repeating them. They allow us to run multiple commands and other bash code simultaneously by simply entering the function’s name. To define a new function, enter a name for it, followed by parentheses Then place the code you would like the function to run within curly brackets:

```apache
#!/bin/bash
say_name(){
echo "Black Hat Bash"
}
```

Here, we define a function called say_name() that executes a single echo command. To call a function, simply enter its name:

`say_name`

### Returning Values

Like commands and their exit statuses, functions can return values by using the return keyword. If there is no return statement, the function will return the exit code of the last command it ran. For example, the function in Listing 2-11 returns a different value based on whether the current user is root.

**check_root_function.sh**:

```apache
#!/bin/bash
# This function checks if the current user ID equals zero.
check_if_root(){
if [[ "${EUID}" -eq "0" ]]; then
return 0
else
return 1
fi
}
if check_if_root; then
echo "User is root!"
else
echo "User is not root!"
fi
```

Bash scripts that perform privileged actions often check whether the user is root before attempting to install software, create users, delete groups, and so on. Attempting to perform privileged actions on Linux without the necessary privileges will result in errors, so this check helps handle these cases.

### Accepting Arguments

In Chapter 1, we covered the passing of arguments to commands on the command line. Functions can also take arguments by using the same syntax. For example, the function in Listing 2-12 prints the first three arguments it receives.

```apache
#!/bin/bash
print_args(){
echo "first: ${1}, second: ${2}, third: ${3}"
}
print_args No Starch Press
```

## Loops and Loop Controls

Like many programming languages, bash lets you repeat chunks of code by using loops. Loops can be particularly useful in your penetration testing adventures because they can help you accomplish tasks such as the following:

• Continuously checking whether an IP address is online after a reboot until the IP address is responsive
• Iterating through a list of hostnames (for example, to run a specific exploit against each of them or determine whether a firewall is protecting them)
• Testing for a certain condition and then running a loop when it is met (for example, checking whether a host is online and, if so, performing a brute-force attack against it)

The following sections introduce you to the three kinds of loops in bash (while, until, and for) as well as the break and continue statements for working with loops.

### while

In bash, while loops allow you to run a code block until a test returns a successful exit status code. You might use them in penetration testing to continuously perform a port scan on a network and pick up any new hosts that join the network, for example.

```apache
while some_condition; do
# Run commands while the condition is true.
done
```

You can use while loops to run a chunk of code infinitely by using true as the condition; because true always returns a successful exit code, the code will always run. Let’s use a while loop to repeatedly print a command to the screen. Save Listing 2-14 to a file named basic_while.sh and run it.

```apache
#!/bin/bash
while true; do
echo "Looping..."
sleep 2
done
```

Next, let’s write a more sophisticated while loop that runs until it finds a specific file on the filesystem (Listing 2-15). Use ctrl-C to stop the code from executing at any point.

**while_loop.sh:**

```apache
#!/bin/bash
SIGNAL_TO_STOP_FILE="stoploop"
while [[ ! -f "${SIGNAL_TO_STOP_FILE}" ]]; do
echo "The file ${SIGNAL_TO_STOP_FILE} does not yet exist..."
echo "Checking again in 2 seconds..."
sleep 2
done
echo "File was found! Exiting..."
```

We define a variable representing the name of the file for which the while loop checks, using a file test operator. The loop won’t exit until the condition is satisfied. Once the file is available, the loop will stop, and the script will continue to the echo command. Save this file as while_loop.sh
and run it.

While the script is running, open a second terminal in the same directory as the script and create the stoploop file:

`$ touch stoploop`

Once you’ve done so, you should see the script break out of the loop and print the following:

`File was found! Exiting...`

We can use while loops to monitor for filesystem events, such as file creations or deletions, or when a process starts. This may come in handy if an application is suffering from a vulnerability we can only temporarily abuse.
For example, consider an application that runs daily at a particular hour and checks whether the file /tmp/update.sh exists; if it does, the application executes it as the root user. Using a while loop, we can monitor when that application has started and then create the file just in time so our commands are executed by that application.

### until

Whereas while runs so long as the condition succeeds, until runs so long as it fails.

```apache
until some_condition; do
# Run some commands until the condition is no longer false.
done
```

**until_loop.sh:**

```apache
#!/bin/bash
FILE="output.txt"
touch "${FILE}"
until [[ -s "${FILE}" ]]; do
echo "${FILE} is empty..."
echo "Checking again in 2 seconds..."
sleep 2
done
echo "${FILE} appears to have some content in it!"
```

At this point, the script has created the file output.txt, but it’s an empty file. We can check this by using the du (disk usage) command:

```apache
$ du -sb output.txt
0 output.txt
```

Open another terminal and navigate to the location at which your script is saved, then append some content to the file so its size is no longer zero:

`echo "until_loop_will_now_stop!" > output.txt`

The script should exit the loop, and you should see it print the following:

`output.txt appears to have some content in it!`

### for

The for loop iterates over a sequence, such as a list of filenames or variables, or even a group of values generated by running a command. Inside the for loop, we define a block of commands that are run against each value in the list, and each value in the list is assigned to a variable name we define.

```apache
for variable_name in LIST; do
# Run some commands for each item in the sequence.
done
```

A simple way to use a for loop is to execute the same command multiple times. For example, Listing 2-19 prints the numbers 1 through 10

```apache
#!/bin/bash
for index in $(seq 1 10); do
echo "${index}"
done
```

A more practical example might use a for loop to run commands against a bunch of IP addresses passed on the command line. Listing 2-20 retrieves all arguments passed to the script, then iterates through them and prints a message for each.

```apache
#!/bin/bash
for ip_address in "$@"; do
echo "Taking some action on IP address ${ip_address}"
done
```

We can even run a for loop on the output of commands such as ls. In Listing 2-21, we print the names of all files in the current working directory.

```apache
#!/bin/bash
for file in $(ls .); do
echo "File: ${file}"
done
```

We use a for loop to iterate over the output of the ls . command, which lists the files in the current directory. Each file will be assigned to the file variable as part of the for loop, so we can then use echo to print its name.
This technique would be useful, for example, if we wanted to perform an upload of all files in the directory or even rename them in bulk.

### break and continue

Loops can run forever or until a condition is met. But we can also exit a loop at any point by using the break keyword. This keyword provides an alternative to the exit command, which would cause the entire script, not just the loop, to exit. Using break, we can leave the loop and advance to the
next code block:

```apache
#!/bin/bash
while true; do
echo "in the loop"
break
done
echo "This code block will be reached."
```

In this case, the last echo command will be executed.

`$ touch example_file1 example_file2 example_file3`

Next, our for loop will write content to each file, excluding the first one, example_file1, which the loop will leave empty.

```apache
#!/bin/bash
for file in example_file*; do
if [[ "${file}" == "example_file1" ]]; then
echo "Skipping the first file"
continue
fi
echo "${RANDOM}" > "${file}"
done
```

If you examine the files, you should see that the first file is empty, while the other two contain a random number as a result of the script echoing the value of the ${RANDOM} environment variable into them.

## case Statements

In bash, case statements allow you to test multiple conditions in a cleaner way by using more readable syntax. Often, they help you avoid many if conditions, which can become harder to read as they grow in size.

```apache
case EXPRESSION in
PATTERN1)
# Do something if the first condition is met.
;;
PATTERN2)
# Do something if the second condition is met.
;;
esac
```

A case statement starts with the keyword case followed by an expression, such as a variable you want to match a pattern against. PATTERN1 and PATTERN2 in this example represent a pattern case (such as a regular expression, a string, or an integer) that you want to compare to the expression. To close a
case statement, you use the keyword esac (case inverted).
Let’s take a look at an example case statement that checks whether an IP address is present in a specific private network (Listing 2-25).

**case_ip_address_check.sh:**

```apache
#!/bin/bash
IP_ADDRESS="${1}"
case ${IP_ADDRESS} in
192.168.*)
echo "Network is 192.168.x.x"
;;
10.0.*)
echo "Network is 10.0.x.x"
;;
*)
echo "Could not identify the network"
;;
esac
```

A case statement can be used for a variety of use cases. For example, it can be used to run functions based on input the user has entered. Using case statements is a great way to handle the evaluation of multiple conditions without sacrificing the readability of the code.

## Text Processing and Parsing

To test the commands in this section on your own, download the sample logfile from https://github.com/dolevf/Black-Hat-Bash/blob/master/ch02/log.txt.
This file is space-separated, and each segment represents a specific data type, such as the client’s source IP address, timestamp, HyperText Transfer Protocol (HTTP) method, HTTP path, HTTP User Agent field, HTTP status code, and more.

### Filtering with grep

The grep command is one of the most popular Linux commands out there today. We use grep to filter out information of interest from streams.

`$ grep "35.237.4.214" log.txt`

This grep command will read the file and extract any lines containing the IP address 35.237.4.214 from it.
We can even use grep for multiple patterns simultaneously.

`$ grep "35.237.4.214\|13.66.139.0" log.txt`

Alternatively, we could use multiple grep patterns with the -e argument to accomplish the same thing:

`$ grep -e "35.237.4.214" -e "13.66.139.0" log.txt`

As you learned in Chapter 1, we can use the pipe (|) command to provide one command’s output as the input to another. In the following example, we run the ps command and use grep to filter out a specific line. The ps command lists the processes on the system:

`$ ps | grep TTY`

By default, grep is case sensitive. We can make our search case insensitive by using the -i flag:

`$ ps | grep -i tty`

We can also use grep with the -v argument to exclude lines containing a certain pattern:

`$ grep -v "35.237.4.214" log.txt`

To print only the matched pattern, and not the entire line at which the matched pattern was found, use -o:

`$ grep -o "35.237.4.214" log.txt`
<<<<<<< HEAD

### Filtering with awk

The awk command is a data processing and extraction Swiss Army knife. You can use it to identify and return specific fields from a file. To see how awk works, take another close look at our logfile. What if we need to print just the IP addresses from this file? This is easy to do with awk:

`$ awk '{print $1}' log.txt`

The $1 represents the first field of every line in the file where the IP addresses are. By default, awk treats spaces or tabs as separators or delimiters.

Using the same syntax, we can print additional fields, such as the time-
stamps. The following command filters the first three fields of every line in
the file:
`$ awk '{print $1,$2,$3}' log.txt`

Using similar syntax, we can print the first and last field simultaneously.
In this case, NF represents the last field:

`$ awk '{print $1,$NF}' log.txt`

We can also change the default delimiter. For example, if we had a file
separated by commas (that is, a CSV, or comma-separated values file), rather
than by spaces or tabs, we could pass awk the -F flag to specify the type
of delimiter:

`$ awk -F',' '{print $1}' example_csv.txt`

We can even use awk to print the first 10 lines of a file. This emulates
the behavior of the head Linux command; NR represents the total number of
records and is built into awk:

`awk -F',' '{print $1}' example_csv.txt`

You’ll often find it useful to combine grep and awk. For example, you

might want to first find the lines in a file containing the IP address
42.236.10.117 and then print the HTTP paths requested by this IP:

`$ grep "42.236.10.117" log.txt | awk '{print $7}' `

The awk command is a superpowerful tool, and we encourage you to dig
deeper into its capabilities by running man awk for more information

### Editing Streams with sed

The sed (stream editor) command takes actions on text. For example, it can replace the text in a file, modify the text in a command’s output, and even delete selected lines from files.

Let’s use sed to replace any mentions of the word Mozilla with the word Godzilla in the log.txt file. We use its `s` (substitution) command and `g` (global) command to make the substitution across the whole file, rather than to just the first occurrence:

`sed 's/Mozilla/Godzilla/g' log.txt`

This will output the modified version of the file but won’t change the original version. You can redirect the output to a new file to save your changes:

`sed 's/Mozilla/Godzilla/g' log.txt > newlog.txt`

We could also use sed to remove any whitespace from the file with the / // syntax, which will replace whitespace with nothing, removing it from the output altogether:

`sed 's/ //g' log.txt`

If you need to delete lines of a file, use the d command. In the following command, 1d deletes (d) the first line (1):

`sed '1d' log.txt`

To delete the last line of a file, use the dollar sign ($), which represents the last line, along with d:

`sed '$d' log.txt`

You can also delete multiple lines, such as lines 5 and 7:

`sed '5,7d' log.txt`

Finally, you can print (p) specific line ranges, such as lines 2 through 15:

`sed -n '2,15 p' log.txt`

When you pass sed the -i argument, it will make the changes to the file itself rather than create a modified copy:

`sed -i '1d' log.txt`

## Job Control

As you become proficient in bash, you’ll start to build complex scripts that take an hour to complete or must run continuously. Not all scripts need to execute in the foreground, blocking execution of other commands. Instead, you may want to run certain scripts as background jobs, either because they take a while to complete or because their runtime output isn’t interesting
and you care about only the end result.
Commands that you run in a terminal occupy that terminal until the command is finished. These commands are considered foreground jobs. In Chapter 1, we used the ampersand character (&) to send a command to the background. This command then becomes a background job that allows us to unblock the execution of other commands.

### Managing the Background and Foreground

To practice working with background and foreground jobs, let’s run a command directly in the terminal and send it to the background:

`sleep 100 &`

Notice that we can continue working on the terminal while this sleep command runs for 100 seconds. We can verify that the spawned process is running by using the ps command:

`ps -ef | grep sleep`

Now that this job is in the background, we can use the jobs command to see what jobs are currently running:

`jobs`

The output shows that the sleep command is in Running state and that its job ID is 1.
We can migrate the job from the background to the foreground by issuing the fg command and the job ID:

`fg %1`

At this point, the sleep command is occupying the terminal, since it's running in the foreground. You can press ctrl-Z to suspend the process, which will produce the following output in the jobs table:

To send this job to the background again in a running state, use the bg command with the job ID:

`bg %1`

### Keeping Jobs Running After Logout

Whether you send a job to the background or are running a job in the foreground, the process won’t survive if you close the terminal or log out. If you close the terminal, the process will receive a SIGHUP signal and terminate.

What if we want to keep running a script in the background even after we’ve logged out of the terminal window or closed it? To do so, we could start a script or command with the nohup (no hangup) command prepended:

`nohup ./my_script.sh &`

> The nohup command will create a file named nohup.out with standard output stream data. Make sure you delete this file if you don’t want it on the filesystem.

There are additional ways to run background scripts, such as by plugging into system and service managers like systemd. These managers provide additional features, such as monitoring that the process is running, restarting it if it isn’t, and capturing failures. We encourage you to read more
about systemd at https://man7.org/linux/man-pages/man1/init.1.html if you have such use cases.

## Bash Customizations for Penetration Testers

As penetration testers, we often follow standard workflows for all ethical hacking engagements, whether they are consulting work, bug bounty hunting, or red teaming. We can optimize some of this work with a few bash tipsand tricks.
