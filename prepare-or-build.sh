#!/usr/bin/env bash

if [ -d "out/headless" ]; then

  ls -ahl out/headless
  du -h -d 1 out/headless

  # load pull docker image and run directly
  docker pull microbox/chromium-builder:headless-builder-${VERSION}
  docker run -it microbox/chromium-builder:headless-builder-${CHROMIUM_VERSION} -v out:/root/chromium/src/out timeout 40m ninja -C out/headless headless_shell

  ls -ahl out/headless
  du -h -d 1 out/headless

  if [ -e "out/headless/headless_shell" ]; then

    cd out/headless
    tar zcvf ../../debian/headless.tar.gz headless_shell *.pak
    cd ../../
    docker build -t ${REPO}:${TAG} debian
    docker push ${REPO}
    rm -rf out/headless

  fi;

else

  mkdir -p out
  docker build -t chromium-builder -t microbox/chromium-builder:headless-builder-${VERSION} --build-arg CHROMIUM_VERSION=${VERSION} ubuntu-builder
  docker push microbox/chromium-builder:headless-builder-${VERSION}
  export CBID=$(docker create chromium-builder)
  docker cp $CBID:/root/chromium/src/out/headless out

fi



