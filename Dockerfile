FROM debian:latest

MAINTAINER meh. <meh@1aim.com>

# Install packages.
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	ca-certificates curl file \
	build-essential pkg-config autoconf automake autotools-dev libtool \
	xutils-dev git openssh-client \
	openssl libssl-dev

ENV PATH=/root/.cargo/bin:$PATH

# Install default toolchain, or stable.
ARG DEFAULT=stable
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=$DEFAULT

ARG UPDATE=0
RUN if [ "x$UPDATE" = "x1" -o "x$UPDATE" = "xtrue" -o "x$UPDATE" = "xon" ]; then \
	rustup update; \
fi

# Install any additional toolchains.
ARG TOOLCHAINS
RUN for toolchain in $TOOLCHAINS; do \
	rustup update "$toolchain"; \
done

# Install any additional targets.
ARG TARGETS
RUN for target in $TARGETS; do \
	rustup target add "$(echo $target | cut -d':' -f2)" --toolchain "$(echo $target | cut -d':' -f1)"; \
done

# Clear huge aptitude cache.
RUN rm -rf /var/lib/apt/lists/*
