FROM ubuntu:22.04
ARG KC_VER
ARG JRE_VER

RUN \
  # install packages
  apt-get -y update && \
  apt-get -y install curl unzip gettext-base openjdk-$JRE_VER-jre && \
  # download Keycloak distro from github.com
  cd /opt && \
  curl -sLO https://github.com/keycloak/keycloak/releases/download/$KC_VER/keycloak-$KC_VER.zip && \
  unzip -q keycloak-$KC_VER.zip \
  rm -f keycloak-$KC_VER/bin/*.bat \
  mkdir -p /opt/keycloak \
  cp -R keycloak-$KC_VER/* /opt/keycloak \
  rm -rf keycloak-$KC_VER/ keycloak-$KC_VER.zip \
