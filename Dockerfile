FROM alpine:3.3
MAINTAINER Manny Toledo

# This docker file was derived from this post 
# http://pgarbe.github.io/blog/2015/03/24/how-to-run-hubot-in-docker-on-aws-ec2-container-services-part-1/

# Upgrade base system libraries, add proper utilities and replacements for featureless busybox binaries
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add \
        bash \
        libcap \
        sed \
        grep \
        vim \
        openssl \
        redis \
        nodejs \
    && \
    rm -rf /var/cache/apk/*

RUN apk update && \
    apk add \
        supervisor \
    && \
    rm -rf /var/cache/apk/*

RUN npm install -g coffee-script yo generator-hubot

# Create an unprivelaged user
RUN mkdir /hubot; adduser -D -S -h "/hubot" hubot

USER hubot
WORKDIR /hubot

# install hubot
RUN yo hubot --owner="You" --name="Hubot" --description="HuBot on Docker" --defaults

# Some adapters / scripts
RUN npm install hubot-telegram --install && npm install \
    npm install hubot-standup-alarm --save && npm install \
    npm install hubot-thank-you --save && npm install \
    npm install hubot-google-images --save && npm install \
    npm install hubot-google-translate --save && npm install \
    npm install hubot-auth --save && npm install \
    npm install hubot-pugme --save && npm install \
    npm install hubot-maps --save && npm install \
    npm install hubot-alias --save && npm install \
    npm install hubot-youtube --save && npm install \
    npm install hubot-s3-brain --save && npm instal

ADD hubot-scripts.json /hubot/

# RUN npm install hubot-standup-alarm --save && npm install
ADD external-scripts.json /hubot/

# ADD scripts/hubot-leitwerk.coffee /hubot/scripts/
RUN npm install hubot-telegram --save && npm install

CMD ["/bin/sh", "-c", "bin/hubot --adapter telegram"]
