#########################################################################
# File Name: fetch.sh
# Author: Bo Yu
# mail: tsu.yubo@gmail.com
# Created Time: Wednesday, May 18, 2016 AM11:17:30 HKT
##########################################################################
#!/bin/bash
git fetch origin && git rebase origin/master
