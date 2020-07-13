FROM varnish:6.4 AS builder

# Adapted from https://knplabs.com/en/blog/how2tip-varnish-dynamic-backend-dns-resolution-in-a-docker-swarm-context
# Define env vars for VMOD build
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
ENV ACLOCAL_PATH /usr/local/share/aclocal
ENV VMOD_DYNAMIC_VERSION 2.2.1
RUN set -eux; \
        apt-get update && \
        apt-get upgrade -y && \
        apt-get install -y --no-install-recommends build-essential \
            autoconf \
            automake \
            libtool \
            make \
            pkgconf \
            python3 \
            python-docutils \
            wget \
            unzip \
            libgetdns-dev \
            varnish-dev=$VARNISH_VERSION \
        ;\
        wget "https://github.com/nigoroll/libvmod-dynamic/archive/v${VMOD_DYNAMIC_VERSION}.zip" -O /tmp/libvmod-dynamic.zip; \
        unzip -d /tmp /tmp/libvmod-dynamic.zip; \
        cd "/tmp/libvmod-dynamic-${VMOD_DYNAMIC_VERSION}"; \
        chmod +x ./autogen.sh; \
        ./autogen.sh; \
        ./configure --prefix=/usr; \
        make -j "$(nproc)"; \
        make install;

FROM varnish:6.4
COPY --from=builder /usr/lib/varnish/vmods/ /usr/lib/varnish/vmods/
RUN PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/sbin" ldconfig -n /usr/lib/varnish/vmods
