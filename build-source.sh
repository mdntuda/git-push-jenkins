#!/bin/bash

value=$(cat /home/localadmin/jenkins-home/jobs/Git-Check/builds/lastSuccessfulBuild/log | grep -c "nothing to do")
if [ $value -eq 1 ]
  then
	echo "pattern is inside"
  else
	echo "pattern not inside, so we compile the code!"
	cd /filepath/to/Java-Project/Java-Test/

	#now we check for latest folder which updated by git
	newest_folder=$(find * -type d -prune | tail -n 1)
	echo "Last folder uploaded is: $newest_folder"

	#check whether it is really a folder
	if [ -d "$newest_folder" ]
	  then
		cd $newest_folder/src
		for file in * 
		  do
			while inotify -q -e modify file
			do
                          javac $file
			done
		  done
		
		echo "done!"
	  else
		echo "no file in newst folder! nothing to do!"
	fi
fi
