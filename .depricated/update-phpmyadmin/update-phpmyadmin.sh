#!/bin/bash

# Get latest snapshot.
wget http://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.zip -O /home/teelmo/phpmyadmin.zip

# Unzip file.
unzip /home/teelmo/phpmyadmin.zip -d /home/teelmo/phpmyadmin

# Remove zip.
rm /home/teelmo/phpmyadmin.zip

# Store config file.
cp /usr/share/phpmyadmin/config.inc.php /home/teelmo/phpmyadmin/php*

# Remove old version.
sudo rm -rf /usr/share/phpmyadmin/*

# Copy new files.
sudo mv /home/teelmo/phpmyadmin/php*/* /usr/share/phpmyadmin

# Clean up.
rmdir /home/teelmo/phpmyadmin