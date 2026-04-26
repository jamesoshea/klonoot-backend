FROM node:22.22-alpine

WORKDIR client

COPY src package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build