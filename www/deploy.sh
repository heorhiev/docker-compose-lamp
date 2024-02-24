echo "127.0.0.1 $DOMAIN" >> /etc/hosts.conf

a2ensite ${DOMAIN}.conf;
a2ensite default.conf;

service apache2 reload;

apt-get update
apt-get install -y unzip
apt-get install -y cron
apt-get install -y supervisor

su www-data

cd /var/www/html/site

echo "No" | php /var/www/html/site/init

echo "y" | composer update --ignore-platform-reqs