FROM microbox/chromium-builder

RUN echo 'SYSTEM LIMITS' && df -hT && free -h && nproc

ARG

RUN gclient config https://chromium.googlesource.com/chromium/src.git

RUN echo $CHROMIUM_VERSION

RUN git clone --branch ${CHROMIUM_VERSION} --depth=1 https://chromium.googlesource.com/chromium/src.git
RUN mkdir /root/chromium/cache

WORKDIR /root/chromium/src

RUN gclient sync -r ${CHROMIUM_VERSION} --no-history --shallow --no_bootstrap --deps=unix --cache-dir=/root/chromium/cache -v

RUN ./build/install-build-deps.sh --no-prompt

RUN mkdir -p out/headless \
    && echo 'import("/root/chromium/src/build/args/headless.gn")' > out/headless/args.gn \
    && echo 'is_debug = false' >> out/headless/args.gn \
    && echo 'use_jumbo_build=true' >> out/headless/args.gn \
    && echo 'remove_webcore_debug_symbols=true' >> out/headless/args.gn \
    && gn gen out/headless

