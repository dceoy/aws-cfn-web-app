FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
ADD main.py /tmp/main.py

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates curl locales python3-dev python3-distutils \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && locale-gen en_US.UTF-8 \
      && update-locale

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py install -U --no-cache-dir pip \
      && /usr/local/bin/pip install -U --no-cache-dir fastapi[all]

ENV PYTHONPATH /opt/api

RUN set -e \
      && mkdir -p "${PYTHONPATH}" \
      && mv /tmp/main.py "${PYTHONPATH}"

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/uvicorn"]
CMD ["main:app", "--port=8080", "--host=0.0.0.0", "--reload"]
