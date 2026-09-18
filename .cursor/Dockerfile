FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# php-cli provides the built-in web server used for local development.
# ffmpeg is used by the dev-setup script to generate small sample .webm
# videos so the site has playable media locally (real videos are supplied
# in production and are intentionally git-ignored).
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        php-cli \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

USER ubuntu
