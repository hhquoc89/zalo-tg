FROM node:20-alpine

# ffmpeg for voice note conversion
RUN apk add --no-cache ffmpeg

WORKDIR /app

COPY package*.json ./
# Install all deps (including devDependencies) for build step
RUN npm ci

COPY . .
RUN npm run build

# Prune devDependencies after build
RUN npm prune --omit=dev

EXPOSE 3001

CMD ["node", "dist/index.js"]
