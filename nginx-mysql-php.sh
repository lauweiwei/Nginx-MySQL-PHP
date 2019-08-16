# clone git
  mkdir /root/downloads
  cd downloads
  git clone https://github.com/lauweiwei/Nginx-MySQL-PHP.git
  cd
#check package installed
systemctl status mysqld > /dev/null
if [ $? -eq 0 ]; then
  echo "mysqld service is installed"
else
  echo "mysqld service is not installed"
  #remove some directories/ files
  rm -rf /var/lib/mysql
  rpm -e --nodeps mysql57-community-release-el7-7.noarch
  rm -f /var/log/mysqld.log
  #install mysql
  # Get the repo RPM and install it.
  wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm 
  yum -y install ./mysql57-community-release-el7-7.noarch.rpm 
  # Install the server and start it
  yum -y install mysql-community-server 
  systemctl start mysqld 
  # Get the temporary password
  temp_password=$(grep password /var/log/mysqld.log | awk '{print $NF}')
  echo "Your temporary password is $temp_password"
  
  #Set up a batch file with the SQL commands
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Abc@1234'; flush privileges;" > reset_pass.sql
  # Log in to the server with the temporary password, and pass the SQL file to it.
  mysql -u root --password="$temp_password" --connect-expired-password < reset_pass.sql 
  mysql -u root -pAbc@1234 < /root/downloads/Nginx-MySQL-PHPfpm-CentOS7/createDB.txt
  mysql -u root -pAbc@1234 example < /root/downloads/Nginx-MySQL-PHPfpm-CentOS7/example.sql
fi

#systemctl status nginx > /dev/null
if [ $? -eq 0 ]; then
  echo "nginx service is installed"
else
  echo "nginx service is not installed"
  yum install epel-release -y
  yum install nginx -y
  systemctl enable nginx
  systemctl start nginx
fi

systemctl status php72-php-fpm > /dev/null
if [ $? -eq 0 ]; then
  echo "php-fpm service is installed"
else
  echo "php-fpm service is not installed"
  yum -y install php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache 
fi

#check github config
  nginx1=$(md5sum /root/downloads/Nginx-MySQL-PHP/default1.conf | cut -c1-33)
  nginx2=$(md5sum /etc/nginx/conf.d/default1.conf | cut -c1-33)
  if [ "$nginx1" == "$nginx2" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/default1.conf /etc/nginx/conf.d/default1.conf
    echo "File updated!"
  fi

  php1=$(md5sum /root/downloads/Nginx-MySQL-PHP/index.php | cut -c1-33)
  php2=$(md5sum /var/www/php1/index.php | cut -c1-33)
  if [ "$php1" == "$php2" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/index.php /var/www/php1/index.php
    echo "File updated!"
  fi

  mysql1=$(md5sum /root/downloads/Nginx-MySQL-PHP/my.cnf | cut -c1-33)
  mysql2=$(md5sum /etc/my.cnf| cut -c1-33)
  if [ "$mysql1" == "$mysql2" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/my.cnf /etc/my.cnf
    echo "File updated!"
  fi

  nginx3=$(md5sum /root/downloads/Nginx-MySQL-PHP/nginx.conf | cut -c1-33)
  nginx4=$(md5sum /etc/nginx/nginx.conf | cut -c1-33)
  if [ "$nginx3" == "$nginx4" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/nginx.conf /etc/nginx/nginx.conf
    echo "File updated!"
  fi

  php3=$(md5sum /root/downloads/Nginx-MySQL-PHP/php.ini | cut -c1-33)
  php4=$(md5sum /etc/opt/remi/php72/php.ini | cut -c1-33)
  if [ "$php3" == "$php4" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/php.ini /etc/opt/remi/php72/php.ini
    echo "File updated!"
  fi

  php5=$(md5sum /root/downloads/Nginx-MySQL-PHP/www.conf | cut -c1-33)
  php6=$(md5sum /etc/opt/remi/php72/php-fpm.d/www.conf | cut -c1-33)
  if [ "$php5" == "$php6" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/www.conf /etc/opt/remi/php72/php-fpm.d/www.conf
    echo "File updated!"
  fi

  php7=$(md5sum /root/downloads/Nginx-MySQL-PHP/php-fpm.conf | cut -c1-33)
  php8=$(md5sum /etc/opt/remi/php72/php-fpm.conf | cut -c1-33)
  if [ "$php7" == "$php8" ]; then
    echo "Files are equal"
  else
    echo "Files are not equal"
    mv /root/downloads/Nginx-MySQL-PHP/php-fpm.conf /etc/opt/remi/php72/php-fpm.conf
    echo "File updated!"
  fi
