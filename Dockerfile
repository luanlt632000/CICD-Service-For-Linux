FROM node:16.3.0-alpine
RUN apk update
WORKDIR /data
CMD npm install; npm run start