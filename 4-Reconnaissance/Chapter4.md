# 4. RECONNAISSANCE

Every hacking engagement starts with some form of information gathering. In this chapter, we’ll perform reconnaissance on targets by writing bash scripts to run various hacking tools. You’ll learn how to use bash to automate tasks and chain multiple tools into a single workflow.

In the process, you’ll develop an important bash-scripting skill: parsing the output of various tools to extract only the information you need. Your scripts will interact with tools that figure out what hosts are online, what ports are open on those hosts, and what services they are running, then deliver this information to you in the format you require.
Perform all hacking activities in your Kali environment against the vulnerable network you set up in Chapter 3

## Creating Reusable Target Lists

A scope is a list of systems or resources you’re allowed to target. In penetra-
tion testing or bug-hunting engagements, the target company might pro-
vide you with various types of scopes:

* Individual IP addresses, such as 172.16.10.1 and 172.16.10.2
* Networks, such as 172.16.10.0/24 and 172.16.10.1–172.16.10.254
* Individual domain names, such as lab.example.com
* A parent domain name and all its subdomains, such as *.example.com

### Consecutive IP Addresses

Imagine that you need to create a file containing a list of IP addresses from 172.16.10.1 to 172.16.10.254. While you could write all 254 addresses by hand, this would be time-consuming. Let’s use bash to automate the job!
We’ll consider three strategies: using the seq command in a for loop, using brace expansion with echo , and using brace expansion with printf .

```
#!/bin/bash
# Generate IP addresses from a given range.
for ip in $(seq 1 254); do
echo "172.16.10.${ip}" >> 172-16-10-hosts.txt
done
```

As in most cases, you can use multiple approaches to achieve the same task in bash. We can generate the IP address list by using a simple echo command, without running any loops.

`$ echo 10.1.0.{1..254}`

`10.1.0.1 10.1.0.2 10.1.0.3 10.1.0.4 ...`

You’ll notice that this command outputs a list of IP addresses on a single line, separated by spaces. This isn’t ideal, as what we really want is each IP address on a separate line.

`$ echo 10.1.0.{1..254} | sed 's/ /\n/g'`

```
10.1.0.1
10.1.0.2
10.1.0.3
--snip--
```

Alternatively, you can use the printf command to generate the same list. Using printf won’t require piping to sed , producing a cleaner output:

`$ printf "10.1.0.%d\n" {1..254}`

## Possible Subdomains
