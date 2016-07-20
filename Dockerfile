# pgmyadmin
#
# VERSION               0.0.1

FROM      gendosu/alpine-base

MAINTAINER Gen Takahashi <gendosu@gmail.com>

# this config Unimplemented
#ENV APACHE_PORT=80

ENV PG_HOST=localhost

RUN apk add --update \
    apache2 \
    apache2-utils \

    php5 \
    php5-apache2 \
    php5-pgsql \
&&  rm -rf /var/cache/apk/*

RUN mkdir /run/apache2 \
&&  sed -i 's#^DocumentRoot .*#DocumentRoot "/var/www/phpPgAdmin-5.1"#g' /etc/apache2/httpd.conf \
&&  sed -i 's#^<Directory "/var/www/localhost/htdocs">.*#<Directory "/var/www/phpPgAdmin-5.1">#g' /etc/apache2/httpd.conf

ADD etc /etc

workdir /var/www
#ADD phpPgAdmin-5.1.zip /var/www
#RUN unzip phpPgAdmin-5.1.zip
RUN git clone git://github.com/phppgadmin/phppgadmin.git phpPgAdmin-5.1 \
&&  chown -R apache:apache phpPgAdmin-5.1 \
&&  mv /var/www/phpPgAdmin-5.1/conf/config.inc.php-dist /var/www/phpPgAdmin-5.1/conf/config.inc.php \
&&  sed -i "s#^$conf['servers'][0]['host'] = '';#$conf['servers'][0]['host'] = '$PG_HOST';#g" /etc/apache2/httpd.conf

CMD /usr/sbin/httpd -DFOREGROUND

