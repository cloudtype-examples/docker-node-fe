# OS 의존성 설치
FROM node:16-buster AS deps
WORKDIR /app
COPY package.json package-lock.json ./ 
RUN npm ci


# 프로젝트 빌드
FROM node:16-buster AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED 1
RUN npm run build


# Production 런타임
FROM node:16-buster AS runner
WORKDIR /app
ENV NODE_ENV production
# ENV NEXT_TELEMETRY_DISABLED 1


COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# RUN mkdir .next/cache/images && chmod -R 777 .next/cache/images

# node 이미지에 이미 "node"라는 사용자가 uid/gid 1000번으로 생성되어 있음
USER node

EXPOSE 3000
ENV PORT 3000
CMD ["npm", "start"]
