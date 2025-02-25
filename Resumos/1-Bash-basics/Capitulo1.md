# 1. BASH BASICS

## Resume:

> Bash is a command language interpreter that provides an environment in which users can execute commands and run applications. As penetration testers and security practitioners, we frequently write bash scripts to automate a wide variety of tasks, making bash an essential tool for hackers. In this chapter, you’ll set up your bash development environment, explore useful Linux commands to include
> in future scripts, and learn the fundamentals of the language’s syntax, including variables, arrays, streams, arguments, and operators.

---

## Exploring the Shell:

- `bash --version`:Verify that bash is available on
  your system.
- `env`: See the list of environment variables set by bash.

##### Listing 1-1: Listing bash’s environment variables:

- `echo ${SHELL}` :
  
  > /bin/bash

Here are some of the default environment variables available:

- **BASH_VERSION** The bash version running
- **BASHPID** The process identifier (PID) of the current bash process
- **GROUPS** A list of groups the running user is a member of
- **HOSTNAME** The name of the host
- **OSTYPE** The type of operating system
- **PWD** The current working directory
- **RANDOM** A random number from 0 to 32,767
- **UID** The user ID (UID) of the current user
- **SHELL** The full pathname to the shell

---

### Running Linux Commands:

> The bash scripts you’ll write in this book will run common Linux tools, so if
> you’re not yet familiar with command line navigation and file modification
> utilities such as cd, ls, chmod, mkdir, and touch, try exploring them by using
> the man (manual) command. You can insert it before any Linux command
> to open a terminal-based guide that explains that command’s use and
> options, as shown in Listing 1-3

- `man ls`
- `ls -l`
- `ls -la`
- `ls -l -a`
- `ls --help`
- `mkdir directory1`
- `mkdir directory2 directory3`

---

### Elements of a Bash Script

