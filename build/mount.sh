set -e

mkdir -p /home/src /home/app
mount -t tmpfs -o size=2G tmpfs /home/src
