# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/Dockerfile ./Dockerfile
COPY --from=builder /app/docker-compose.yml ./docker-compose.yml
COPY --from=builder /app/next.config.js ./next.config.js
