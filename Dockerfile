FROM docker.io/tiredofit/nginx:alpine-3.14
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Environment Variables
ENV GRAFANA_VERSION=v8.1.4 \
    GRAFANA_SOURCE_REPO=https://github.com/grafana/grafana \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE
    
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .grafana-build-deps \
                g++ \
                gcc \
                git \
                go \
                jq \
                nodejs \
                npm \
                yarn \
                && \
    apk add -t .grafana-run-deps \
                chromium \
                ttf-opensans \
                udev \
                && \
    \
    git clone ${GRAFANA_SOURCE_REPO} /usr/src/grafana && \
    git -C /usr/src/grafana checkout ${GRAFANA_VERSION} && \
    \
    cd /usr/src/grafana && \
    yarn install --pure-lockfile --no-progress && \
    NODE_ENV=production yarn build && \
    go mod verify && \
    go run build.go build && \
    \
    addgroup -g 472 grafana && \
    adduser -S -D -H -h /usr/share/grafana -s /sbin/nologin -G grafana -u 472 grafana && \
    cp -R /usr/src/grafana/bin/*/grafana-server /usr/sbin && \
    cp -R /usr/src/grafana/bin/*/grafana-cli /usr/sbin && \
    mkdir -p /usr/share/grafana  && \
    cp -R /usr/src/grafana/public /usr/share/grafana && \
    cp -R /usr/src/grafana/tools /usr/share/grafana && \
    chown -R grafana:grafana /usr/share/grafana && \
    mkdir -p /assets/grafana && \
    cp -R /usr/src/grafana/conf /usr/share/grafana && \
    chown -R grafana:grafana /usr/share/grafana && \
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
    apk del .grafana-build-deps && \
    rm -rf /usr/src/* && \
    rm -rf /root/.config /root/.cache /root/.go && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

## Networking
EXPOSE 3000

#### Add Files
ADD install /
