#!/bin/bash

NAME=www.myroger.fr
REL_PATH=/var/www/ssl/www.myroger.fr

if [ $EUID -ne 0 ];
then
	echo -e "Please run as root"
exit 1
fi

if [ ! -d /var/www/ssl ];
then
	mkdir /var/www/ssl
fi

if [ ! -d $REL_PATH ];
then
	mkdir $REL_PATH
fi

echo -e "\e[36;1m** SSL CERTIFICAT GENERATOR **\e[0m"

openssl genrsa -des3 -out $REL_PATH/$NAME.key 1024

# GENERATING CSR FILE
openssl req -new -key $REL_PATH/$NAME.key -out $REL_PATH/$NAME.csr

# CREATING BACKUP OF THE KEY
cp $REL_PATH/$NAME.key $REL_PATH/$NAME.key.org
openssl rsa -in $REL_PATH/$NAME.key.org -out $REL_PATH/$NAME.key

#CERTIFICATE GENERATiON
openssl x509 -req -days 365 -in $REL_PATH/$NAME.csr -signkey $REL_PATH/$NAME.key -out $REL_PATH/$NAME.crt
