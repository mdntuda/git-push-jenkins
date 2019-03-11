#!/bin/bash

value=$(cat /home/localadmin/jenkins-home/jobs/Git-Check/builds/lastSuccessfulBuild/log | grep -c "nothing to do")
if [ $value -eq 1 ]
  then
	echo "muster ist drin"
  else
	echo "muster nicht drin, so we compile the code!"
	cd /home/localadmin/UAALACT/IoTVerwaltung/Java-Test/

	#now we check for latest folder which updated by git
	newest_folder=$(find * -type d -prune | tail -n 1)
	echo "Last folder uploaded is: $newest_folder"

	#save last access time to a file -> save its name
	#the idea is too complicated: sudo apt-get install inotifywait-tools

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
