FROM node:24.22.3-bookworm-slim

ARG DSH_VERSION=0.2.3-alpha.2
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/* \
    && npm install --global --no-audit --no-fund "@deepseek-ai/dsh@${DSH_VERSION}" \
    && mkdir -p /home/node/.dsh /workspace \
    && chown node:node /home/node/.dsh /workspace

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/dsh-container
USER node
ENV DSH_HOME=/home/node/.dsh
WORKDIR /workspace
EXPOSE 3080
ENTRYPOINT ["dsh-container"]
