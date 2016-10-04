# PhpMyAdmin

## Clone the latest version.
`sudo git clone --depth=1 --branch=STABLE https://github.com/phpmyadmin/phpmyadmin.git /usr/share/phpmyadmin`

## Create and edit PhpMyAdmin config.

`sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php`

Seek line `$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */` and add blowfish secret based on https://www.question-defense.com/tools/phpmyadmin-blowfish-secret-generator

Uncomment lines after `/* Storage database and tables */`

## Append Apache2 configuration
`nano /etc/apache2/sites-available/000-default.conf`

~~~~
Alias /phpmyadmin "/usr/share/phpmyadmin/"
<Directory "/usr/share/phpmyadmin/">
     Order allow,deny
     Allow from all
     Require all granted
</Directory>
~~~~

Restart Apache2: `sudo service apache2 restart`

