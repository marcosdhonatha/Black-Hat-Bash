# SETTING UP A HACKING LAB

In this chapter, you’ll set up a lab environment containing hacking tools and an intentionally vulnerable target. You’ll use this lab in chapter exercises, but you can also turn to it whenever you need to write, stage, and test a bash script before running it against real targets.

## Security Lab Precautions

Follow these guidelines to reduce the risks associated with building and operating a hacking lab:

* Avoid connecting the lab directly to the internet. Hacking lab environments typically run vulnerable code or outdated software. While these vulnerabilities are great for hands-on learning, they could pose risks to your network, computer, and data if they become accessible from the internet. Instead, we recommend working through the book when connected to local networks that you trust or operating offline after the lab is set up.
* Deploy the lab in a virtual environment by using a hypervisor. Separating the lab environment from your primary operating system is generally a good idea, as it prevents conflicts that could potentially break other software on your computer. We recommend using a virtualization tool to ensure this separation. In the next section, you’ll install the lab in a Kali virtual machine.
* Take frequent snapshots of your virtual machine. Snapshots are backups of your virtual machine that allow you to restore it to a previous state. Lab environments often won’t stay stable after you attack them, so take snapshots whenever your lab is in a stable state. With these best practices in mind, let’s get our hands dirty and our lab up and running!

## Installing Kali
