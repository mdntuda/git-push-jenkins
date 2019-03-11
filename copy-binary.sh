#!/bin/bash

#check if binary files are modified
#if yes -> copy to source

cd /home/localadmin/UAALACT/IoTVerwaltung/Java-Test

newest_folder=$(find * -type d -prune | tail -n 1)

if [ -d "$newest_folder" ]
  then
	cd $newest_folder/src
	for file in *
	  do
		python3 /home/localadmin/jenkins-home/scripts/datacopy.py
	  done

  else
	echo "no new binaries to copy!"
fi
