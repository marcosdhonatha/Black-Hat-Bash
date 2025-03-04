# 2 - FLOW CONTROL AND TEXT PROCESSING

This chapter covers bash concepts that can make your scripts more intelligent. You’ll
learn how to test conditions, use loops, consolidate code into functions, send commands to
the background, and more. You’ll also learn some ways of customizing your bash environment for penetration testing.

### Test Operators

Bash lets us selectively execute commands when certain conditions of interest are met. We can use test operators to craft a wide variety of conditions, such as whether one value equals another value, whether a file is of a certain type, or whether one value is greater than another. We often rely on such tests to determine whether to continue running a block of code, so being able to construct them is fundamental to bash programming.
Bash has multiple kinds of test operators. File test operators allow us to perform tests against files on the filesystem, such as checking whether a file is executable or whether a certain directory exists.

#### File Test Operators:


| Operator | Description                                       |
| ---------- | --------------------------------------------------- |
| -d       | Checks whether the file is a directory            |
| -r       | Checks whether the file is readable               |
| -x       | Checks whether the file is executable             |
| -w       | Checks whether the file is writable               |
| -f       | Checks whether the file is a regular file         |
| -s       | Checks whether the file size is greater than zero |

#### String Comparison Operators:


| Operator | Description                                                                 |
| ---------- | ----------------------------------------------------------------------------- |
| =        | Checks whether a string is equal to another string                          |
| ==       | Synonym of = when used within [[ ]] constructs                              |
| <        | Checks whether a string comes before another string (in alphabetical order) |
| >        | Checks whether a string comes after another string (in alphabetical order)  |
| -z       | Checks whether a string is null                                             |
| -n       | Checks whether a string is not null                                         |

#### Integer Comparison Operators:


| Operator | Description                                                        |
| ---------- | -------------------------------------------------------------------- |
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
