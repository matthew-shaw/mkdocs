# Build stage
FROM python:3.13-alpine AS builder

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY mkdocs.yml ./
COPY docs docs

RUN mkdocs build --strict

# Final stage
FROM nginx:stable-alpine

RUN apk update && apk add --no-cache openssl && \
    mkdir /etc/nginx/ssl && \
    openssl req -x509 -noenc -newkey rsa:2048 -keyout /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/req.pem -days 90 -subj "/C=GB/ST=Devon/L=Plymouth/O=Mash Software/CN=localhost"

COPY nginx.conf /etc/nginx/conf.d
COPY --from=builder /site /site