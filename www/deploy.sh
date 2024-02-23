echo "127.0.0.1	crm.$DOMAIN" >> /etc/hosts.conf
echo "127.0.0.1	my.$DOMAIN"  >> /etc/hosts.conf
echo "127.0.0.1 $DOMAIN"     >> /etc/hosts.conf
echo "127.0.0.1	api.$DOMAIN" >> /etc/hosts.conf

a2ensite crm.${DOMAIN};
a2ensite my.${DOMAIN};
a2ensite ${DOMAIN};
a2ensite api.${DOMAIN};

service apache2 reload;

apt-get update
apt-get install -y unzip
apt-get install -y cron
apt-get install -y supervisor

su www-data

cd /var/www/html/keycrm/base/crm

echo "No" | php /var/www/html/keycrm/base/crm/init --env=Development

echo "y" | composer update --ignore-platform-reqs

echo "y" | php /var/www/html/keycrm/base/crm/yii migrate