# Mailflare on Railway

Mailflare - self-hosted email inbox, calendar and booking pages for your custom domains. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/mailflare)

Builds [hieunc229/mailflare](https://github.com/hieunc229/mailflare) (AGPL-3.0) from a pinned commit and runs its Node/Docker runtime: SQLite and attachments on a Railway volume at `/data`.

## Features

- Multiple domains and mailboxes, shared inboxes, per-user access
- Send and receive with attachments, signatures, auto-replies, routing rules
- Calendar with invitations and public booking pages
- Search, folders, stars, snooze, spam, contacts, import/export
- Admin: users, API keys, webhooks, audit logs, daily backups
- AI assistant (any OpenAI-compatible API) and an MCP endpoint at `/mcp`

## How to use

1. Click **Deploy on Railway**.
2. Open the generated domain at `/setup` and create the admin account.
3. Pick how mail flows (Railway cannot accept inbound SMTP on port 25, so the built-in listener is off):
   - **Resend or Amazon SES per domain** (simplest): add the API credentials on the domain page. Inbound and outbound both go over HTTPS.
   - **Cloudflare Email Routing**: keep MX on Cloudflare and deploy `deploy/cloudflare-email-relay` from the upstream repo, pointing it at `https://<your-domain>/api/inbound` with the `INBOUND_WEBHOOK_SECRET` value from this service.
   - **Cloudflare Email Sending** for outbound: set `CF_ACCOUNT_ID` and `CF_TOKEN`.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `PORT` | `3000` | HTTP port |
| `DATA_DIR` | `/data` | SQLite, blobs, backups (volume) |
| `APP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Public URL for links, JMAP and provider webhooks |
| `SMTP_INBOUND_PORT` | `0` | Built-in SMTP listener off |
| `INBOUND_WEBHOOK_SECRET` | generated | Shared secret for the Cloudflare relay Worker |
| `CF_ACCOUNT_ID`, `CF_TOKEN` | optional | Cloudflare Email Sending and DNS/Email Routing management |
| `RESEND_API_KEY` | optional | Default Resend key |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` | optional | Default Amazon SES credentials |
| `SMTP_URL` | optional | Outbound SMTP relay (Railway allows outbound SMTP on Pro plans only) |
| `AI_BASE_URL`, `AI_API_KEY`, `AI_MODEL` | optional | Assistant model |

## Notes

- All data lives on the `/data` volume. Back it up, or use the in-app Backups page.
- Updating: bump `MAILFLARE_REF` in the Dockerfile and redeploy. Migrations run on start.
- The entrypoint chowns the root-owned Railway volume, then runs as the `node` user.
