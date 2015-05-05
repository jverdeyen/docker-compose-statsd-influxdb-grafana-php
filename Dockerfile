FROM ubuntu:trusty
MAINTAINER Joeri Verdeyen <info@jverdeyen.be>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        git \
        apache2 \
        libapache2-mod-php5 &&\
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

ADD run.sh /run.sh
RUN chmod 755 /*.sh
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD app/ /app
WORKDIR /app
RUN composer install --no-dev --prefer-source
EXPOSE 80

CMD ["/run.sh"]