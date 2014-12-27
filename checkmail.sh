#!/usr/bin/zsh

function checkmail() {
    maildir="$1"
    email="$2"

    if [ "$(ls $maildir)" ]; then
        count="$(ls $maildir | wc -l)"
        if [ "$count" -eq 1 ]; then
            echo "\e[1;92m$email\e[m has $count new message:"
        else
            echo "\e[1;92m$email\e[m has $count new messages:"
        fi
        for mail in $(ls $maildir); do
            from="$(grep "^From: " "$maildir/$mail" | sed 's/From:\ //')"
            subject="$(grep "^Subject: " "$maildir/$mail" | sed 's/Subject:\ //')"
            echo "$from - $subject"
        done
        echo
    fi
}

checkmail ~/.mail/Inbox/new email@example.com
