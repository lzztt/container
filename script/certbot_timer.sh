cat /etc/cron.d/certbot 
ls /etc/systemd/system/certbot.timer
systemctl list-timers --all
systemctl cat certbot.timer
sed -e 's/twice //' -e 's/00,12/03/' -e 's/RandomizedDelaySec=.*/RandomizedDelaySec=1800/' /lib/systemd/system/certbot.timer > /etc/systemd/system/certbot.timer
diff /{lib,etc}/systemd/system/certbot.timer
systemctl daemon-reload
systemctl cat certbot.timer
