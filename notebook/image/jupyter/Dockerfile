FROM localhost/base

ARG NODE_VERSION=18.17.1
ARG PYTHON_VERSION=3.8.10

USER ${NB_UID}

SHELL ["/bin/zsh", "-c"]

RUN source $HOME/.zshrc \
    && asdf plugin add nodejs \
    && asdf install nodejs ${NODE_VERSION} \
    && asdf global nodejs ${NODE_VERSION} \
    && npm install -g yarn \
    && asdf reshim nodejs

RUN source $HOME/.zshrc \
    && asdf plugin add python \
    && asdf install python ${PYTHON_VERSION} \
    && asdf global python ${PYTHON_VERSION}

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
COPY --chown=${NB_USER}:users s6/ /etc

# s6 - 01-copy-tmp-home
USER root
RUN mkdir -p /tmp_home \
    && cp -r ${HOME} /tmp_home \
    && chown -R ${NB_USER}:users /tmp_home

USER ${NB_UID}

EXPOSE 8888

ENTRYPOINT ["/init"]