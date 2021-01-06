FROM python:3.9-slim

RUN groupadd -r app \
  && useradd --no-log-init -m -g app app \
  && chown app /usr/src

USER app
WORKDIR /usr/src
