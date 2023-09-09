ARG BASE_IMG
FROM ${BASE_IMG}

ARG NODE_VERSION=18.17.1

SHELL ["/bin/zsh", "-c"]

USER ${NB_UID}

# Node.js
RUN source $HOME/.zshrc \
    && asdf plugin add nodejs \
    && asdf install nodejs ${NODE_VERSION} \
    && asdf global nodejs ${NODE_VERSION} \
    && npm install -g yarn \
    && asdf reshim nodejs

# jupyter lab
COPY --chown=${NB_USER}:users requirements.txt /tmp
RUN source $HOME/.zshrc \
    && python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir \
    && rm -f /tmp/requirements.txt \
    && asdf reshim python \
    && jupyter lab --generate-config \
    && rm -rf ${HOME}/.cache/yarn \
    && chown -R ${NB_USER}:users ${HOME}

# s6 - copy scripts
COPY --chown=${NB_USER}:users --chmod=755 s6/ /etc

# s6 - 01-copy-tmp-home
USER root
RUN mkdir -p /tmp_home \
    && cp -r ${HOME} /tmp_home \
    && chown -R ${NB_USER}:users /tmp_home

USER ${NB_UID}

EXPOSE 8888

ENTRYPOINT ["/init"]