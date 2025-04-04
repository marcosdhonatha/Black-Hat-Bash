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

### Possible Subdomains

Say you’re performing a penetration test against a company with the parent domain example.com. In this engagement, you’re not restricted to any specific IP address or domain name, which means that any asset you find on this parent domain during the information-gathering stage is considered in scope.
Companies tend to host their services and applications on dedicated subdomains. These subdomains can be anything, but more often than not, companies use names that make sense to humans and are easy to enter into a web browser. For example, you might find the help-desk portal at helpdesk .example.com, the monitoring system at monitoring.example.com, the continuous integration system at jenkins.example.com, the email server at mail.example .com, and the file transfer server at ftp.example.com.
How can we generate a list of possible subdomains for a target? Bash makes this easy. First, we’ll need a list of common subdomains. You can find such a list built into Kali at /usr/share/wordlists/amass/subdomains-top1mil-110000.txt or /usr/share/wordlists/amass/bitquark_subdomains_top100K.txt.
To look for wordlists on the internet, you could use the following Google search query to search for files on GitHub provided by community members: subdomain wordlist site:gist.github.com. This will search GitHub for code snippets (also called gists) containing the words subdomain wordlist. For the purposes of this example, we’ll use subdomains-1000.txt, which is included with this chapter’s files in the book’s GitHub repository. Download this subdomain list and save it in your home directory. The file contains one subdomain per line without an associated parent domain. You’ll have to join each subdomain with the target’s parent domain to form a fully qualified domain name. As in the previous section, we’ll show multiple strategies for accomplishing this task: using a while loop and using sed .


The following example accepts a parent domain and a wordlist from the user, then prints a list of fully qualified subdomains by using the wordlist you downloaded earlier.

```
#!/bin/bash
DOMAIN="${1}"
FILE="${2}"
# Read the file from standard input and echo the full domain.
while read -r subdomain; do
echo "${subdomain}.${DOMAIN}"
done < "${FILE}"
```

The script uses a while loop to read the file and assign each line to the subdomain variable in turn. The echo command then concatenates these two strings together to form a full domain name. Save this script as generate_subdomains.sh and provide it with two arguments:

`$ ./generate_subdomains.sh example.com subdomains-1000.txt`

```
www.example.com
mail.example.com
ftp.example.com
localhost.example.com
webmail.example.com
--snip--
```

The first argument is the parent domain, and the second is the path to the file containing all possible subdomains.
We can use sed to write content to the end of each line in a file. In Listing 4-5, the  command uses the $ sign to find the end of a line, then replace it with the target domain prefixed with a dot (.example.com) to complete the domain name.

`$ sed 's/$/.example.com/g' subdomains-1000.txt`

The s at the beginning of the argument to sed stands for substitute, and g means that sed will replace all matches in the file, not just the first match. So, in simple terms, we substitute the end of each line in the file with .example.com. If you save this code to a script, the output should look the same as in the previous example
