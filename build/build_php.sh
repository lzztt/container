DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd /home/src
edge=`ls -d php-* | tail -n 1`
cd $edge

make clean

export CFLAGS='-O2'
export CXXFLAGS='-O2'
export CFLAGS="$CFLAGS -DMYSQLI_NO_CHANGE_USER_ON_PCONNECT"
export PROG_SENDMAIL='/usr/sbin/sendmail'

APPDIR=/home/app/$edge

./buildconf

./configure --prefix=$APPDIR --with-layout=GNU --with-config-file-path=$APPDIR/etc --with-config-file-scan-dir=$APPDIR/etc/conf.d  --localstatedir=/var `grep -v '^#' $DIR/php_module.conf | tr '\n' ' '`

nproc=$(grep -c ^processor /proc/cpuinfo)
make -j $nproc && make install

cp -pr sapi/fpm/init.d.php-fpm $APPDIR/sbin/
chmod 755 $APPDIR/sbin/init.d.php-fpm

cp -pr sapi/fpm/php-fpm.service $APPDIR/sbin/
sed -i.orig -e 's!var/run!run!' -e 's/ProtectHome/#ProtectHome/' -e 's/PrivateTmp=true/PrivateTmp=false/' /home/app/$edge/sbin/php-fpm.service

cd ext
export PATH=$APPDIR/bin:$PATH
for i in maxminddb imagick; do
    cd $i
    phpize
    ./configure
    make
    make install
    cd ..
done
