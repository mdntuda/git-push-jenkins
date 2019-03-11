#!/bin/bash

whoami=$(whoami)
echo $whoami 

#check for latest uploaded folder by git

cd /home/localadmin/UAALACT/IoTVerwaltung/Java-Test

#take only one folder, which was uploaded via git
newest_folder=$(find * -type d -prune | tail -n 1)

if [ -d "$newest_folder" ]
  then 
	cd $newest_folder
	#check if there is a jar-file
	find_result=$(grep -nr '*.jar' .)

	#convert the result to number
	counter=$($find_result | wc -l)

	if [ "$counter" -ge 1 ]
	  then 
		echo "jar-file inside"
	else
	 echo "no-result"
	fi 


fi
