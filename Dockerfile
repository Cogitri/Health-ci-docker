FROM fedora:latest

RUN dnf install -y tracker3-devel gtk4-devel meson git xorg-x11-server-Xvfb \
    gobject-introspection-devel gcc gcc-c++
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup.sh \
    && sh ./rustup.sh -y \
    && rm rustup.sh
RUN git clone https://gitlab.gnome.org/GNOME/libadwaita \
    && cd libadwaita \
    && meson -Dexamples=false -Dvapi=false build \
    && meson install -C build \
    && cd .. \
    && rm -r libadwaita
RUN echo "/usr/local/lib64" > /etc/ld.so.conf.d/local.conf && ldconfig
RUN source $HOME/.cargo/env \
    && rustup component add clippy \
    && rustup toolchain install nightly \
    && rustup component add llvm-tools-preview --toolchain nightly \
    && cargo install cargo-llvm-cov
