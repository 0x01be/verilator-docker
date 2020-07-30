FROM alpine:3.12.0 as builder

RUN apk --no-cache add --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
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

RUN git clone https://git.veripool.org/git/verilator /verilator

WORKDIR /verilator

RUN autoconf
RUN ./configure --prefix /opt/verilator/
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/verilator/ /opt/verilator/

ENV PATH $PATH:/opt/verilator/bin/

