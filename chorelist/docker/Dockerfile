FROM ruby:3.0.2

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null &&\
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install -y yarn

RUN mkdir -p /opt/config
COPY run-server-in-docker.sh /opt/config/run-server-in-docker.sh

ENV RAILS_ENV production
ENV INSTALL_PATH /opt/app
ENV RAILS_SERVE_STATIC_FILES true
RUN mkdir -p ${INSTALL_PATH}
WORKDIR /opt/app

#CMD ["/bin/sh"]
CMD ["/opt/config/run-server-in-docker.sh"]
