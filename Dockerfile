ARG DISTRO="alpine"
ARG DISTRO_VARIANT="3.18"

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG GRAFANA_VERSION

ENV GRAFANA_VERSION=${GRAFANA_VERSION:-v10.2.0} \
    GRAFANA_SOURCE_REPO=https://github.com/grafana/grafana \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED=grafana \
    IMAGE_NAME="tiredofit/grafana" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-grafana/"

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    \
    addgroup -g 472 grafana && \
    adduser -S -D -H -h /usr/share/grafana -s /sbin/nologin -G grafana -u 472 grafana && \
    \
    package install .grafana-run-deps \
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
    cp -R /usr/src/grafana/bin/grafana /usr/sbin && \
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
    package cleanup && \
    rm -rf /usr/src/ \
           /root/.cache \
           /root/.config \
           /root/.go \
           /tmp/*

EXPOSE 3000

COPY install /
