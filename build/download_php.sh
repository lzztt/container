set -e

SRC=/mnt/src
PHP=php-8.1.5
MAXMINDDB=1.11.0
REDIS=redis-5.3.7
XDEBUG=xdebug-3.1.4

wget -qO- https://www.php.net/distributions/$PHP.tar.gz | tar -zx -C $SRC
cd $SRC/$PHP/ext
# wget -qO- https://pecl.php.net/get/$XDEBUG.tgz | tar -zx && mv $XDEBUG xdebug
wget -qO- https://pecl.php.net/get/$REDIS.tgz | tar -zx && mv $REDIS redis
wget -qO- https://github.com/maxmind/MaxMind-DB-Reader-php/archive/v$MAXMINDDB.tar.gz | tar -zx && mv MaxMind-DB-Reader-php-$MAXMINDDB/ext maxminddb
