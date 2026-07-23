FROM codercom/code-server:4.129.0

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        build-essential \
        ca-certificates \
        curl \
        git \
        pkg-config \
        sudo \
        unzip \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/*

# Configuração global do mise
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_DATA_DIR=/opt/mise
ENV MISE_CACHE_DIR=/opt/mise/cache
ENV PATH=/opt/mise/shims:/usr/lib/code-server/lib/vscode/bin/remote-cli:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# Cria os diretórios antes da instalação
RUN mkdir -p \
        /opt/mise/cache \
        /opt/mise/shims \
        /home/coder/.config/mise \
    && chown -R coder:coder \
        /opt/mise \
        /home/coder/.config

# Instala o mise globalmente
RUN curl -fsSL https://mise.run | sh \
    && test -x /usr/local/bin/mise \
    && /usr/local/bin/mise --version

# Garante o PATH em shells login
RUN printf '%s\n' \
        'export MISE_DATA_DIR=/opt/mise' \
        'export MISE_CACHE_DIR=/opt/mise/cache' \
        'export PATH="/opt/mise/shims:$PATH"' \
        > /etc/profile.d/mise.sh \
    && chmod 0644 /etc/profile.d/mise.sh

# Garante o PATH também no bash interativo usado pelo terminal do code-server
RUN printf '%s\n' \
        '' \
        '# mise' \
        'export MISE_DATA_DIR=/opt/mise' \
        'export MISE_CACHE_DIR=/opt/mise/cache' \
        'export PATH="/opt/mise/shims:$PATH"' \
        >> /etc/bash.bashrc

# Sudo sem senha
RUN printf '%s\n' \
        'coder ALL=(ALL) NOPASSWD:ALL' \
        > /etc/sudoers.d/coder \
    && chmod 0440 /etc/sudoers.d/coder

USER coder
WORKDIR /home/coder
