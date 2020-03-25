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
libmagickcore-6.q16-6 \
libmagickwand-6.q16-6 \
libmagickcore-dev \
libmagickwand-dev \
libgeoip1 \
libgeoip-dev
