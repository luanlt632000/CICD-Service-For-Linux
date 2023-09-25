FROM node:16.3.0-alpine
RUN apk update
RUN apk add --no-cache --upgrade bash
#RUN addgroup -S admin && adduser -S admin -G admin
WORKDIR /data
#RUN chown -R admin:admin /data
#RUN chmod 755 /data
#USER admin
CMD npm install; npm run start
