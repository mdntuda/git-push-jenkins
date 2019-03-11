#!/bin/bash

cd /home/localadmin/UAALACT
git_state=$(git pull)
if [[ $git_state = *"up-to-date"* ]]
  then
	echo "nothing to do"
  else
	git fetch
	echo "new code downloaded"
fi
