# Mailflare (https://github.com/hieunc229/mailflare) for Railway.
# Upstream publishes no image, so this builds its own Dockerfile stages from a
# pinned commit. Next.js app, job queues, realtime and backups run in one Node
# process; SQLite and attachments live on the /data volume.
ARG MAILFLARE_REF=0159439b2f2e16d1d6efab24d200cada816db895

FROM node:22-bookworm-slim AS base
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1 MAILFLARE_RUNTIME=node

FROM base AS src
ARG MAILFLARE_REF
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git && rm -rf /var/lib/apt/lists/*
RUN git init -q /src && cd /src \
	&& git remote add origin https://github.com/hieunc229/mailflare.git \
	&& git fetch -q --depth 1 origin "$MAILFLARE_REF" \
	&& git checkout -q FETCH_HEAD \
	&& rm -rf .git

# better-sqlite3 ships prebuilt binaries for this image; the toolchain is only
# a fallback for platforms without one.
FROM base AS deps
RUN apt-get update && apt-get install -y --no-install-recommends python3 make g++ && rm -rf /var/lib/apt/lists/*
COPY --from=src /src/package.json /src/package-lock.json ./
RUN npm ci --ignore-scripts && npm rebuild better-sqlite3

FROM deps AS build
COPY --from=src /src/ ./
ARG NEXT_PUBLIC_TURNSTILE_SITE_KEY
ENV NEXT_PUBLIC_TURNSTILE_SITE_KEY=$NEXT_PUBLIC_TURNSTILE_SITE_KEY
RUN npm run build:node && rm -rf .next-node/cache

FROM deps AS prod-deps
RUN npm prune --omit=dev --ignore-scripts \
	&& rm -rf node_modules/wrangler node_modules/miniflare node_modules/workerd node_modules/@cloudflare node_modules/cloudflare node_modules/@aws-sdk node_modules/esbuild node_modules/@esbuild node_modules/typescript

FROM base AS runtime
# SMTP_INBOUND_PORT=0: Railway cannot route MX traffic to port 25, so inbound
# mail arrives through the Cloudflare relay Worker or Resend/SES webhooks.
ENV NODE_ENV=production DATA_DIR=/data PORT=3000 SMTP_INBOUND_PORT=0 HOME=/home/node
COPY --chown=node:node --from=prod-deps /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/.next-node ./.next-node
COPY --chown=node:node --from=build /app/dist ./dist
COPY --chown=node:node --from=build /app/public ./public
COPY --chown=node:node --from=build /app/drizzle ./drizzle
COPY --chown=node:node --from=build /app/package.json /app/next.config.ts ./
COPY --chown=node:node --from=build /app/src/lib/security/headers.ts ./src/lib/security/headers.ts
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod +x /usr/local/bin/railway-entrypoint.sh && mkdir -p /data && chown node:node /data
# Stays root so the entrypoint can chown Railway's root-owned volume, then
# drops to the node user before starting the server.
EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
CMD ["node", "dist/server.mjs"]
