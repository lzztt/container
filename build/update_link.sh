set -e

cd /home/app

for app in php nginx; do
    curr=`readlink $app`
    next=`ls -dt ${app}-*[0-9] | head -n 1`

    if [[ "$curr" == "$next" ]]; then
        continue;
    fi

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
