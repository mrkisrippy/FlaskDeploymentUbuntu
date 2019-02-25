# INITIAL SERVER SETUP
adduser harry
usermod -aG sudo harry
ufw app list # [to check]
ufw allow OpenSSH
ufw enable # [y enter]
ufw status # [to check]
# Now login as harry using putty and ssh


# INSTALLING APACHE
sudo apt update
sudo apt --assume-yes install apache2
sudo ufw app list
sudo ufw app info "Apache Full" # [just to see info]
sudo ufw allow in "Apache Full"


# INSTALLING MYSQL
sudo apt --assume-yes install mysql-server
sudo mysql
mysql> SELECT user,authentication_string,plugin,host FROM mysql.user;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'MyStrongPassword123'; # [This will be mysql password]
mysql> FLUSH PRIVILEGES;
mysql> SELECT user,authentication_string,plugin,host FROM mysql.user; # [just to check]
mysql> exit


# INSTALLING PHP
sudo apt --assume-yes install php libapache2-mod-php php-mysql
sudo nano /etc/apache2/mods-enabled/dir.conf # replace index.html by index.php and vice versa
sudo systemctl restart apache2
sudo nano /var/www/html/info.php

# Create info.php to test as follows:
<?php
phpinfo();
?>


# INSTALLING PHPMYADMIN
sudo apt install phpmyadmin php-mbstring php-gettext # press space to select apache2
sudo phpenmod mbstring
sudo systemctl restart apache2
sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user; # (just to see)
SELECT user,authentication_string,plugin,host FROM mysql.user; # (to check)
CREATE USER 'harry'@'localhost' IDENTIFIED BY 'MyStrongPassword123';
GRANT ALL PRIVILEGES ON *.* TO 'harry'@'localhost' WITH GRANT OPTION;
exit


# DEPLOYING FLASK APP
sudo apt-get install libapache2-mod-wsgi-py3
sudo a2enmod wsgi 
cd /var/www 
sudo mkdir cwh
cd cwh
sudo mkdir cwh
cd cwh


		# GITHUB SSH KEYS
		# Do sudo su before these steps
		ssh-keygen -t rsa -b 4096 -C "name@domain.com"
		eval $(ssh-agent -s)
		ssh-add ~/.ssh/id_rsa
		copy using vim ~/.ssh/id_rsa.pub


sudo apt --assume-yes install python3-pip 
sudo pip3 install virtualenv
sudo virtualenv venv 
source venv/bin/activate
sudo apt --assume-yes install libmysqlclient-dev 
pip install flask flask-sqlalchemy requests bs4 pandas mysqlclient
deactivate
sudo nano /etc/apache2/sites-available/cwh.conf # ADD Following
<VirtualHost *:80>
		ServerName server.com
		ServerAdmin name@server.com
		WSGIScriptAlias / /var/www/cwh/cwh.wsgi
		<Directory /var/www/cwh/cwh/>
			Order allow,deny
			Allow from all
		</Directory>
		Alias /static /var/www/cwh/cwh/static
		<Directory /var/www/cwh/cwh/static/>
			Order allow,deny
			Allow from all
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		LogLevel warn
		CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

sudo a2ensite cwh
cd /var/www/cwh
sudo nano cwh.wsgi # ADD
#!/usr/bin/python
activate_this = '/var/www/cwh/cwh/venv/bin/activate_this.py'
exec(open(activate_this).read(), dict(__file__=activate_this))
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/cwh/")

from cwh import app as application
application.secret_key = 'Put-your-secret-1234-key!@$$*&&*('


# SSL CERTIFICATE
sudo add-apt-repository ppa:certbot/certbot
sudo apt --assume-yes install python-certbot-apache
sudo certbot --apache -d domain.com -d www.domain.com
sudo certbot renew --dry-run