set -e

if [[ `grep -c ^web: /etc/passwd` == 0 ]]; then
    addgroup --gid 1000 web;
    adduser --uid 1000 --gid 1000 --disabled-password --gecos '' web;
fi

sed -i 's!^deb http://security!#deb http://security!' /etc/apt/sources.list
apt update && apt -y full-upgrade && apt autoremove

apt -y install \
wget \
build-essential \
autoconf \
libpcre3 \
libpcre3-dev \
libssl-dev \
zlib1g \
zlib1g-dev \
libonig5 \
libonig-dev \
libargon2-1 \
libargon2-dev \
libcurl4 \
libcurl4-openssl-dev \
libfreetype-dev \
libfreetype6 \
libjpeg62-turbo-dev
libjpeg62-turbo \
libpng-dev \
libpng16-16 \
libmaxminddb0 \
libmaxminddb-dev
