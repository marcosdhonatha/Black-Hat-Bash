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
