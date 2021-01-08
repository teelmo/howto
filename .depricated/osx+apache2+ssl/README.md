# OSX + Apache2 + SSL

This howto assumes that Apache2 is installed from Macports. Works for build in Apache also but paths need to be changed accordingly.

Howto is based on:
* [How To Create a Self-Signed SSL Certificate for Apache in Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-16-04)
* [OS X 10.11 El Capitan Apache Setup: SSL](https://getgrav.org/blog/mac-os-x-apache-setup-ssl)

## Create directories

First we need to create directories.

`sudo mkdir /opt/local/ssl && sudo mkdir /opt/local/ssl/private && sudo mkdir /opt/local/ssl/certs`

## Create a self-signed key and certificate pair with OpenSSL in a single command

Updated: [CHROME DEPRECATES SUBJECT CN MATCHING](https://textslashplain.com/2017/03/10/chrome-deprecates-subject-cn-matching/)

First store config file to `/opt/local/ssl/dev.yle.fi.conf` containing following:

~~~~
[ req ]
default_bits                = 2048
default_keyfile             = certs/dev.yle.fi.crt
distinguished_name          = subject
req_extensions              = req_ext
x509_extensions             = x509_ext
string_mask                 = utf8only

# The Subject DN can be formed using X501 or RFC 4514 (see RFC 4519 for a description).
#   Its sort of a mashup. For example, RFC 4514 does not provide emailAddress.
[ subject ]
countryName                 = Country Name (2 letter code)
countryName_default         = FI

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = Uusimaa

localityName                = Locality Name (eg, city)
localityName_default        = Helsinki

organizationName            = Organization Name (eg, company)
organizationName_default    = Yle

# Use a friendly name here because its presented to the user. The server's DNS
#   names are placed in Subject Alternate Names. Plus, DNS names here is deprecated
#   by both IETF and CA/Browser Forums. If you place a DNS name here, then you 
#   must include the DNS name in the SAN too (otherwise, Chrome and others that
#   strictly follow the CA/Browser Baseline Requirements will fail).
commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_default          = dev.yle.fi

emailAddress                = Email Address
emailAddress_default        = teemo.tebest@yle.fi

# Section x509_ext is used when generating a self-signed certificate. I.e., openssl req -x509 ...
[ x509_ext ]

subjectKeyIdentifier        = hash
authorityKeyIdentifier      = keyid,issuer

# You only need digitalSignature below. *If* you don't allow
#   RSA Key transport (i.e., you use ephemeral cipher suites), then
#   omit keyEncipherment because that's key transport.
basicConstraints            = CA:FALSE
keyUsage                    = digitalSignature, keyEncipherment
subjectAltName              = @alternate_names
nsComment                   = "OpenSSL Generated Certificate"

# RFC 5280, Section 4.2.1.12 makes EKU optional
#   CA/Browser Baseline Requirements, Appendix (B)(3)(G) makes me confused
#   In either case, you probably only need serverAuth.
# extendedKeyUsage  = serverAuth, clientAuth

# Section req_ext is used when generating a certificate signing request. I.e., openssl req ...
[ req_ext ]

subjectKeyIdentifier        = hash

basicConstraints            = CA:FALSE
keyUsage                    = digitalSignature, keyEncipherment
subjectAltName              = @alternate_names
nsComment                   = "OpenSSL Generated Certificate"

# RFC 5280, Section 4.2.1.12 makes EKU optional
#   CA/Browser Baseline Requirements, Appendix (B)(3)(G) makes me confused
#   In either case, you probably only need serverAuth.
# extendedKeyUsage  = serverAuth, clientAuth

[ alternate_names ]

DNS.1         = dev.yle.fi

# Add these if you need them. But usually you don't want them or
#   need them in production. You may need them for development.
# DNS.5       = localhost
# DNS.6       = localhost.localdomain
# DNS.7       = 127.0.0.1

# IPv6 localhost
# DNS.8     = ::1

# IPv4 localhost
# IP.1       = 127.0.0.1

# IPv6 localhost
# IP.2     = ::1
~~~~

Then we need to create a self-signed certificate. Pick up filenames of your choise.

`sudo openssl req -config /opt/local/ssl/dev.yle.fi.conf -new -x509 -sha256 -newkey rsa:2048 -nodes -keyout /opt/local/ssl/private/dev.yle.fi.key -days 365 -out /opt/local/ssl/certs/dev.yle.fi.crt`

**Fill out the prompts appropriately.** The most important line is the one that requests the Common Name (e.g. server FQDN or YOUR name). You need to enter the domain name associated with your server or, more likely, your server's public IP address.

~~~~
writing new private key to '/opt/local/ssl/private/dev.yle.fi.key'

Country Name (2 letter code) [FI]:
State or Province Name (full name) [Uusimaa]:
Locality Name (eg, city) [Helsinki]:
Organization Name (eg, company) [Yle]:
Common Name (e.g. server FQDN or YOUR name) [dev.yle.fi]:
Email Address [teemo.tebest@yle.fi]:
~~~~

## Enable SSL support in Apache

`sudo subl /opt/local/apache2/conf/httpd.conf`

Remove leading `#` from lines if exists.

~~~~
LoadModule ssl_module libexec/apache2/mod_ssl.so
...
Include /private/etc/apache2/extra/httpd-ssl.conf
~~~

## Remove default configuration

Commend any existing virtual host configuration.

`sudo subl /opt/local/apache2/conf/extra/httpd-ssl.conf`

Seek for a row that says `<VirtualHost _default_:443>` and comment everything with `#` until `</VirtualHost>`.

Overlapping virtual hosts will give you following error: `[warn] _default_ VirtualHost overlap on port 443, the first has precedence`

## Create new SSL virtual host

`sudo subl /opt/local/apache2/conf/extra/httpd-vhosts.conf`

Append these lines while changing following:

* DocumentRoot "/Users/teelmo/Repositories/plus/"
* &lt;Directory /Users/teelmo/Repositories/plus/&gt;

~~~~
<IfModule mod_ssl.c>
    <VirtualHost *:443>
        ServerName dev.yle.fi:443

        DocumentRoot "/Users/teelmo/Repositories/plus/"

        SSLEngine on

        ErrorLog "/var/log/apache2/yle.local.ssl-error_log"
        CustomLog "/var/log/apache2/yle.local.ssl-access_log" common

        SSLCertificateFile      /opt/local/ssl/certs/dev.yle.fi.crt
        SSLCertificateKeyFile   /opt/local/ssl/private/dev.yle.fi.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
            SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
        </Directory>
        <Directory /Users/teelmo/Repositories/plus/>
            Order Allow,Deny
            Allow from All
            AllowOverride All
            Options Indexes FollowSymlinks Multiviews
            Header always set Access-Control-Allow-Origin "*"
            Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
            Header always set Access-Control-Max-Age "1000"
            Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token"
        </Directory>
    </VirtualHost>
</IfModule>
~~~~

## Make sure default OSX Apache is not runnig

`sudo apachectl stop`

## Restart apache

Stop: `sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper stop`

Start: `sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper start`

Restart: `sudo /opt/local/etc/LaunchDaemons/org.macports.apache2/apache2.wrapper restart`

## Trust yourself

1. Import the `/opt/local/ssl/certs/dev.yle.fi.crt` file to your Keychain.
2. Change Trust to Always Trust
3. Restart Chrome.
...
5. Profit