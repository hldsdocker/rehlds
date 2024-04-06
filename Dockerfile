# syntax=docker/dockerfile:1

ARG MOD="valve"
ARG TAG="steam_legacy"

FROM debian:trixie-slim AS build_stage

LABEL creator="Sergey Shorokhov <wopox1337@ya.ru>"

# Install required packages
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       ca-certificates=20240203 \
       curl=8.5.0-2 \
       libarchive-tools=3.7.2-1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/bin/

ADD --chmod=755 https://raw.githubusercontent.com/hldsdocker/rehlds/master/utils/GetGithubReleaseUrl.sh GetGithubReleaseUrl

WORKDIR /root/hlds

# Install ReHLDS
RUN releaseLink=$(GetGithubReleaseUrl "dreamstalker/rehlds" "latest") \
    && curl -sSL $releaseLink | bsdtar -xf - --strip-components=2 bin/linux32/* \
    && chmod +x hlds_linux hltv

# Install ReGameDLL_CS
RUN releaseLink=$(GetGithubReleaseUrl "s1lentq/ReGameDLL_CS" "latest") \
    && curl -sSL $releaseLink | bsdtar -xf - --strip-components=2 bin/linux32/*

FROM hldsdocker/${MOD}:${TAG} AS run_stage

COPY --chown=${APPUSER}:${APPUSER} --chmod=755 --from=build_stage /root/hlds .
