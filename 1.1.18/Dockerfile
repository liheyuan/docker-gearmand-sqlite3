FROM alpine:3.7

ENV GEARMAND_VERSION 1.1.18
ENV GEARMAND_SHA1 eb7f1d806635cba309c40460c3ca5f2ff76d6519
ENV GEARMAND_DATA_DIR /var/lib/gearmand
ENV GEARMAND_USER gearman

RUN addgroup -S $GEARMAND_USER && adduser -G $GEARMAND_USER -S -D -H -s /bin/false -g "Gearman Server" $GEARMAND_USER

COPY patches/libhashkit-common.h.patch /libhashkit-common.h.patch
COPY patches/libtest-cmdline.cc.patch /libtest-cmdline.cc.patch

RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        wget \
        tar \
        ca-certificates \
        file \
        alpine-sdk \
        gperf \
        boost-dev \
        libevent-dev \
        util-linux-dev \
        hiredis-dev \
        libressl-dev \
        sqlite-dev \
    && wget -O gearmand.tar.gz "https://github.com/gearman/gearmand/releases/download/$GEARMAND_VERSION/gearmand-$GEARMAND_VERSION.tar.gz" \
    && echo "$GEARMAND_SHA1  gearmand.tar.gz" | sha1sum -c - \
    && mkdir -p /usr/src/gearmand \
    && tar -xzf gearmand.tar.gz -C /usr/src/gearmand --strip-components=1 \
    && rm gearmand.tar.gz \
    && cd /usr/src/gearmand \
    && patch -p1 < /libhashkit-common.h.patch \
    && patch -p1 < /libtest-cmdline.cc.patch \
    && ./configure \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --with-mysql=no \
        --with-postgresql=no \
        --with-sqlite3=yes \
        --disable-libpq \
        --disable-libtokyocabinet \
        --disable-libdrizzle \
        --disable-libmemcached \
        --enable-ssl \
        --enable-hiredis \
        --enable-jobserver=no \
    && make \
    && make install \
    && cd / && rm -rf /usr/src/gearmand \
    && rm /*.patch \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --virtual .gearmand-rundeps $runDeps \
    && apk del .build-deps \
    && /usr/local/sbin/gearmand --version


# Update fixed gearmand conf
COPY gearmand_fixed.conf /etc/gearmand.conf

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

# Data dir
RUN mkdir -p $GEARMAND_DATA_DIR
RUN chown -R $GEARMAND_USER:$GEARMAND_USER $GEARMAND_DATA_DIR
VOLUME $GEARMAND_DATA_DIR

USER gearman
EXPOSE 4730
CMD ["gearmand"]

