FROM nginxinc/nginx-unprivileged

# implement changes required for Redash
RUN sed -i '1 i\upstream redash { \n  server redash:5000; \n}\n' /etc/nginx/conf.d/default.conf \
&& sed -i "/^[[:space:]]*server_name /a \ \n    gzip on;\n    gzip_types *;\n    gzip_proxied any; \n    proxy_buffer_size 8k;" /etc/nginx/conf.d/default.conf \
&& sed -i "/^[[:space:]]*location \/ {/a \        proxy_set_header Host \$http_host;\n        proxy_set_header X-Real-IP \$remote_addr;\n        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n        proxy_set_header X-Forwarded-Proto \$http_x_forwarded_proto;\n        proxy_pass       http://redash;\n" /etc/nginx/conf.d/default.conf \
&& sed -i 's,root   /usr/share/nginx/html;,#root   /usr/share/nginx/html;,' /etc/nginx/conf.d/default.conf \
&& sed -i 's,index  index.html index.htm;,#index  index.html index.htm;,' /etc/nginx/conf.d/default.conf 

    
