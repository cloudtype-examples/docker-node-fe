# 프로젝트 빌드
FROM node:16-buster AS builder
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build


# Production 런타임
FROM nginx:1.23 AS runner
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/build .
ENV NODE_ENV production

USER node

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
