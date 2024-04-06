# syntax=docker/dockerfile:1

ARG MOD="valve"
ARG TAG="steam_legacy"
ARG ReHLDS_VERSION="latest"
ARG ReGameDLL_VERSION="latest"
ARG BugfixedHL_LINK="https://github.com/tmp64/BugfixedHL-Rebased/releases/download/v1.10.4/BugfixedHL-1.10.4-server.zip"

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

ARG ReHLDS_VERSION

# Install ReHLDS
RUN releaseLink=$(GetGithubReleaseUrl "dreamstalker/rehlds" ${ReHLDS_VERSION}) \
    && curl -sSL $releaseLink | bsdtar -xf - --strip-components=2 bin/linux32/* \
    && chmod +x hlds_linux hltv

SHELL [ "/bin/bash", "-c" ]

ARG MOD

# Install BugfixedHL-Rebased
RUN if [ "${MOD}" = "valve" ] && [ "${BugfixedHL_LINK}" -n "" ]; then \
        releaseLink=${BugfixedHL_LINK} \
        && curl -sSL $releaseLink | bsdtar -xf - -C ${MOD}/ --strip-components=2 --exclude='*.dll' --exclude='*.pdb' BugfixedHL*server/valve_addon/dlls/*; \
    fi

ARG ReGameDLL_VERSION
# Install ReGameDLL_CS
RUN if [ "${MOD}" = "cstrike" ] || [ "${MOD}" = "czero" ]; then \
        releaseLink=$(GetGithubReleaseUrl "s1lentq/ReGameDLL_CS" ${ReGameDLL_VERSION}) \
        && curl -sSL $releaseLink | bsdtar -xf - --strip-components=2 bin/linux32/*; \
        if [ "${MOD}" = "czero" ]; then \
            mv cstrike czero ; \
        fi \
    fi

FROM hldsdocker/${MOD}:${TAG} AS run_stage

COPY --chown=${APPUSER}:${APPUSER} --chmod=755 --from=build_stage /root/hlds .

ARG BugfixedHL_LINK

# Hotfix for server startup on BugfixedHL-Rebased
RUN if [ "${MOD}" = "valve" ] && [ "${#BugfixedHL_LINK}" -gt 0 ]; then \
        && rm -rf libstdc++.so.6 libgcc_s.so.1 ; \
    fi
