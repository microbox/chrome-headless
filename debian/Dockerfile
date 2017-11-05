FROM debian:stable-slim

MAINTAINER Ling <x@e2.to>

RUN apt-get update -y && apt-get install -y -q libnss3 libfontconfig && rm -rf /var/lib/apt/lists/* \
    && groupadd -g 1000 chromium \
    && useradd -u 1000 -g chromium -G audio,video -d /home/chromium -m -s /bin/bash chromium \
    && mkdir -p /usr/lib/chromium /etc/chromium \
    && mkdir -p /home/chromium/.config/chromium-headless \
    && chown -R chromium:chromium /home/chromium

WORKDIR /usr/lib/chromium
ADD headless.tar.gz .
ADD chromium-launcher.sh .
COPY locales ./locales
ADD chromium.conf /etc/chromium
RUN ln -s /usr/lib/chromium/chromium-launcher.sh /bin/chromium

WORKDIR /root
ENV HOME=/root
USER root

EXPOSE 9222

ENTRYPOINT ["chromium"]
