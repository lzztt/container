set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ `grep -c ^web: /etc/passwd` == 0 ]]; then
    addgroup --gid 1000 web;
    adduser --uid 1000 --gid 1000 --disabled-password --gecos '' web;
fi

sed -i 's!^deb http://security!#deb http://security!' /etc/apt/sources.list
apt update && apt -y full-upgrade && apt autoremove

apt -y install `awk '/^[^#]/{print $1}' $DIR/deb.conf`
