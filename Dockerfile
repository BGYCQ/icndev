FROM node:16.15.1-alpine3.16 as builder
WORKDIR /app
COPY . .
ARG ENVIRONMENT=qa
ARG BANKENADDR=null
ARG GOOGLEANALYTICSID=null
ARG RELEASETIME=null
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk add git && \
    yarn install --registry http://registry.npmmirror.com \
    && yarn run params $BANKENADDR,$GOOGLEANALYTICSID,$RELEASETIME \
    && yarn docs:build

FROM nginx:1.19-alpine
COPY --from=builder /app/docs/.vuepress/dist/ /usr/share/nginx/html/
RUN echo -e 'server {\n\
    root /usr/share/nginx/html;\n\
    location /api/ {\n\
        proxy_pass http://interchainnfts-server:8080/;\n\
    }\n\
}' > /nginx.template
CMD sh -c "envsubst < /nginx.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"