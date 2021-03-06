# FROM node:7.10.0
FROM openjdk:8-jdk

RUN \
      dpkg --add-architecture i386 && \
      apt-get update -q && \
      apt-get install -qy \
        sudo \
        libstdc++6:i386 \
        libgcc1:i386 \
        zlib1g:i386 \
        libncurses5:i386


# Setup Android SDK

ARG ANDROID_SDK_VERSION='24.0.1'
ENV ANDROID_SDK_FILENAME android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

WORKDIR /usr/local
RUN \
      wget http://dl.google.com/android/${ANDROID_SDK_FILENAME} && \
      tar -xzf $ANDROID_SDK_FILENAME && \
      rm $ANDROID_SDK_FILENAME && \
      chmod -R 0775 $ANDROID_HOME && \
      chown -R root:root $ANDROID_HOME && \
      echo "y" | android update sdk \
        --no-ui \
        --force \
        --all \
        --filter platform-tools,android-23,build-tools-23.0.1,extra-android-support,extra-android-m2repository,sys-img-x86_64-android-23,extra-google-m2repository && \
      mkdir -p $ANDROID_HOME/licenses


# Setup Node

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done

ARG NODE_VERSION='7.10.0'
ENV NPM_CONFIG_LOGLEVEL info
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

ARG YARN_VERSION='0.24.4'
RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done \
  && curl -fSL -o yarn.js "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-legacy-$YARN_VERSION.js" \
  && curl -fSL -o yarn.js.asc "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-legacy-$YARN_VERSION.js.asc" \
  && gpg --batch --verify yarn.js.asc yarn.js \
  && rm yarn.js.asc \
  && mv yarn.js /usr/local/bin/yarn \
  && chmod +x /usr/local/bin/yarn


# Setup React Native

RUN \
      npm install -g \
        react-native-cli


# Setup gcloud
ARG GCLOUD_SDK_VERSION='155.0.0'
ENV FILENAME google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz
ENV PATH /google-cloud-sdk/bin:$PATH
WORKDIR /
RUN \
      wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${FILENAME}" && \
      tar xf $FILENAME && \
      rm -rf $FILENAME && \
      gcloud components update && \
      # gcloud components install kubectl && \
      # gcloud components install beta && \
      gcloud version


# Execute

WORKDIR /src
COPY ./src .
CMD bash debug.sh
