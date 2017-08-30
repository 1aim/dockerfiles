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
ARG RUSTUP_DEFAULT=stable
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=$RUSTUP_DEFAULT

# Install any additional toolchains.
ARG RUSTUP_TOOLCHAINS
RUN for toolchain in $RUSTUP_TOOLCHAINS; do \
	rustup update "$toolchain"; \
done

# Install any additional targets.
ARG RUSTUP_TARGETS
RUN for target in $RUSTUP_TARGETS; do \
	rustup target add "$(echo $target | cut -d':' -f2)" --toolchain "$(echo $target | cut -d':' -f1)"; \
done

ARG RUSTUP_DEPENDENCIES
RUN if [ -n "$RUSTUP_DEPENDENCIES" ]; then \
	apt-get install --no-install-recommends -y $RUSTUP_DEPENDENCIES; \
fi

ONBUILD ARG RUSTUP_UPDATE
ONBUILD RUN if [ "x$RUSTUP_UPDATE" = "x1" -o "x$RUSTUP_UPDATE" = "xtrue" -o "x$RUSTUP_UPDATE" = "xon" ]; then \
	rustup update; \
fi

# Clear huge aptitude cache.
RUN rm -rf /var/lib/apt/lists/*
