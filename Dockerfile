FROM registry.dataos.io/datafoundry/ubuntu:14.04
MAINTAINER sinkcup <sinkcup@163.com>

ENV TIME_ZONE=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y supervisor git wget curl nginx php5-fpm php5-gd php5-cli php5-curl
RUN sed -i "s|gzip  on;|gzip  on; etag  off; server_tokens off; gzip_types text/css application/x-javascript;|" /etc/nginx/nginx.conf
RUN cd /usr/share/nginx/html && \
  git clone https://github.com/getgrav/grav.git
RUN cd /usr/share/nginx/html/grav && \
  /usr/bin/php bin/grav install
RUN rm -fR /usr/share/nginx/html/grav/user 
RUN git clone https://github.com/asiainfoLDP/datahub_documents.git /usr/share/nginx/html/grav/user
RUN cd /usr/share/nginx/html/grav && \
  chown -R www-data:www-data cache/ logs/ images/ assets/ user/ backup/ && \
  rm -f /etc/nginx/sites-enabled/*

COPY nginx/sites-available/ /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/grav.conf /etc/nginx/sites-enabled/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /usr/share/nginx/html/grav/

EXPOSE 80

CMD ["/usr/bin/supervisord"]
