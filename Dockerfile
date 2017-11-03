FROM python:2-alpine
ENV CLOUD_SDK_VERSION=178.0.0
RUN apk --no-cache add ca-certificates \
    curl \
    git \
    openssl \
    php \
    php-curl \
    php-dom  \
    php-json \
    php-openssl \
    php-phar \
    wget \
    && mkdir -p /etc/ssl/certs \
    && update-ca-certificates --fresh \
    && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz \
    && tar -xzvf google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz \
    && chmod +x ./google-cloud-sdk/install.sh \
    && ./google-cloud-sdk/install.sh \
    && rm google-cloud-sdk-$CLOUD_SDK_VERSION-linux-x86_64.tar.gz \
    && /google-cloud-sdk/bin/gcloud components install app-engine-php \
    && export EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && export ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") \
    && if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then exit 1; fi \                                           \
    && php composer-setup.php \
    && rm composer-setup.php  \
    && mv composer.phar /usr/bin/composer
    