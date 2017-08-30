rustup
======
Docker images for Rust using rustup.

Dockerfile
==========
If you want an image with different toolchains and targets from the one already
provided, you can build your own by just passing the proper build arguments.

- `RUSTUP_DEFAULT` is used as default toolchain when installing rustup.
- `RUSTUP_TOOLCHAINS` is a space separated list of `toolchain` names.
- `RUSTUP_TARGETS` is a space separated list of `toolchain:target` names.

Example
-------
This example builds an image with a `nightly` toolchain and a `musl` target.

```sh
docker build . \
  --build-arg RUSTUP_DEFAULT=nightly \
  --build-arg RUSTUP_TARGET="nightly:x86_64-unknown-linux-musl"
```

Images
======
The provided images are:

- `stable` for stable Rust
- `beta` for beta Rust
- `nightly` for nightly Rust
- `all` for stable, beta and nightly Rust

Updating
--------
Since the images are built when Rust is released the nightly image gets stale
pretty fast, in case you want the latest nightly you can pass
`RUSTUP_UPDATE=true` as a build argument when building your own image.

Example
-------
The following example creates an image using stable Rust.

```dockerfile
FROM 1aim/rustup:stable
```

```sh
docker build .
```

The following example creates an image using nightly Rust and makes sure to
update it.

```dockerfile
FROM 1aim/rustup:nightly
```

```sh
docker build . --build-arg RUSTUP_UPDATE=true
```
