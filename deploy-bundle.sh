#!/bin/bash

#we deploy a bundle to the running Karaf
# karaf-folder/deploy

#check the build status of maven
status_maven=$(grep "deploy bundle" /home/localadmin/jenkins-home/jobs/maven-source/lastStable/log)

if [ "$status_maven" == "deploy bundle" ]
  then
    echo "Now deploy bundle!"
    cd /home/localadmin/UAALACT/IoTVerwaltung/Java-Test/
    
    #take the newest folder, since it contains changes
    newest_folder=$(ls -td -- */ | head -n 1)
    cd $newest_folder
    
    #when the bundle file is created, it will create the target folder with *.jar file inside
    #take the *.jar file and copy it to the deploy folder of the client with running Karaf
    
    #get the newest created folder: target/
    bundle_folder=$(ls -td -- */ | head -n 1)
    cd $bundle_folder
    
    #get the name of jar-file with the whole path
    path=$(pwd)
    bundle=$(ls *.jar)
    
    #concatenate to get full path of bundle
    #bundle_fullpath=$($path'/'$bundle)
    
    python3 /home/localadmin/jenkins-home/scripts/datacopy.py $path $bundle
    
    echo "Deploy success!"
  else
    echo "No Deploy!"
fi
