# Misc scripts

* checkmail.sh - used to check Mailboxes for new mail.  Useful for when you're
  using isync, but don't want to open a full MTA to see if you have new mail.

* dock.sh - script I use to manage docking/undocking my thinkpad.

* doingnext - simple script I use with an awesome wm binding to update my doing
  task

* flush-agents - systemd script used to flush ssh-agent and gpg-agent when
  laptop is put to sleep.  To use copy flush-agent.sh to /usr/local/sbin,
  flush-agents.service to /etc/systemd/system, and run sudo systemctl enable
  flush-agents 

* monswitch - another monitor switching script for muliple monitors.

* notes - script to keep track of multiple notebooks used with the vim nvim
  plugin

* sysinfo.sh - script made to provide some basic system information on the
  command line.  Work In Progress.  Some things, like CPU usage, are not
  working correctly.
