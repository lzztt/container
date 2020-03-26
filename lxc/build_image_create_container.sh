sudo go/bin/distrobuilder build-lxc github/container/lxc/debian.yaml /data/image
lxc-create -t local -n dev -- --metadata /data/image/meta.tar.xz --fstree /data/image/rootfs.tar.xz
