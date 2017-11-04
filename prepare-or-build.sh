#!/usr/bin/env bash

if [ -d "out/headless" ]; then

  # load pull docker image and run directly
  docker pull microbox/chromium-builder:headless-${VERSION}
  docker build -t ubuntu-build --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-build
  export CID=$(docker create ubuntu-build)
  docker cp $CID:/root/chromium/headless.tar.gz debian
  docker build -t ${REPO}:${TAG} debian
  docker push ${REPO}
  rm -rf out/headless

else

  mkdir -p out
  docker build -t microbox/chromium-builder:headless-${VERSION} -v out:/root/chromium/src/out --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-source
  docker push microbox/chromium-builder:headless-${VERSION}

fi



