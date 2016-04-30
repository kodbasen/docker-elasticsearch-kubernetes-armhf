FROM kodbasen/java-jdk-armhf:jdk-8u91-b14

ENV VERSION=2.3.2 \
    K8S_PLUGIN_VERSION=2.3.1 \
    ES_JAVA_OPTS=-server

# Install Elasticsearch.
RUN apk add --update curl ca-certificates sudo \
  	&& curl -sSL https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${VERSION}/elasticsearch-${VERSION}.tar.gz | tar -xz \
  	&& mv /elasticsearch-${VERSION} /elasticsearch \
  	&& rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$|sigar/.*(dll|winnt|x86-linux|solaris|ia64|freebsd|macosx))") \
  	&& apk del curl \
    && mkdir -p /data/log

# Copy configuration
COPY config/logging.yml /elasticsearch/config

# Add configuration for plugin install
COPY config/es-plugin-install.yml /elasticsearch/config/elasticsearch.yml

# Install
#RUN /elasticsearch/bin/plugin install io.fabric8/elasticsearch-cloud-kubernetes/${K8S_PLUGIN_VERSION} --verbose
RUN /elasticsearch/bin/plugin install https://dl.dropboxusercontent.com/u/50924723/elasticsearch-cloud-kubernetes-2.3.2.zip

# Add config
COPY config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Copy run script
COPY run.sh /

CMD ["/run.sh"]
