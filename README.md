# git-push-jenkins
When a developer pushs his code to git server. The code will be compiled by Maven and copied to a remote machine(PC, Notebook, VM, Pi etc.)

## After installing successfully Tomcat and Jenkins and create an user account inside Jenkins. Now on the VM, there is an account with username: #your-choosing-username and password: #your-password

It's time to create our chain. First go to "New Item" on the left handside of Jenkins Dashboard:



 Then this will apppear:



Choose "Freestyle project" and give the project the name. 

Since my first "job" in Jenkins is "Git-Check", I give "Git-Check" as name of a job → click on OK.





Scroll down to "Build"

 



Click on "Add build step".

Select "Execute shell". This will give you a textfield to type in where your shell-script should be.

There I give the path where Jenkins can find my Shell-Script to execute. In this case it is in: 

/home/localadmin/jenkins-home/scripts/git-check.sh

The according script file is attach here: 
git-check.sh

This file will check if some new source code uploaded to Git, then it will give the status: "new code downloaded" and "nothing to do" otherwise.

After typing in Jenkins where the script can be founded by Jenkins, just hit "Save" to create the first job in Jenkins.

Already you can execute the first job. When you wisch, you can "build" it.

This process you do for two another jobs, namely: maven-source and Deploy-Bundle. For the job maven-source you need the shell script:  maven-build.sh

maven-build.sh

and the job Deploy-Bundle needs: deploy-bundle.sh

deploy-bundle.sh

The shell script deploy-bundle.sh needs a Python-script to be able to deploy the bundle to a client running Karaf, the file name is datacopy.py

datacopy.py



After creating these three jobs. Just run the first job and the chain will be automatically complete. 

Have fun!
