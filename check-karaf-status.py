import paramiko
import os

hostname = '#put_your_host_name'
password = '#password_of_your_host'


username = 'root'
port = '22'


client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

client.connect(hostname, port, username, password)

stdin, stdout, stderr = client.exec_command("cd /home/root/apache-karaf/bin \n pwd \n ./status")
x = stdout.read()

print(x)

#y = stdin.read()
#print(y)


#z = stderr.read()
#print(z)


client.close()




