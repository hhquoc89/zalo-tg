FROM node:20-alpine

# ffmpeg for voice note conversion
RUN apk add --no-cache ffmpeg

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .
RUN npm run build

EXPOSE 3001

CMD ["node", "dist/index.js"]
