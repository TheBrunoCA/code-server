FROM codercom/code-server:4.129.0

USER root

RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        wget \
        unzip \
        zip \
        build-essential \
        pkg-config \
        ca-certificates \
        sudo \
        bash \
    && rm -rf /var/lib/apt/lists/*

# Instala o mise em um local global
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_DATA_DIR=/opt/mise
ENV MISE_CACHE_DIR=/opt/mise/cache
ENV PATH="/opt/mise/shims:/usr/local/bin:${PATH}"

RUN curl https://mise.run | sh

# Permite sudo sem senha para o usuário coder
RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/coder

# Dá acesso ao diretório do mise
RUN mkdir -p /opt/mise && \
    chown -R 1000:1000 /opt/mise

USER coder

RUN echo 'eval "$(mise activate bash)"' >> /home/coder/.bashrc
