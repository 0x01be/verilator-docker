FROM alpine as build

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

ENV VERILATOR_REVISION master
RUN git clone --depth 1 --branch ${VERILATOR_REVISION} https://git.veripool.org/git/verilator /verilator

WORKDIR /verilator

RUN autoconf
RUN ./configure --prefix /opt/verilator/
RUN make
RUN make install

FROM alpine

COPY --from=build /opt/verilator/ /opt/verilator/

RUN apk --no-cache add --virtual verilator-runtime-dependencies \
    perl

RUN adduser -D -u 1000 verilator

WORKDIR /workspace

RUN chown verilator:verilator /workspace

USER verilator

ENV PATH $PATH:/opt/verilator/bin/

