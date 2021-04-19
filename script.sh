#!/bin/bash

# Some Important variables
dbname="wordpress_db"
dbuser="wordpress_user"
dbpass="password"
dbroot="root"

# Setup LAMP server
apt update
apt install apache2 mysql-server php libapache2-mod-php php-mysql -y
apt install php libapache2-mod-php php-mysql -y
apt install unzip expect -y

# Download and setup wordpress
cd /var/www/html
wget http://wordpress.org/latest.zip
unzip latest.zip
rm -rf latest.zip
chown -R www-data:www-data wordpress
cd wordpress
cp wp-config-sample.php wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mysql -u root <<-EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$dbroot';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
create database $dbname;
CREATE USER '$dbuser' @'localhost' IDENTIFIED BY '$dbpass';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';
FLUSH PRIVILEGES;
exit
EOF
echo "Configured db" >> /tmp/i.log
cd /etc/apache2/sites-available
echo >> wordpress.conf

# create an wordpress apache config
cat > wordpress.conf << EOF1
<VirtualHost *:80>

ServerAdmin localhost
DocumentRoot /var/www/html/wordpress

<Directory /var/www/html/wordpress>
     Options Indexes FollowSymLinks
     AllowOverride All
     Require all granted
</Directory>

ErrorLog ${APACHE_LOG_DIR}/your_domain.com_error.log 
CustomLog ${APACHE_LOG_DIR}/your_domain.com_access.log combined 
</VirtualHost>
EOF1

# disable default wp config and enable the new one
a2enmod rewrite
a2dissite 000-default.conf
a2ensite wordpress.conf
service apache2 restart