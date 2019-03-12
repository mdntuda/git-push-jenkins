Assumption:

Virtual Machine with Ubuntu/Debian running is given. In our case we have the server with the following data:

             i) Name: #servername or IPv4-adress: #server-ip-address

            ii) Password: #server-password

            iii) Its a Ubuntu x64 server installed

You test and verify of the existing of this server using putty/SSH-Client!



Now we want to set up the infrastructure:

i) Before starting, make sure which Java SDK version is necessary, if you miss it, it will cost you hours for searching the problems! In our case here,

   we go to Oracle, download it with your Windows machine and move the JDK-file.tar.gz file inside your home folder (since we do it manually, because Oracle not let you install via webupd8te, make sure you download the right version for your server!)

   - Here I download:  jdk-8u161-linux-x64.tar.gz with my windows and use WinSCP to move the zip-file to /home/localadmin

   - Extract it: localadmin@Ubuntu:~$tar -xzvf  jdk-8u161-linux-x64.tar.gz → it creates the folder:  jdk1.8.0_161 

   - Move it to /opt folder: localadmin@Ubuntu:~$sudo mv jdk1.8.0_161 /opt

  - Now we make systemwide usage of this jdk (basically its a process of settings environment variables and linking the important tools)

         + change .bashrc with: nano ~/.bashrc  (or use some other texteditor like vim or emacs)

                 in the last line paste in: export JAVA_HOME=/opt/jdk1.8.0_161/

                                                      export PATH=$JAVA_HOME/bin:$PATH

                then type in on the therminal: localadmin@Ubuntu:~$source ~/.bashrc

        + type in following commands for settings java, javac

                                                     sudo update-alternatives  --install /usr/bin/java java /opt/jdk1.8.0_161/bin/java 1000

                                                     sudo update-alternatives  --install /usr/bin/javac javac /opt/jdk1.8.0_161/bin/javac 1000

                                                     sudo update-alternatives  --install /usr/bin/javadoc javadoc /opt/jdk1.8.0_161/bin/javadoc 1000

                                                     sudo update-alternatives  --install /usr/bin/javap javap /opt/jdk1.8.0_161/bin/javap 1000



                           For your interest of future when Java is too "old" and Java 9 is there, you want to redo all the configuration you make with Java use this command:

                                                   sudo update-alternatives --remove "java" "/opt/jdk1.8.0_161/bin/java"

                                         

                                          Don't forget to change the JAVA_PATH in ~/.bashrc since we added it!

          finally with : 

                                 sudo update-alternatives  --config java 

                                 sudo update-alternatives  --config javac

                                           type in the number you wish to have(this java8 version we installed is preferable (smile))

         verify the correct settings:

                                 java -version

                                 javac -version

                       both of them should work fine and print out the correct version 1.8.0_161





 ii) Since Jenkins is written in Java and the result of its code is the jenkins.war file and you can run Jenkins itself standalone, but here I have to provide some other tasks, that's the reason for using Tomcat. For executing this *.war file, we need some Servlet-Container to execute this war file. One of the most famous one is  Apache Tomcat(You can also use Eclipse Jetty)

Before doing this, we have to do some preperation first. We create a group and a user whose aim is only for using Tomcat.

Type in in you terminal:

                   localadmin@Ubuntu:~$ sudo groupadd tomcat

                   localadmin@Ubuntu:~$ sudo useradd -s /bin/false -g tomcat -d /



Download Tomcat from its website. I use Tomcat 8.5.24:

                 Download Tomcat: localadmin@Ubuntu:~$ curl -O http://www.gutscheine.org/mirror/apache/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz

                Extract it: localadmin@Ubuntu:~$  tar -xzvf apache-tomcat-8.5.24.tar.gz → it will save everything in the folder: apache-tomcat-8.5.24 in localadmin home(your home folder)

                Copy it to /opt:    localadmin@Ubuntu:~$sudo ~/apache-tomcat-8.5.24 /opt/tomcat

                Change the permission of the folder to group tomcat: localadmin@Ubuntu:~$ sudo chgrp -R tomcat /opt/

                                                                                                     localadmin@Ubuntu:~$ sudo chown -R tomcat /opt/tomcat

                                                                                                     localadmin@Ubuntu:~$ sudo chmod -R 755 /opt/tomcat



Create a service for start it at boot:

                localadmin@Ubuntu:~$ sudo nano /etc/systemd/system/tomcat.service

                   Put the following content inside this file:

                                    

[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/opt/jdk1.8.0_161/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

#Environment=JENKINS_HOME=/opt/jenkins-home


ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target





Save it with Ctrl + o , exit it with Crtl + x

We change some files inside tomcat right now: 

           sudo nano /opt/tomcat/conf/tomcat-users.xml

                      between <tomcat-users> and </tomcat-users> put the following inside:

                          <role rolename="manager-gui"/>

                         <role rolename="admin-gui"/>

                         <username="admin" password="password" roles="manager-gui, admin-gui" />



                    Ctrl+o and Ctrl+x to exit Nano.

Now restart the tomcat process with: sudo systemctl restart tomcat



Open your browser and type in: your-ip-adress:8080

          As result you should see the starting page of Tomcat. 

    

Now run Tomcat with following commands:

              localadmin@Ubuntu:~$ sudo systemctl daemon-reload

              localadmin@Ubuntu:~$ sudo systemctl start tomcat

              localadmin@Ubuntu:~$ sudo systemctl enable tomcat                    <---- to start Tomcat when you boot the system





iii) We now run jenkins with help of Tomcat. For that you download the war version from the homepage: https://jenkins.io/download/

Version(2.89.3) with the command in your terminal: ```:~$wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war ```

               (Warning: Make sure that the jenkins.war file is not corrupt! One method to try it out is run the jenkins file with: java jar jenkins.war, it will create the .jenkins folder in your homefolder, so delete this folder with: rm -rf .jenkins/ If the file is corrupt java will complain)

Change the mode of your jenkins.war file with: ```sudo chmod ugx+rxw jenkins.war ```

Copy (or move) the file: jenkins.war to the webapps folder of Tomcat: ```sudo cp jenkins.war /opt/tomcat/webapps```

Now change the group of the file with: sudo chgrp tomcat jenkins.war and the right of this file: ```sudo chown ug+wrx jenkins.war```

Jenkins will create a folder jenkins for you. The folder should appears very soon after you copy it into webapps folder of Tomcat. 

The last step is to set a folder where jenkins will save all the files. With: ```sudo mkdir /opt/jenkins-home ```

With sudo ```chgrp R tomcat /opt/jenkinshome``` to give the user tomcat access to this folder where jenkins will write all the configuration files inside it.
Set the environment variable: ```nano ~/.bashrc``` in its last line append:    ```export JENKINS_HOME = /opt/jenkins-home```
For some reasons my terminal cannot deal with it, so I made it globally with:    ```sudo nano /etc/profile.d/glob_env_variables.sh``` and put in it 
```export JENKINS_HOME=/opt/jenkins-home```

Even after it, it still doesn't work, so I edit my tomcat.service file: ```sudo nano /etc/systemd/system/tomcat.service``` 
There you see one line which begins with a shebang (#), please remove it.

Since we change on the tomcat.service file, we load it again with: ```sudo systemctl daemon-reload```
Restart the tomcat process again: ```sudo systemctl restart tomcat```

Now everything its running fine and you can call your jenkins in your broser with: http://your-ip-adress:8080/jenkins

Jenkins will start and ask for giving the password for admin. Jenkins will give you the path to the password file. You can get it with sudo less <the-path-to-password-file>



Enjoy!
