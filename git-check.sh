#!/bin/bash

cd /filepath/to/your/git/server/folder
git_state=$(git pull)
if [[ $git_state = *"up-to-date"* ]]
  then
	echo "nothing to do"
  else
	git fetch
	echo "new code downloaded"
fi
