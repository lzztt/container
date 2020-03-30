file=/etc/letsencrypt/renewal-hooks/deploy/01-reload-nginx
cat <<EOF > $file 
#! /bin/sh
set -e

/home/app/nginx/sbin/nginx -t
service nginx reload
EOF

chmod +x $file
