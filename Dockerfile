ARG NODE_VERSION="16-bullseye"
ARG OPENJDK_VERSION="11-bullseye"
FROM node:$NODE_VERSION as node
FROM openjdk:$OPENJDK_VERSION

ARG GRAPHVIZ_VERSION="2.42.2-5"
RUN apt-get update && apt-get dist-upgrade -y \
 && apt-get install -y graphviz=$GRAPHVIZ_VERSION build-essential git

ARG PLANTUML_VERSION="1.2021.14"
RUN downloadDir=$(xdg-user-dir DOWNLOAD) \
 && wget -O $downloadDir/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v$PLANTUML_VERSION/plantuml-$PLANTUML_VERSION.jar \
 && echo '#!/bin/bash\njava -Dfile.encoding=UTF-8 -Dhttps.proxyHost=proxy.tcsbank.ru -Dhttps.proxyPort=8080 -jar $(xdg-user-dir DOWNLOAD)/plantuml.jar $@' > /usr/local/bin/plantuml \
 && chmod +x /usr/local/bin/plantuml

ARG NODE_VERSION="14-bullseye"

ENV NODE_PATH /usr/local/lib/node_modules

COPY --from=node /usr/local/bin /usr/local/bin
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /opt /opt

WORKDIR /app

CMD ["/bin/bash"]