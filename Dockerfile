# WEB cервер 1С 8.3
#
# https://geektimes.ru/post/268926/
FROM debian:jessie-slim
ENV DIST server64_8_3_20_1914

RUN apt-get update && apt-get install -y \
	apache2 \
	locales \
	wget \
	nano

RUN locale-gen ru_RU.UTF-8  
ENV LANG ru_RU.UTF-8 UTF-8  
ENV LANGUAGE ru_RU:ru  
ENV LC_ALL ru_RU.UTF-8 

ENV SITE_DIR /opt/web

ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV REUSESESSIONS dontuse

ENV SERVER_1C ""
ENV DB_1C ""

RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

RUN wget http://casa.ru/${DIST}.tar.gz -P /tmp --no-check-certificate | wc -l > /number
RUN tar xzf /tmp/${DIST}.tar.gz -C /tmp && \
	/tmp/setup-full-*-x86_64.run --mode unattended --enable-components ws,ru && \
	mkdir $SITE_DIR && chmod 777 $SITE_DIR && \
	mkdir -p /var/log/1c/dumps && chmod -R 777 /var/log/1c && \
	rm -rf /tmp/* && \
	rm -rf /var/lib/apt/lists/*

COPY run.sh /
COPY default.vrd $SITE_DIR

EXPOSE 80
CMD ["/run.sh"]
