cat <<EOF | bash |& tee ~/build.log
bash prebuild.sh
bash mount.sh
bash download_php.sh
bash download_nginx.sh
bash build_php.sh
bash build_nginx.sh
EOF
