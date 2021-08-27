FROM alpine:edge

RUN apk add --no-cache gtk4.0-dev libgee-dev tracker-dev meson build-base git \
    gobject-introspection-dev rustup
RUN git clone https://gitlab.gnome.org/GNOME/libadwaita \
    && cd libadwaita \
    && meson -Dexamples=false -Dvapi=false build \
    && meson install -C build \
    && cd ..
RUN rustup-init -y \
    && source $HOME/.cargo/env \
    && rustup component add clippy \
    && rustup toolchain install nightly \
    && rustup component add llvm-tools-preview --toolchain nightly \
    && cargo install cargo-llvm-cov