> In this section, you’ll learn the building blocks of a bash script. You’ll use
> comments to document what a script does, tell Linux to use a specific interpreter to execute the script, and style your scripts for better readability.
> 
> Bash doesn’t have an official style guide, but we recommend adhering
> to Google’s Shell Style Guide (https://google.github.io/styleguide/shellguide.html),
> which outlines best practices to follow when developing bash code. If you
> work on a team of penetration testers and have an exploit code repository,
> using good code styling practices will help your team maintain it.

#### The Shebang Line:

> Every script should begin with the shebang line, a character sequence that
> starts with the hash and exclamation marks (#!), followed by the full path to
> the script interpreter. Listing 1-4 shows an example of a shebang line for a
> typical bash script.

* `#!/bin/bash` : The bash interpreter is typically located at /bin/bash. If you instead
  wrote scripts in Python or Ruby, your shebang line would include the full
  path to the Python or Ruby interpreter.
* `#!/usr/bin/env bash` : You may want to use this shebang line because it is more portable than
  the one in Listing. Some Linux distributions place the bash interpreter
  in different system locations, and this shebang line will attempt to find that
  location. This approach could be particularly useful in penetration tests,
  where you might not know the location of the bash interpreter on the tar-
  get machine.

**The shebang line can also take optional arguments to change how the script executes. For example, you could pass the special argument -x to your bash shebang, like so:**

* `#!/bin/bash -x` : This option prints all commands and their arguments as they are executed to the terminal. It is useful for debugging scripts as you’re developing them.
* `#!/bin/bash -r` : This option creates a restricted bash shell, which restricts certain potentially dangerous commands that could, for example, navigate to certain directories, change sensitive environment variables, or attempt to turn off the restricted shell from within the script.

Specifying an argument within the shebang line requires modifying the script, but you can also pass arguments to the bash interpreter by using this syntax:

* `bash -r myscript.sh`

Whether you pass arguments to the bash interpreter on the command line or on the shebang line won’t make a difference. The command line option is just an easier way to trigger different modes.

---

### Comments:

> Comments are parts of a script that the bash interpreter won’t treat as code and that can improve the readability of a program. Imagine that you write a long script and, a few years later, need to modify some of its logic. If you didn’t write comments to explain what you did, you might find it quite challenging to remember the purpose of each section.

Comments in bash start with a hash mark (**#**), as shown in:

```
#!/bin/bash
# This is my first script.
```

To write a multiline comment, precede each individual line with the
hash mark, as shown in:

```
#!/bin/bash
# This is my first script!
# Bash scripting is fun...
```

> In addition to documenting a script’s logic, comments can provide metadata to indicate the author, the script’s version, the person to contact for issues, and more. These comments usually appear at the top part of the script, below the shebang line.

---

### Commands

Scripts can be as short as two lines: the shebang line and a Linux command. Let’s write a simple script that prints Hello World! to the terminal. Open your text editor and enter the following:

```
#!/bin/bash
echo "Hello World!"
```

### Execution

To run the script, save the file as helloworld.sh, open the terminal, and navigate to the directory where the script resides. If you saved the file in your home directory, you should run the set of commands shown in:

```apache
$ cd ~
$ chmod u+x helloworld.sh
$ ./helloworld.sh
```

You can also run a bash script with the following syntax:

`$ bash helloworld.sh`

Because we specified the bash command, the script will run using the bash interpreter and won’t require a shebang line. Also, if you use the bash command, the script doesn’t have to be set with an executable permission (+x). In later chapters, you’ll learn about the permission model in more depth and explore its importance in the context of finding misconfigurations in penetration tests.

### Debugging

Errors will inevitably occur when you’re developing bash scripts. Luckily, debugging scripts is quite intuitive. An easy way to check for errors early is by using the -n parameter when running a script:

`$ bash -n script.sh`

his parameter will read the commands in the script but won’t execute them, so any syntax errors that exist will be shown onscreen. You can think of -n as a dry-run method to test the validity of your syntax.
You can also use the -x parameter to turn on verbose mode, which lets you see commands being executed and will help you debug issues as the script executes in real time:

`bash -x script.sh`

If you want to start debugging at a given point in the script, include the set command in the script itself:

```apache
#!/bin/bash
set -x
--snip--
set +x
```

### Basic Syntax

The most basic bash scripts are just lists of Linux commands collected in a single file. For example, you could write a script that creates resources on a system and then prints information about these resources to the screen:

```apache
#!/bin/bash
# All this script does is create a directory, create a file
# within the directory, and then list the contents of the directory.
mkdir mydirectory
touch mydirectory/myfile
ls -l mydirectory
```

In this example, we use mkdir to create a directory named mydirectory. Next, we use the touch command to create a file named myfile within the directory. Finally, we run the ls -l command to list the contents of mydirectory.

### Variables

In bash,
variables are untyped; they’re all considered character strings. Even so, you’ll see that bash allows you to create arrays, access array elements, or perform arithmetic operations so long as the variable value consists of only numbers.

The following rules govern the naming of bash variables:

* They can include alphanumeric characters.
* They cannot start with a number.
* They can contain an underscore (_).
* They cannot contain whitespace.

### Assigning and Accessing Variables

Let’s assign a variable. Open a terminal and enter the following directly within the command prompt:

`book="black hat bash"`

```
$ echo "This book's name is echo"Thisbook′snameis${book}"
This book's name is black hat bash
```

You can also expand a variable by using just the dollar sign ($) followed by the variable:

`echo "This book's name is $book"`

Using the ${} syntax makes the code less prone to misinterpretation and helps readers understand when a variable starts and ends.

You can also assign the output of a command to a variable by using the command substitution syntax $(), placing the desired command within the parentheses. You’ll use this syntax often in bash programming.

Try running the commands:

```
$ root_directory=$(ls -ld /)
$ echo "${root_directory}"
```

Note that you shouldn’t leave whitespace around the assignment symbol (=) when creating a variable:

`book = "this is an invalid variable assignment"`

**The previous variable assignment syntax is considered invalid.**

#### Unassigning Variables

You can unassign assigned variables by using the unset command, as shown in:

```
$ book="Black Hat Bash"
$ unset book
$ echo "echo"${book}"
```

If you execute these commands in the terminal, no output will be shown after the echo command executes.

#### Arithmetic Operators

> Operator Description

> \+ Addition

> \- Subtraction

> \* Multiplication

> / Division

> % Modulo

> += Incrementing by a constant

> -= Decrementing by a constant

You can perform these arithmetic operations in bash in a few ways: using the let command, using the double parentheses syntax \$((expression)), or using the expr command. Let's consider an example of each method.

```
$ let result="4 * 5"
$ echo ${result}
20
```

This command takes a variable name and performs an arithmetic calculation to resolve its value.

```
$ result=$((5 * 5))
$ echo ${result}
25
```

In this case, we perform the calculation within double parentheses.

```
$ result=$(expr 5 + 505)
$ echo ${result}
510
```

The expr command evaluates expressions, which don’t have to be arithmetic operations; for example, you might use it to calculate the length of a string. Use man expr to learn more about the capabilities of expr.

#### Arrays

Bash allows you to create single-dimension arrays. An array is a collection of elements that are indexed. You can access these elements by using their index numbers, which begin at zero. In bash scripts, you might use arrays whenever you need to iterate over multiple strings and run the same commands on each one.

```
#!/bin/bash
# Sets an array
IP_ADDRESSES=(192.168.1.1 192.168.1.2 192.168.1.3)
# Prints all elements in the array
echo "${IP_ADDRESSES[*]}"
# Prints only the first element in the array
echo "${IP_ADDRESSES[0]}"
```

You can also delete elements from an array. Listing 1-17 will delete 192.168.1.2 from the array.

```
IP_ADDRESSES=(192.168.1.1 192.168.1.2 192.168.1.3)
unset IP_ADDRESSES[1]
```

You can even swap one of the values with another value. This code will replace 192.168.1.1 with 192.168.1.10:

`IP_ADDRESSES[0]="192.168.1.10"`

You’ll find arrays particularly useful when you need to iterate over values and perform actions against them, such as a list of IP addresses to scan (or a list of email addresses to send a phishing email to).

#### Streams

Streams are files that act as communication channels between a program and its environment. When you interact with a program (whether a built-in Linux utility such as ls or mkdir or one that you wrote yourself), you’re interacting with one or more streams. Bash has three standard data streams, as shown in:

| Stream name              | Description                         | File descriptor number |
| -------------------------- | ------------------------------------- | ------------------------ |
| Standard input (stdin)   | Data coming into a program as input | 0                      |
| Standard output (stdout) | Data coming out of a program        | 1                      |
| Standard error (stderr)  | Errors coming out of a program      | 2                      |

#### Control Operators

Control operators in bash are tokens that perform a control function:

| Operator | Description                                                                                                                                                        |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| &        | Sends a command to the backgroundd                                                                                                                                 |
| &&       | Used as a logical AND. The second command in the expression will be evaluated only if the first command evaluates to true.d                                        |
| (and)    | Used for command grouping.                                                                                                                                         |
| ;        | Used as a list terminator. A command following the terminator will run after the preceding command has finished, regardless of whether it evaluates to true or not |
| ;;       | Ends a case statement.                                                                                                                                             |
| \|       | Redirects the output of a command as input to another command.                                                                                                     |
| \|       | Used as a logical OR. The second command will run if the first one evaluates to false.                                                                             |

Let’s see some of these control operators in action. The & operator sends a command to the background. If you have a list of commands to run, as in Listing 1-18, sending the first command to the background will allow bash to continue to the next line even if the previous command hasn’t finished its work.

```
#!/bin/bash
# This script will send the sleep command to the background.
echo "Sleeping for 10 seconds..."
1 sleep 10 &
# Creates a file
echo "Creating the file test123"
touch test123
# Deletes a file
echo "Deleting the file test123"
rm test123
```

Commands that are long-running are often sent to the background to prevent scripts from hanging. You’ll learn about sending commands to the background in more depth when we discuss job control in Chapter 2. The && operator allows us to perform an AND operation between two commands. In the following example, the file test123 will be created only if the first command is successful:

`touch test && touch test123`

The () operator allows us to group commands so they act a single unit when we need to redirect them together:

`(ls; ps)`

This is generally useful when you need to redirect results from multiple commands to a stream, as shown in “Redirection Operators,” next. The ; operator allows us to run multiple commands regardless of their exit status:

`ls; ps; whoami`

As a result, each command is executed one after the other, as soon as the previous one finishes. The || operator allows us to chain commands together using an OR operation:

`lzl || echo "the lzl command failed"`

In this example, the echo command will be executed only if the first command fails.

#### Redirection Operators

| Operator | Description                                                                     |
| ---------- | --------------------------------------------------------------------------------- |
| >        | Redirects stdout to a file                                                      |
| >>       | Redirects stdout to a file by appending it to the existing content              |
| &> or >& | Redirects stdout and stderr to a file                                           |
| &>>      | Redirects stdout and stderr to a file by appending them to the existing content |
| <        | Redirects input to a command                                                    |
| <<       | Called a here document, or heredoc, redirects multiple input lines to a command |
| \|       | Redirects output of a command as input to another command                       |

The > operator redirects the standard output stream to a file. Any command that precedes this character will send its output to the specified location. Run the following command directly in your terminal:

`$ echo "Hello World!" > output.txt`

```
$ cat output.txt
Hello World!
```

Next, we’ll use the >> operator to append some content to the end of the same file:

```
$ echo "Goodbye!" >> output.txt
$ cat output.txt
Hello World!
Goodbye!
```

If we had used > instead of >>, the content of output.txt would have been overwritten completely with the Goodbye! text.

You can redirect both the standard output stream and the standard error stream to a file by using &>. This is useful when you don’t want to send any output to the screen and instead save everything in a logfile (perhaps for later analysis):

`$ ls -l / &> stdout_and_stderr.txt`

To append both the standard output and standard error streams to a file, use the ampersand followed by the double chevron (&>>). What if we want to send the standard output stream to one file and the standard error stream to another? This is also possible using the streams’ file descriptor numbers:

`$ ls -l / 1> stdout.txt 2> stderr.txt`

```
$ lzl 2> error.txt
$ cat error.txt
bash: lzl: command not found
```

Notice that you don’t see the error onscreen because bash sends the error to the file instead.

What if we want to redirect multiple lines to a command? Here document redirection (<<) can help with this.

```
$ cat << EOF
 Black Hat Bash
 by No Starch Press
EOF
Black Hat Bash
by No Starch Press
```

In this example, we pass multiple lines as input to a command. The EOF in this example acts as a delimiter, marking the start and end points of the input. Here document redirection treats the input as if it were a separate file, preserving line breaks and whitespace. The pipe operator (|) redirects the output of one command and uses it as the input of another. For example, we could run the ls command on the root directory and then use another command to extract data from it, as shown in:

```
$ ls -l / | grep "bin"
lrwxrwxrwx 1 root root 7 Mar 10 08:43 bin -> usr/bin
lrwxrwxrwx 1 root root 8 Mar 10 08:43 sbin -> usr/sbin
```

We use ls to print the content of the root directory into the standard output stream, then use a pipe to send it as input to the grep command, which filters out any lines containing the word bin.

#### Positional Arguments

Bash scripts can take positional arguments (also called parameters) passed on the command line. Arguments are especially useful, for example, when you want to develop a program that modifies its behavior based on input passed to it by another program or user. Arguments can also change features of the script such as the output format and how verbose it will be during runtime. For example, imagine you develop an exploit and send it to a few colleagues, each of whom will use it against a different IP address. Instead of writing a script and asking the user to modify it with their network information, you can write it to take an IP address argument and then act against this input to avoid having to modify the source code in each case.

A bash script can access arguments passed to it on the command line by using the variables \$1, \$2, and so on. The number represents the order in which the argument was entered:

```
#!/bin/bash
# This script will ping any address provided as an argument.
SCRIPT_NAME="${0}"
TARGET="${1}"
echo "Running the script ${SCRIPT_NAME}..."
echo "Pinging the target: ${TARGET}..."
ping "${TARGET}"
```

This script assigns the first positional argument to the variable TARGET. Notice, also, that the argument \${0} is assigned to the SCRIPT\_NAME variable. This argument contains the script's name.

```
$ chmod u+x ping_with_arguments.sh
$ ./ping_with_arguments.sh nostarch.com
```

What if you want to access all arguments? You can do so using the variable \$@. Also, using \$#, you can get the total number of arguments passed:

```
#!/bin/bash
echo "The arguments are: $@"
echo "The total number of arguments is: $#"
```

Save this script to a file named show\_args.sh and run it as follows:

```
$ chmod u+x show_args.sh
$ ./show_args.sh "hello" "world"
The arguments are: hello world
The total number of arguments is: 2
```

Special Variables Related to Positional Arguments:

| Variable          | Description                                                          |
| ------------------- | ---------------------------------------------------------------------- |
| $0                | The name of the script file                                          |
| \$1, \$2, \$3 ... | Positional arguments                                                 |
| $#                | The number of passed positional arguments                            |
| $*                | All positional arguments                                             |
| $@                | All positional arguments, where each argument is individually quoted |

When a script uses "\$\*" with the quotes included, bash will expand arguments into a single word. For instance, the following example groups the arguments into one word:

```
$ ./script.sh "1" "2" "3"
1 2 3
```

When a script uses "\$@" (again including the quotes), it will expand arguments into separate words:

```
$ ./script.sh "1" "2" "3"
1
2
3
```

In most cases, you will want to use "\$@" so that every argument is treated as an individual word. The following script demonstrates how to use these special variables in a for loop:

```
#!/bin/bash
# Change "$@" to "$*" to observe behavior.
for args in "$@"; do
 echo "${args}"
done
```

#### Input Prompting

Some bash scripts don’t take any arguments during execution. However,
they may need to ask the user for information in an interactive way and have the response feed into their runtime. In these cases, we can use the read command. You often see applications use input prompting when attempting to install software, asking the user to enter yes to proceed or no to cancel the operation.

```apache
#!/bin/bash
# Takes input from the user and assigns it to variables
echo "What is your first name?"
read -r firstname
echo "What is your last name?"
read -r lastname
echo "Your first name is ${firstname} and your last name is ${lastname}"
```

Save and run this script as input_prompting.sh:

```
$ chmod u+x input_prompting.sh
$ ./input_prompting.sh
What is your first name?
John
What is your last name?
Doe
Your first name is John and your last name is Doe
```




























