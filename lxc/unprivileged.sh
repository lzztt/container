lxc-checkconfig
grep $USER /etc/sub{u,g}id

cp -r /etc/lxc .config/

cat <<EOF > ~/.config/lxc/default.conf
lxc.include = /etc/lxc/default.conf
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
lxc.apparmor.profile = unconfined
EOF

echo "$USER veth lxcbr0 10" | sudo tee -i /etc/lxc/lxc-usernet
