set -e

SRC=/mnt/src
NGINX=nginx-1.21.6

wget -qO- https://nginx.org/download/$NGINX.tar.gz | tar -zx -C $SRC
cd $SRC/$NGINX
#grep 'nginx/' src/core/*
sed -i 's!nginx/!lzx/!' src/core/nginx.h
#grep 'Server: nginx' src/http/*
sed -i 's!Server: nginx!Server: lzx!' src/http/ngx_http_header_filter_module.c
#grep 'nginx' src/http/*
sed -i 's!<center>nginx</center>!<center>lzx</center>!' src/http/ngx_http_special_response.c
#grep 'nginx\[5\] = "\\x84\\xaa\\x63\\x55\\xe7"' src/http/v2/ngx_http_v2_filter_module.c
#    static const u_char nginx[5] = "\x84\xaa\x63\x55\xe7";
sed -i 's!nginx\[5\] = "\\x84\\xaa\\x63\\x55\\xe7"!nginx\[4\] = "\\x83\\xa3\\xdf\\x9f"!' src/http/v2/ngx_http_v2_filter_module.c
