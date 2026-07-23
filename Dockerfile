FROM codercom/code-server:4.129.0

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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

# Diretórios utilizados pelo mise.
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_DATA_DIR=/opt/mise
ENV MISE_CACHE_DIR=/opt/mise/cache

# Os shims permitem usar go, python, node etc. em shells interativos
# e também em processos não interativos.
ENV PATH="/opt/mise/shims:/usr/local/bin:${PATH}"

# Prepara os diretórios antes de instalar e concede acesso ao usuário coder.
RUN mkdir -p \
        /opt/mise/cache \
        /opt/mise/shims \
        /home/coder/.config/mise \
    && chown -R coder:coder \
        /opt/mise \
        /home/coder/.config

# Instala o binário globalmente.
RUN curl -fsSL https://mise.run | sh \
    && test -x /usr/local/bin/mise \
    && mise --version

# Sudo sem senha para tarefas administrativas no ambiente de desenvolvimento.
RUN printf '%s\n' \
        'coder ALL=(ALL) NOPASSWD:ALL' \
        > /etc/sudoers.d/coder \
    && chmod 0440 /etc/sudoers.d/coder

USER coder
WORKDIR /home/coder

# Confirma que o mise enxerga os diretórios configurados.
RUN mise doctor || true
