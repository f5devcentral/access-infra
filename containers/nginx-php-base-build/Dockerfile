FROM alpine:latest

RUN apk update 
RUN apk add nginx 
RUN adduser -D -u 1000 -g 'www' www 
RUN mkdir /www 
RUN chown -R www:www /var/lib/nginx 
RUN chown -R www:www /www 
RUN rm -rf /etc/nginx/nginx.conf

ENV PHP_FPM_USER="www"
ENV PHP_FPM_GROUP="www"
ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0
ENV PHP_VARIABLES_ORDER="EGPCS"
ENV TIMEZONE="America/Los_Angeles"

RUN apk add curl \
    tzdata \
    php-fpm \
    php-soap \
    php-openssl \
    php-gmp \
    php-pdo_odbc \
    php-json \
    php-dom \
    php-pdo \
    php-zip \
    php-mysqli \
    php-sqlite3 \
    php-pdo_pgsql \
    php-bcmath \
    php-gd \
    php-odbc \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-gettext \
    php-xmlreader \
    php-xmlrpc \
    php-bz2 \
    php-iconv \
    php-pdo_dblib \
    php-curl \
    php-ctype

RUN sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf 
RUN sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf 
RUN sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.conf 
RUN sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.conf 
RUN sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.conf 
RUN sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.conf 
RUN sed -i 's/include\ \=\ \/etc\/php\/fpm.d\/\*.conf/\;include\ \=\ \/etc\/php\/fpm.d\/\*.conf/g' /etc/php7/php-fpm.conf

RUN sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini 
RUN sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini 
RUN sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini 
RUN sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini 
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini 
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini 
RUN sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini 
RUN sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
RUN sed -i "s|variables_order = \"GPCS\"|variables_order = '${PHP_VARIABLES_ORDER}'|i" /etc/php7/php.ini

RUN rm -rf /etc/localtime 
RUN ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime 
RUN echo "${TIMEZONE}" > /etc/timezone 
RUN sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini  

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./html /www
COPY ./start_nginx.sh /start_nginx.sh
COPY ./start_php-fpm.sh /start_php-fpm.sh
COPY ./wrapper.sh /wrapper.sh

RUN chmod +x /start_nginx.sh /start_php-fpm.sh /wrapper.sh

CMD ["/wrapper.sh"]