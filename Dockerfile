FROM alpine:3.6
ENV CLOUD_SDK_VERSION=178.0.0
RUN apk --no-cache add ca-certificates \
    curl \
    git \
    openssl \
    php7 \
    php7-curl \
    php7-dom  \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-mbstring \
    php7-zlib \
    python2 \
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
    # && if [[ $ACTUAL_SIGNATURE != $EXPECTED_SIGNATURE ]]; then exit 1; fi \
    && php composer-setup.php \
    && rm composer-setup.php


    