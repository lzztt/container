set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd /home/src
edge=`ls -d nginx-* | tail -n 1`
cd $edge

make clean || echo

export CFLAGS='-O2'
export CXXFLAGS='-O2'

APPDIR=/home/app/$edge

./configure \
--prefix=$APPDIR \
--user=web \
--group=web \
--with-cc-opt='-O2' \
`awk '/^--/{print $1}' $DIR/nginx_with*_module.conf`

nproc=$(grep -c ^processor /proc/cpuinfo)
make -j $nproc && make install

cat <<'EOF' > $APPDIR/sbin/nginx.service
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/home/app/nginx/sbin/nginx -t
ExecStart=/home/app/nginx/sbin/nginx
ExecReload=/home/app/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=false

[Install]
WantedBy=multi-user.target
EOF
