#!/usr/bin/env bash

if [ -d "out/headless" ]; then

  # load pull docker image and run directly
  docker pull microbox/chromium-builder:headless-${VERSION}
  docker run -it microbox/chromium-builder:headless-${CHROMIUM_VERSION} -v out:/root/chromium/src/out timeout 40m ninja -C out/headless headless_shell

  if [ -e "out/headless/headless_shell" ]; then

    tar zcvf debian/headless.tar.gz out/headless/headless_shell out/headless/*.pak
    docker build -t ${REPO}:${TAG} debian
    docker push ${REPO}
    rm -rf out/headless
  else

    ls -ahl out/headless
    du -h -d 1 out/headless

  fi;

else

  mkdir -p out
  docker build -t chromium-builder -t microbox/chromium-builder:headless-builder-${VERSION} --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-source
  docker push microbox/chromium-builder:headless-builder-${VERSION}
  export CBID=$(docker create chromium-builder)
  docker cp $CBID:/root/chromium/src/out/headless out

fi



