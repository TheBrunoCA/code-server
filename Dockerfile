FROM codercom/code-server:4.121.0

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
        make \
        jq \
        ripgrep \
        fd-find \
        tree \
        htop \
        tmux \
        sudo \
        python3 \
        python3-pip \
        python3-venv \
        golang-go \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo "coder ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/coder

USER coder
