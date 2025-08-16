# Шаг 1: Сборка приложения
FROM node:22.14-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Шаг 2: Запуск
FROM node:22.14-alpine

WORKDIR /app
COPY --from=builder /package*.json ./
COPY --from=builder /.next ./.next
COPY --from=builder /public ./public
COPY --from=builder /node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "start"]