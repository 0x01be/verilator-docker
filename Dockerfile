FROM 0x01be/base as build

ENV REVISION=master
WORKDIR /verilator
RUN apk --no-cache add --virtual verilator-build-dependencies \
    build-base \
    autoconf \
    git \
    python3 \
    flex \
    bison \
    perl \
    flex-dev \
    zlib-dev \
    ccache \
    numactl-dev &&\
    git clone --depth 1 --branch ${REVISION} https://git.veripool.org/git/verilator /verilator &&\
    autoconf &&\
    ./configure --prefix /opt/verilator/ &&\
    make
RUN make install

FROM 0x01be/base

COPY --from=build /opt/verilator/ /opt/verilator/

WORKDIR /workspace

RUN apk --no-cache add --virtual verilator-runtime-dependencies \
    perl &&\
    adduser -D -u 1000 verilator &&\
    chown verilator:verilator /workspace

USER verilator
ENV PATH=${PATH}:/opt/verilator/bin/

