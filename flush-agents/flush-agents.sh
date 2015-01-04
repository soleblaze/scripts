#!/usr/bin/bash

# remove saved passphrases in gpg-agent
/usr/bin/pkill -SIGHUP gpg-agent

# Remove all keys from ssh-agent
for SSH_AUTH_SOCK in `find /tmp/ssh-*/agent.*`; do
    SSH_AUTH_SOCK=$SSH_AUTH_SOCK /usr/bin/ssh-add -D
done
