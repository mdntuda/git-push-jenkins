import paramiko
import os
import sys

hostname = '#enter_your_host_name_here'
password = '#the_password_for_host'
source = sys.argv[1]
bundle_name = sys.argv[2]
destination = '#the_path_of_Karaf_deploy_folder'

username = 'root'
port = 22

print("Source Path " + source)
print(os.listdir(source))
sourceFiles = os.listdir(source)
print("Source Files: " + str(sourceFiles))
print("Check if sources exist: " + str(os.path.exists(source)))

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

client.connect(hostname, port, username, password)

####### these code lines do not work, since Jenkins will not execute it!
sftp = client.open_sftp()
#files = sftp.listdir()
#print(files)

des = sftp.stat(destination)
print(str(des))


localpath = source + '/' + bundle_name
print(localpath)
remotepath = destination + '/' + bundle_name

sftp.put(localpath, remotepath)


sftp.close()
client.close()


