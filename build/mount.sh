set -e

sudo mkdir -p /mnt/src /home/app
sudo chown $(id -u):$(id -g) /mnt/src /home/app
# sudo mount -t tmpfs -o size=2G tmpfs /mnt/src
