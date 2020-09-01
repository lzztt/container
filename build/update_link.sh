set -e

cd /home/app

for app in php nginx; do
    curr=`readlink $app`
    next=`ls -d ${app}-* | tail -n 1`

    chown -R root:root "$next"
    cd "$next"
    for i in etc conf; do
        if [ -d "$i" ]; then
            mv "$i" "${i}.orig"
            cp -pr "../$curr/$i" ./
            echo "updated $next/$i"
        fi
    done
    cd ..

    rm $app
    ln -s $next $app
    echo "linked $app"
done

systemctl daemon-reload
systemctl stop nginx && \
systemctl stop php-fpm && \
systemctl start php-fpm && \
systemctl start nginx