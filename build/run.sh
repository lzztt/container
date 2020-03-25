cat <<EOF | bash |& tee ~/build.log
bash prebuild.sh
bash mount.sh
bash download.sh
bash build_php.sh
bash build_nginx.sh
EOF
