#########################################################################
# File Name: tmp/set_commit_signed.sh
# Author: Bo Yu
# mail: tsu.yubo@gmail.com
# Created Time: Sat 28 May 2022 11:20:38 AM
##########################################################################
#!/bin/bash

git config --global user.signingkey "143E4BAF"
git config --global commit.gpgsign true
git config gpg.program gpg

export GPG_TTY=$(tty)

gpgconf --kill gpg-agent

