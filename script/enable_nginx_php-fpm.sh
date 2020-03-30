ln -s /home/app/nginx/sbin/nginx.service /etc/systemd/system/
ln -s /home/app/php/sbin/php-fpm.service /etc/systemd/system/
systemctl daemon-reload

systemctl cat php-fpm
systemctl cat nginx

systemctl enable php-fpm
systemctl enable nginx