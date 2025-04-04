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

## Host Discovery


When testing a range of addresses, one of the first things you’ll likely want to do is find out information about them. Do they have any open ports? What services are behind those ports, and are they vulnerable to any security flaws? Answering these questions manually is possible, but this can be challenging if you need to do it for hundreds or thousands of hosts. Let’s use bash to automate network enumeration tasks.
One way to identify live hosts is by attempting to send them network packets and wait for them to return responses. In this section, we’ll use bash and additional network utilities to perform host discovery.

### ping

At its most basic form, the ping command takes one argument: a target IP address or domain name. Run the following command to see its output:

`$ ping 172.16.10.10`

If you read the ping manual page (by running man ping ), you’ll notice that there is no way to run the command against multiple hosts at once. But using bash, we can do this quite easily.

```
#!/bin/bash
FILE="${1}"
while read -r host; do
  if ping -c 1 -W 1 -w 1 "${host}" &> /dev/null; then
    echo "${host} is up."
  fi
done < "${FILE}"
```

At 1, we run a while loop that reads from the file passed to the script on the command line. This file is assigned to the variable FILE . We read each line from the file and assign it to the host variable. We then run the ping command, using the -c argument with a value of 1 at 2, which tells ping to send a ping request only once and exit. By default on Linux, ping sends ping requests indefinitely until you stop it manually by sending a SIGHUP signal (ctrl-C).

We also use the arguments -W 1 (to set a timeout in seconds) and -w 1 (to set a deadline in seconds) to limit the amount of time ping will wait to receive a response. This is important because we don’t want ping to get stuck on an unresponsive IP address; we want it to continue reading from the file until all 254 hosts are tested.
Finally, we use the standard input stream to read the file and “feed” the while loop with its contents 3.


Save this code to multi_host_ping.sh and run it while passing in the hosts file. You should see that the code picks up a few live hosts:

### Nmap

The Nmap port scanner has a special option called -sn that performs a ping sweep. This simple technique finds live hosts on a network by sending them a ping command and waiting for a positive response (called a ping response). Since many operating systems respond to ping by default, this technique has proved valuable. The ping sweep in Nmap will essentially make Nmap send Internet Control Message Protocol packets over the network to discover running hosts:

`$ nmap -sn 172.16.10.0/24`

```
Nmap scan report for 172.16.10.1
Host is up (0.00093s latency).
Nmap scan report for 172.16.10.10
Host is up (0.00020s latency).
Nmap scan report for 172.16.10.11
Host is up (0.00076s latency).
--snip--
```

This output has a lot of text. With a bit of bash magic, we can get a cleaner output by using the grep and awk commands to extract only the IP addresses that were identified as being alive

`$ nmap -sn 172.16.10.0/24 | grep "Nmap scan" | awk -F'report for ' '{print $2}'`

```
172.16.10.1
172.16.10.10
--snip--
```

Using Nmap’s built-in ping sweep scan may be more useful than manually wrapping the ping utility with bash, because you don’t have to worry about checking for conditions such as whether the command was successful. Moreover, in penetration tests, you may drop an Nmap binary on more than one type of operating system, and the same syntax will work consistently whether the ping utility exists or not.
