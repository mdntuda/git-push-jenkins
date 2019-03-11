import paramiko
import os
import sys

hostname = 'capfloor20'
password = 'CapFloor'
source = sys.argv[1]
bundle_name = sys.argv[2]
destination = '/home/root/apache-karaf/deploy'

username = 'root'
port = 22

print("Source Path " + source)
print(os.listdir(source))
sourceFiles = os.listdir(source)
print("Source Files: " + str(sourceFiles))
print("Nachschauen, ob die Source existiert: " + str(os.path.exists(source)))

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


