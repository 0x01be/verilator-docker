FROM 0x01be/alpine:edge as builder

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

RUN git clone https://git.veripool.org/git/verilator /verilator

WORKDIR /verilator

RUN autoconf
RUN ./configure --prefix /opt/verilator/
RUN make
RUN make install

FROM 0x01be/alpine:edge

COPY --from=builder /opt/verilator/ /opt/verilator/

ENV PATH $PATH:/opt/verilator/bin/

