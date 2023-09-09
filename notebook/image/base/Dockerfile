FROM ubuntu:20.04

ARG NB_USER=jovyan
ARG NB_PASSWD=jovyan
ARG S6_OVERLAY_ARCH="x86_64"
ARG S6_OVERLAY_VERSION=3.1.5.0
ARG FZF_VERSION=0.42.0
ARG ASDF_VERSION=v0.12.0
ARG PYTHON_VERSION=3.10.13

ENV NB_USER $NB_USER
ENV NB_PASSWD $NB_PASSWD
ENV NB_UID 1000
ENV NB_PREFIX /
ENV HOME /home/$NB_USER

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -yq update \
    && apt-get -yq install --no-install-recommends \
    xz-utils \
    ca-certificates \
    zsh \
    apt-transport-https \
    bzip2 \
    curl \
    git \
    locales \
    lsb-release \
    software-properties-common \
    tzdata \
    unzip \
    neovim \
    wget \
    zip \
    sudo \
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/zsh", "-c"]

# S6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz \
    && rm /tmp/s6-overlay-noarch.tar.xz \
    && rm /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

# USER
RUN useradd -M -s /bin/zsh -N -G sudo -u ${NB_UID} -p $(openssl passwd -1 $NB_PASSWD) ${NB_USER} \
    && mkdir -p ${HOME} \
    && chown -R ${NB_USER}:users ${HOME} \
    && chown -R ${NB_USER}:users /usr/local/bin \
    && chown -R ${NB_USER}:users /etc/s6-overlay

# LOCALE
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

USER $NB_UID

# OH-MY-ZSH
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# after oh-my-zsh
COPY --chown=${NB_USER}:users . $HOME/

RUN git clone https://github.com/zsh-users/zsh-completions.git \
    ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

RUN git clone --depth 1 --branch ${FZF_VERSION} https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install --key-bindings --completion --no-update-rc

# ASDF
RUN git clone --depth 1 --branch ${ASDF_VERSION} https://github.com/asdf-vm/asdf.git ~/.asdf

# PYTHON
RUN source $HOME/.zshrc \
    && asdf plugin add python \
    && asdf install python ${PYTHON_VERSION} \
    && asdf global python ${PYTHON_VERSION}