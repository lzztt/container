set -e

SRC=/home/src
NGINX=nginx-1.19.6
PHP=php-8.0.0
MAXMINDDB=1.8.0
REDIS=redis-5.3.2
XDEBUG=xdebug-3.0.1

wget -qO- https://nginx.org/download/$NGINX.tar.gz | tar -zx -C $SRC
cd $SRC/$NGINX
#grep 'nginx/' src/core/*
sed -i 's!nginx/!lzx/!' src/core/nginx.h
#grep 'Server: nginx' src/http/*
sed -i 's!Server: nginx!Server: lzx!' src/http/ngx_http_header_filter_module.c
#grep 'nginx' src/http/*
sed -i 's!<center>nginx</center>!<center>lzx</center>!' src/http/ngx_http_special_response.c
#grep 'nginx\[5\] = "\\x84\\xaa\\x63\\x55\\xe7"' src/http/v2/ngx_http_v2_filter_module.c
#    static const u_char nginx[5] = "\x84\xaa\x63\x55\xe7";
sed -i 's!nginx\[5\] = "\\x84\\xaa\\x63\\x55\\xe7"!nginx\[4\] = "\\x83\\xa3\\xdf\\x9f"!' src/http/v2/ngx_http_v2_filter_module.c


wget -qO- https://www.php.net/distributions/$PHP.tar.gz | tar -zx -C $SRC
cd $SRC/$PHP/ext
wget -qO- https://pecl.php.net/get/$XDEBUG.tgz | tar -zx && mv $XDEBUG xdebug
wget -qO- https://pecl.php.net/get/$REDIS.tgz | tar -zx && mv $REDIS redis
wget -qO- https://github.com/maxmind/MaxMind-DB-Reader-php/archive/v$MAXMINDDB.tar.gz | tar -zx && mv MaxMind-DB-Reader-php-$MAXMINDDB/ext maxminddb

