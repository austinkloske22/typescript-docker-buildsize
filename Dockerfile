#Pull the base machine
FROM node:16-alpine AS build

#setting a work directory for our application
WORKDIR /usr/src/app

COPY package*.json ./
# RUN apk add --update git // 
RUN npm ci

COPY tsconfig.json /usr/src/app/
COPY src /usr/src/app/src/
RUN npm run build
RUN npm ci --production

FROM alpine:3
RUN apk add nodejs --no-cache
WORKDIR /usr/src/app
COPY .env .
COPY --from=build /usr/src/app/node_modules /usr/src/app/node_modules
COPY --from=build /usr/src/app/dist /usr/src/app/dist

CMD node ./dist/index.js
