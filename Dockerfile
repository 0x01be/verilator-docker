FROM alpine as builder

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
    numactl-dev

RUN git clone --depth 1 https://git.veripool.org/git/verilator /verilator

WORKDIR /verilator

RUN autoconf
RUN ./configure --prefix /opt/verilator/
RUN make
RUN make install

FROM alpine

COPY --from=builder /opt/verilator/ /opt/verilator/

RUN apk --no-cache add --virtual verilator-runtime-dependencies \
    perl

ENV PATH $PATH:/opt/verilator/bin/

WORKDIR /workspace

