FROM node:latest
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund

COPY src ./src

ENV PORT=8090
EXPOSE 8090

CMD ["node", "src/index.js"]


