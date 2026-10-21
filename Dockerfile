FROM wordpress:7.1.3-php8.3-apache

# shortcut: official WordPress images still ship PHP 8.3.35; remove this rebuild once they include 8.3.36.
ENV PHP_VERSION=8.3.36 \
    PHP_URL=https://www.php.net/distributions/php-8.3.36.tar.xz \
    PHP_SHA256=dd54693aa334c5c4d72e9aee96b082c2473750a18a6c1d105789c93a3b1692fd

RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    configureOptions="$(php-config --configure-options)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends $PHPIZE_DEPS apache2-dev \
        libargon2-dev libcurl4-openssl-dev libonig-dev libreadline-dev \
        libsodium-dev libsqlite3-dev libssl-dev libxml2-dev zlib1g-dev; \
    curl -fsSL "$PHP_URL" -o /usr/src/php.tar.xz; \
    echo "$PHP_SHA256  /usr/src/php.tar.xz" | sha256sum -c -; \
    docker-php-source extract; \
    cd /usr/src/php; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"; \
    ./configure $configureOptions; \
    make -j2; \
    make install; \
    cd /; \
    docker-php-source delete; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/* /tmp/pear /usr/src/php.tar.xz.asc; \
    php -r 'if (PHP_VERSION !== "8.3.36") exit(1); foreach (["mysqli", "gd", "intl", "imagick", "zip", "sodium", "Zend OPcache"] as $extension) { if (!extension_loaded($extension)) throw new Exception($extension); }'; \
    apache2ctl -t

RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/e1b93919b8da39cbc3707f44bd2c61df3bd5b0d6/phar/wp-cli.phar -o /usr/local/bin/wp \
    && echo 'be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832  /usr/local/bin/wp' | sha512sum -c - \
    && chmod +x /usr/local/bin/wp \
    && wp --allow-root --info

COPY upgrade-wordpress.sh mpm-patch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/upgrade-wordpress.sh /usr/local/bin/mpm-patch.sh

ENTRYPOINT ["/usr/local/bin/mpm-patch.sh"]
CMD ["apache2-foreground"]
