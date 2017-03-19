# LAMP On Linux

[Install LAMP Stack On Ubuntu 16.04](https://www.unixmen.com/how-to-install-lamp-stack-on-ubuntu-16-04/)

## Install Apache2
`sudo apt-get install apache2`

## Install Mysql
`sudo apt-get install mysql-server mysql-client`
`mysql_secure_installation`

# Install Php 7.0

[Installing PHP 7.0](https://www.colinodell.com/blog/2015-12/installing-php-7-0-0)

Add these two lines to your /etc/apt/sources.list file:

```
deb http://packages.dotdeb.org jessie all
deb-src http://packages.dotdeb.org jessie all
```

Add the GPG key:

```
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
```

`sudo apt-get install php7.0-mysql php7.0-curl php7.0-json php7.0-cgi  php7.0 libapache2-mod-php7.0`