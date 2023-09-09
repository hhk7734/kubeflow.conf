ARG BASE_IMG
FROM ${BASE_IMG}

ARG CODESERVER_VERSION=4.16.1

SHELL ["/bin/zsh", "-c"]

USER root

# code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=${CODESERVER_VERSION} \
    && rm -f $HOME/.cache/code-server/*.deb \
    && chown -R ${NB_USER}:users ${HOME}

# s6 - copy scripts
COPY --chown=${NB_USER}:users s6/ /etc

# s6 - 01-copy-tmp-home
RUN mkdir -p /tmp_home \
    && cp -r ${HOME} /tmp_home \
    && chown -R ${NB_USER}:users /tmp_home

USER $NB_UID

EXPOSE 8888

ENTRYPOINT ["/init"]