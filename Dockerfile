FROM node:lts-alpine3.17

RUN apk update \
 && apk --no-cache add git openssh-client openssl wget \
 && apk --no-cache add --virtual devs git tar curl \
 && git config --global url.https://github.com/.insteadOf git://github.com/ \
 && mkdir -p /opt/app/ \
 && git clone https://github.com/solid/node-solid-server /opt/app \
 && chown -R node:0 /opt/app && chmod -R 775 /opt/app/ \
 && apk del --purge devs      

WORKDIR /opt/app/

EXPOSE 8443
USER 1000
RUN npm i \
 && mv config.json-default config.json \
 && openssl req \
    -new \
    -newkey rsa:4096 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -keyout privkey.pem \
    -out fullchain.pem

CMD ["npm", "run", "solid", "start"]
