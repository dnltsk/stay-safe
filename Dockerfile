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
    apk add nodejs nodejs-npm && \
    apk add git && \
    apk add libc-dev libpng-dev autoconf libtool && \
    pip install git+https://github.com/Supervisor/supervisor && \
    rm -r /root/.cache

# copy project files
RUN mkdir /app /app/backend /app/frontend
COPY backend/ /app/backend
COPY frontend/ /app/frontend
RUN rm -rf /app/frontend/node_modules/

# build backend
RUN pip install --default-timeout=100 -r app/backend/requirements.txt

# build frontend
RUN cd /app/frontend && \
    npm install && \
    npm run build:dll

# write supervisor.conf
RUN cd /app/ && \
    echo "[supervisord]" > supervisord.conf && \
    echo "nodaemon=true" >> supervisord.conf && \
    echo "" >> supervisord.conf && \
    echo "[program:backend]" >> supervisord.conf && \
    echo "directory=/app/backend" >> supervisord.conf && \
    echo "command=python Main.py" >> supervisord.conf && \
    echo "" >> supervisord.conf && \
    echo "[program:frontend]" >> supervisord.conf && \
    echo "directory=/app/frontend" >> supervisord.conf && \
    echo "command=npm start" >> supervisord.conf

EXPOSE 3000 8000

WORKDIR /app
CMD ["supervisord", "--configuration", "/app/supervisord.conf"]