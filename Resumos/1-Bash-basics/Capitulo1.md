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
  >

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
