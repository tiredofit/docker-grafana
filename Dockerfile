FROM docker.io/tiredofit/nginx:alpine-3.16
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Environment Variables
ENV GRAFANA_VERSION=v9.0.4 \
    GRAFANA_SOURCE_REPO=https://github.com/grafana/grafana \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=grafana \
    IMAGE_NAME="tiredofit/grafana" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-grafana/"
    
RUN set -x && \
    apk update && \
    apk upgrade && \
    \
    addgroup -g 472 grafana && \
    adduser -S -D -H -h /usr/share/grafana -s /sbin/nologin -G grafana -u 472 grafana && \
    \
    apk add -t .grafana-run-deps \
                chromium \
                libc6-compat \
                ttf-opensans \
                udev \
                && \
    \
    mkdir -p /usr/src/grafana && \
    curl -sSL https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION/v/}.linux-amd64.tar.gz | tar xfz - --strip 1 -C /usr/src/grafana && \
    cd /usr/src/grafana && \
    cp -R /usr/src/grafana/bin/grafana-server /usr/sbin && \
    cp -R /usr/src/grafana/bin/grafana-cli /usr/sbin && \
    mkdir -p /usr/share/grafana  && \
    cp -R /usr/src/grafana/public /usr/share/grafana && \
    cp -R /usr/src/grafana/conf /usr/share/grafana && \
    cp -R /usr/src/grafana/plugins-bundled /usr/share/grafana && \
    chown -R grafana:grafana /usr/share/grafana && \
    mkdir -p /assets/grafana && \
    \
    #mkdir -p /assets/grafana/plugins && \
    #/usr/sbin/grafana-cli --pluginUrl https://github.com/grafana/grafana-image-renderer/releases/latest/download/plugin-linux-x64-glibc-no-chromium.zip --pluginsDir "/assets/grafana/plugins" plugins install grafana-image-renderer && \
    #for plugin in $( curl -s https://grafana.net/api/plugins?orderBy=name | jq '.items[] | select(.internal == false) | select(.status == "active") | .slug' | tr -d '"'); do \
       #if [ ${plugin} = "grafana-image-renderer" ] ; then \
          #/usr/sbin/grafana-cli --pluginUrl https://github.com/grafana/grafana-image-renderer/releases/latest/download/plugin-linux-x64-glibc-no-chromium.zip --pluginsDir "/assets/grafana/plugins" plugins install $plugin ; \
        #else \
          #/usr/sbin/grafana-cli --pluginsDir "/assets/grafana/plugins" plugins install $plugin; fi; \
    #done ; \
    #chown -R grafana:grafana /assets/grafana/plugins && \
    \
    rm -rf /usr/src/* && \
    #rm -rf /root/.config /root/.cache /root/.go && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

## Networking
EXPOSE 3000

#### Add Files
ADD install /
