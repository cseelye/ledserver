# Builder image
FROM python:3.8.2-buster as builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /tmp/requirements.txt
RUN pip wheel --no-cache-dir --wheel-dir /tmp/wheels -r /tmp/requirements.txt

# Final image
FROM python:3.8.2-slim-buster

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive  apt install --yes --no-install-recommends \
        nginx supervisor && \
    apt-get autoremove --yes && \
    apt-get clean && \
    rm --force --recursive /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /etc/nginx/sites-enabled/default

COPY --from=builder /tmp/wheels /tmp/wheels
RUN pip install --no-cache /tmp/wheels/*

RUN useradd --no-create-home nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/conf.d/nginx-app.conf
COPY supervisord.conf /etc/supervisord.conf
COPY uwsgi.ini /etc/uwsgi/uwsgi.ini

COPY ledserver /ledserver

EXPOSE 80
WORKDIR /ledserver
CMD ["/usr/bin/supervisord"]
