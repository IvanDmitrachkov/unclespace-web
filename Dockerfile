# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Устанавливаем зависимости
COPY package*.json ./
RUN npm ci

# Копируем исходники
COPY . .

# Сборка Next.js
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app

# Копируем только prod зависимости
COPY package*.json ./
RUN npm ci --omit=dev

# Копируем собранный проект из builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Запуск Next.js
CMD ["node", "node_modules/.bin/next", "start", "-p", "3000", "--hostname", "0.0.0.0"]
