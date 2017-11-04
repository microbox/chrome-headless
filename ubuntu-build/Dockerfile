ARG CHROMIUM_VERSION
FROM microbox/chromium-builder:headless-${CHROMIUM_VERSION}

RUN ninja -C out/headless headless_shell

RUN tar zcvf ../headless.tar.gz out/headless/headless_shell out/headless/*.pak
