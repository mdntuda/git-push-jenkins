#!/bin/bash

#first check for git-status, if something changed, then execute maven-build
git_status=$(grep "new code downloaded" ~/jenkins-home/jobs/Git-Check/lastStable/log)

if [ "$git_status" == "new code downloaded" ]
  then
	#check for pom.xml file in a latest uploaded folder
	cd /file/path/for/git-server

	newest_folder=$(ls -t | head -n 1)

	if [ -d "$newest_folder" ]
  	  then
    		cd $newest_folder
    		#check for existing of pom.xml file 
    		pom_file=$(find * -name '*.xml')
    
    		counter=$(find * -name '*.xml' | wc -l)
    
    		  if [ "$counter" == 1 ]
      			then
        		  echo "compile-please ------ >>>>> process running"
        	          #the project will be compiled
        		  #every details will be written into a file called log.txt
        		  mvn package > log.txt
        
        		  #now check for log.txt after status of compiled project
        		  status_project=$(grep -w "BUILD*" log.txt | (grep -o "BUILD SUCCESS" || grep -o "BUILD FAILURE"))
        
        		  #check now for status failed or success and to continued
        			if [ "$status_project" == "BUILD SUCCESS" ]
          			  then
          				echo "deploy bundle"
        			else
        				echo "bundle building failed"
        			fi
        
     		else
     			echo "no-mvn-project"
     
    		fi
    
	fi
	
  else
    echo "no-maven-project"
	
fi
