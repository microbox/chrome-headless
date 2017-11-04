#!/usr/bin/env bash

if [ -d "out/headless" ]; then

  # load pull docker image and run directly
  docker pull microbox/chromium-builder:headless-${VERSION}
  docker run -it microbox/chromium-builder:headless-${CHROMIUM_VERSION} /bin/bash
  docker build -t ubuntu-build --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-build
  export CID=$(docker create ubuntu-build)
  docker cp $CID:/root/chromium/headless.tar.gz debian
  docker build -t ${REPO}:${TAG} debian
  docker push ${REPO}
  rm -rf out/headless

else

  mkdir -p out
  docker build -t chromium-builder -t microbox/chromium-builder:headless-builder-${VERSION} --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-source
  docker push microbox/chromium-builder:headless-builder-${VERSION}
  export CBID=$(docker create chromium-builder)
  docker cp $CBID:/root/chromium/src/out/headless out

fi



