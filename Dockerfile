ARG STEAMAPPDIR="/root/hlds"

FROM debian:bookworm-slim AS build_stage
ARG STEAMAPPDIR

LABEL creator "Sergey Shorokhov <wopox1337@ya.ru>"

# Install, update & upgrade packages
RUN set -x  \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates curl \
    libarchive-tools \
    && rm -rf /var/lib/apt/lists/*ls

WORKDIR /root/
COPY --chmod=755 utils/* utils/

# Install ReHLDS
RUN releaseLink=$(utils/GetGithubReleaseUrl.sh "dreamstalker/rehlds" "latest") &&\
    mkdir -p $STEAMAPPDIR &&\
    curl -sSL $releaseLink | bsdtar -xf - --strip-components=2 --directory $STEAMAPPDIR bin/linux32/* &&\
    chmod +x \
        $STEAMAPPDIR/hlds_linux \
        $STEAMAPPDIR/hltv

RUN rm -rf utils


FROM wopox1337/hlds:steam-legacy AS run_stage
ARG STEAMAPPDIR

COPY --chmod=755 --from=build_stage ${STEAMAPPDIR} ${STEAMAPPDIR}
