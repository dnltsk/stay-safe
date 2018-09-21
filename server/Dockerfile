#
# Dockerimage containig Python3, Pip3 + Script dependencies to guarantee a valid execition environment
#
# further documentation in README.md
#
FROM alpine:3.8

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    apk add make automake gcc g++ subversion python3-dev && \
    apk add sqlite socat && \
    rm -r /root/.cache

RUN mkdir /app
COPY stay_safe/ /app

RUN pip install --default-timeout=100 -r app/requirements.txt

WORKDIR /app
ENTRYPOINT ["python", "Main.py"]