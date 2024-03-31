ARG APPDIR="/root/hlds"

FROM debian:bookworm-slim AS build_stage
ARG APPDIR

LABEL creator="Sergey Shorokhov <wopox1337@ya.ru>"

# Install required packages
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       ca-certificates curl libarchive-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/
COPY --chmod=755 utils/* utils/

# Install ReHLDS
RUN releaseLink=$(utils/GetGithubReleaseUrl.sh "dreamstalker/rehlds" "latest") \
    && mkdir -p $APPDIR \
    && curl -L# $releaseLink | bsdtar -xf - --strip-components=2 --directory $APPDIR bin/linux32/* \
    && chmod +x $APPDIR/hlds_linux $APPDIR/hltv \
    && rm -rf utils


FROM wopox1337/hlds:steam_legacy AS run_stage
ARG APPDIR

COPY --chmod=755 --from=build_stage ${APPDIR} ${APPDIR}
