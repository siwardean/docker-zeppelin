FROM gettyimages/spark:2.4.0-hadoop-3.0
# SciPy
RUN set -ex \
 && buildDeps=' \
    libpython3-dev \
    build-essential \
    pkg-config \
    gfortran \
 ' \
 && apt-get update && apt-get install -y --no-install-recommends \
    $buildDeps \
    ca-certificates \
    wget \
    liblapack-dev \
    libopenblas-dev \
 && packages=' \
    numpy \
    pandasql \
    scipy \
 ' \
 && pip3 install $packages \
 && rm -rf /root/.cache/pip \
 && apt-get purge -y --auto-remove $buildDeps \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Zeppelin
ENV ZEPPELIN_PORT 8080
#ENV ZEPPELIN_SSL_PORT 8443
ENV ZEPPELIN_HOME /usr/zeppelin
ENV ZEPPELIN_CONF_DIR $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook
ENV ZEPPELIN_COMMIT v0.8.2
#EXPOSE $ZEPPELIN_PORT $ZEPPELIN_SSL_PORT 8443
#EXPOSE 4040
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN set -ex \
 && buildDeps=' \
    git \
    bzip2 \
    nodejs \
    npm \
    openjdk-8-jdk \
 ' \
 && apt-get update \
 && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
 && apt-get install -y --no-install-recommends $buildDeps \
 && curl -sL http://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
   | gunzip \
   | tar x -C /tmp/ \
 && git clone https://github.com/apache/zeppelin.git /usr/src/zeppelin \
 && cd /usr/src/zeppelin \
 && git checkout -q $ZEPPELIN_COMMIT \
 && npm install -g bower  \
 && cd zeppelin-web \
 && bower install --config.interactive=false --allow-root --silent \
 && cd .. \
 && dev/change_scala_version.sh "2.11" \
 && MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m" /tmp/apache-maven-3.6.3/bin/mvn --batch-mode package -DskipTests -Pscala-2.11 -Pbuild-distr \
  -pl 'zeppelin-interpreter,zeppelin-zengine,zeppelin-display,spark,markdown,angular,shell,hbase,jdbc,python,elasticsearch,zeppelin-web,zeppelin-server,zeppelin-distribution' \
 && tar xvf /usr/src/zeppelin/zeppelin-distribution/target/zeppelin*.tar.gz -C /usr/ \
 && mv /usr/zeppelin* $ZEPPELIN_HOME \
 && mkdir -p $ZEPPELIN_HOME/logs \
 && mkdir -p $ZEPPELIN_HOME/run \
 && apt-get purge -y --auto-remove $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/src/zeppelin \
 && rm -rf /root/.m2 \
 && rm -rf /root/.npm \
 && rm -rf /root/.cache/bower \
 && rm -rf /tmp/*

RUN ln -s /usr/bin/pip3 /usr/bin/pip \
 && ln -s /usr/bin/python3 /usr/bin/python

ADD about.json $ZEPPELIN_NOTEBOOK_DIR/2BTRWA9EV/note.json
WORKDIR $ZEPPELIN_HOME
CMD ["bin/zeppelin-daemon.sh start"]

