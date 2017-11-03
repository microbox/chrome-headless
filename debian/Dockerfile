FROM debian:stable-slim
MAINTAINER Ling <x@e2.to>
RUN apt-get update -y && apt-get install -y -q libnss3 libfontconfig && rm -rf /var/lib/apt/lists/*

ADD headless.tar.gz /chrome

EXPOSE 9222

ENTRYPOINT ["/chrome/headless_shell", "--no-sandbox", "--disable-gpu", "--hide-scrollbars", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222"]