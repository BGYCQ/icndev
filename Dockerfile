FROM node:14.4.0-alpine3.12 AS builder
WORKDIR /app
COPY . .
ARG ENVIRONMENT=qa
ARG BANKENADDR=null
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk add git && \
    yarn install --registry http://registry.npmmirror.com  && \ yarn run params $BANKENADDR && \ yarn docs:build

FROM nginx:1.19-alpine
COPY --from=builder /app/docs/.vuepress/dist/ /usr/share/nginx/html/