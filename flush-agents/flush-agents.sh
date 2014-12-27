#!/usr/bin/bash
user=soleblaze

# remove saved passphrases in gpg-agent
/usr/bin/pkill -u $user -SIGHUP gpg-agent

# Remove all keys from ssh-agent
for SSH_AUTH_SOCK in `find /tmp/ssh-*/agent.* -user $user`; do
    SSH_AUTH_SOCK=$SSH_AUTH_SOCK /usr/bin/ssh-add -D
done
