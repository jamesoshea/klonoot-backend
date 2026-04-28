FROM node:22.22-alpine

WORKDIR client
ENV VITE_SERVER_URL=${VITE_SERVER_URL}

COPY src package.json package-lock.json ./

RUN npm ci
COPY . .

EXPOSE 5173
CMD ["npm", "run", "dev"]