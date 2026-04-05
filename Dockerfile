# Build stage
FROM node:24 AS build-stage

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci

COPY . .

RUN npm run build

# Run stage
FROM node:24-slim

WORKDIR /usr/src/app

COPY package*.json .

RUN npm ci --omit=dev

COPY --from=build-stage /usr/src/app/dist ./dist

COPY app.js .

CMD [ "node", "app.js" ]