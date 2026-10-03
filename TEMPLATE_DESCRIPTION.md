## Template Titles

**Railway Title:** `Mailflare [Updated October '26]`
**Railway Description:** `Mailflare [October '26] (Custom Domain Email, Calendar & Booking) Self Host`
**Spreadsheet Title:** `Mailflare (Open-Source Custom Domain Email Inbox & Calendar Platform)`
**GitHub Description:** `Mailflare - self-hosted email inbox, calendar and booking pages for your custom domains. Deploy on Railway with one click.`

---

![Mailflare self hosted email inbox for custom domains](https://res.cloudinary.com/dh2nt6hgh/image/upload/v1780000000/mailflare_banner_placeholder.webp "Hosting Mailflare open source email inbox on Railway")

# Deploy and Host self hosted Mailflare (Open-Source Custom Domain Email Inbox) on Railway

Mailflare is an open-source, self-hosted email inbox for custom domains. It gives you mailboxes, shared inboxes, a calendar with invitations, public booking pages, routing rules, an AI assistant, and an MCP endpoint in one web app. Mail is sent and received through Resend, Amazon SES, or Cloudflare, so it replaces paying per seat for Google Workspace just to get `you@yourdomain.com`.

## About Hosting Mailflare open-source software on Railway (self hosted Mailflare template)

Self hosting Mailflare keeps every message, attachment, and calendar event in a SQLite database and file store you own, with no per-user fees and no provider reading your mail. This template builds Mailflare from a pinned upstream commit and runs its Node runtime on Railway, which handles the build, TLS, public domain, healthcheck, restarts, and a persistent volume at `/data`.

## Why Deploy Mailflare, the Google Workspace alternative on Railway (Railway Free Trial)

Google Workspace and Microsoft 365 charge for every user who needs an address on your domain, and the bill grows with each shared inbox. Mailflare is AGPL-3.0 licensed and free, and Resend sends 3,000 emails a month on its free tier, so a small team can run custom domain email for the price of one small container. Railway also gives every new user a $5 free trial on GitHub signup, enough to set up Mailflare and send real mail.

### Railway vs Other Hosting Providers and VPS for Mailflare self hosting

| Provider | What You Get with Railway | What You Get with the Other Provider |
| --- | --- | --- |
| **DigitalOcean** | One-click deploy with a persistent volume and HTTPS domain | A droplet where you install Docker, a proxy, and certificates yourself |
| **AWS** | Usage-based pricing with no EC2, EBS, or IAM setup | Powerful, but VPC, security groups, and load balancer config come first |
| **Hetzner** | Managed builds, healthchecks, and automatic redeploys | Great price per core, but patching and backups are all yours |

## Common Use Cases for hosted Mailflare

Here are common use cases for the self-hosted custom domain email inbox:

* Giving a founder or small team professional custom domain email addresses without paying per seat for Google Workspace.
* Running shared support, sales, and billing inboxes that several people read and answer from one place.
* Replacing a separate Calendly subscription with built-in booking pages that send email invitations.
* Routing, forwarding, or rejecting incoming mail per domain with rules, and triggering webhooks for automations.
* Letting AI agents read, search, and draft replies over MCP with per-key, per-mailbox permissions.

![Mailflare inbox with domains and mailboxes](https://res.cloudinary.com/dh2nt6hgh/image/upload/v1780000000/mailflare_inbox_placeholder.webp "Mailflare open source email client self hosted")

## Dependencies for Mailflare Docker hosted on Railway

Mailflare runs as a single container with a volume at `/data`. It needs one mail provider account (Resend, Amazon SES, or Cloudflare) to actually send and receive, since Railway does not accept inbound SMTP on port 25.

### Deployment Dependencies for Managed Mailflare Service (OSS Email Inbox)

There is no PostgreSQL, Redis, or object storage to provision. The database is SQLite, attachments and raw messages are files on the same volume, and job queues, realtime updates, and daily backups run inside the same Node process. External pieces are your mail provider and, optionally, an OpenAI-compatible API for the assistant.

### Implementation Details for Mailflare (Built from the upstream Mailflare Dockerfile)

Upstream publishes no image, so the template builds upstream's own Dockerfile stages from a pinned commit. A small entrypoint chowns Railway's root-owned volume, then drops to the `node` user. Key variables: `PORT=3000`, `DATA_DIR=/data`, `APP_URL` set to the Railway public domain for links and provider webhooks, `SMTP_INBOUND_PORT=0` to switch off the port 25 listener, and `INBOUND_WEBHOOK_SECRET` for the Cloudflare relay Worker. Setup requires an outbound sender: `SMTP_URL` (for example Resend SMTP on port 2465) or `CF_ACCOUNT_ID` with `CF_TOKEN`. Optional: `AI_BASE_URL`, `AI_API_KEY`, `AI_MODEL`.

## How does Mailflare compare against other email platforms

### Mailflare vs Google Workspace (Gmail Alternative)
* **Cost Model:** Mailflare has no per-user fee, while Google Workspace bills every mailbox monthly.
* **Data Ownership:** Mail sits in your own SQLite database and volume instead of Google's servers.

### Mailflare vs Zoho Mail (Zoho Mail Alternative)
* **Extras:** Mailflare includes booking pages, routing rules, webhooks, and an MCP endpoint out of the box.
* **Control:** You pick the sending provider per domain and can switch at any time.

### Mailflare vs Mailcow (Mailcow Alternative)
* **Footprint:** Mailcow runs a full Postfix, Dovecot, and Rspamd stack, while Mailflare is one Node container.
* **Deliverability:** Mailflare hands sending to Resend or SES, so you avoid IP reputation and port 25 problems.

### Mailflare vs Fastmail (Fastmail Alternative)
* **Pricing:** Fastmail charges per user, while self hosted Mailflare costs only the server and provider usage.
* **Automation:** Mailflare exposes an API, webhooks, and MCP keys scoped per mailbox, so scripts and AI agents work with mail directly.

## How to use Mailflare (the OSS email inbox)?

Open the Railway domain right after deploy and go to `/setup`. The first account created becomes the primary admin, so finish this step before sharing the URL. Setup checks for an outbound sender first, so set `SMTP_URL` to `smtps://resend:YOUR_KEY@smtp.resend.com:2465` (or Cloudflare credentials) before you begin. Enter your domain and create the first mailbox; Mailflare lists the DNS records to add, and the domain page takes Resend or SES keys for receiving. For Cloudflare Email Routing, deploy the relay Worker from the upstream repo and point it at `/api/inbound` with your `INBOUND_WEBHOOK_SECRET`. Then add mailboxes, users, rules, and booking pages.

## How to self host Mailflare on other VPS Services (Mailflare self hosting guide)

### Clone the Repository
Download **Mailflare** from [GitHub](https://github.com/hieunc229/mailflare) with `git clone`.

### Install Dependencies
Ensure your VPS has **Docker** and Docker Compose, plus a reverse proxy such as Caddy or Nginx that forwards WebSocket upgrades for `/api/realtime`.

### Configure Environment Variables
Set up the configuration such as:
* `APP_URL`
* `MAIL_HOSTNAME`
* `SMTP_URL` or `RESEND_API_KEY`
* `INBOUND_WEBHOOK_SECRET`
for links, sending, and receiving mail.

### Start the Mailflare Application
Run `docker compose up -d --build`, open port 25 for the built-in SMTP listener, and visit `/setup`.

## Official Pricing of Mailflare (Mailflare pricing)
Mailflare is **open source and free** under the AGPL-3.0 license, with no seat or mailbox limits. Your only costs are hosting and the mail provider: Cloudflare Email Routing receives for free, Resend's free tier covers 3,000 emails a month, and Amazon SES costs about $0.10 per 1,000 emails.

## Mailflare cloud vs self hosted comparison (Pricing, features, costs, and more)
There is no paid Mailflare cloud plan; upstream offers a Cloudflare Workers deploy and a Docker self-host. Hosting it on Railway avoids the Cloudflare account setup and keeps the whole app in one container with a volume you control. Backups run daily at 02:00 UTC to the same volume.

### Monthly cost of self hosting Mailflare on Railway
The Mailflare self hosting cost on Railway is typically $5-$10/month for a small team, covering the container and volume, plus provider usage beyond the free tiers.

### System Requirements for Hosting Mailflare on a VPS
Mailflare runs on 1 vCPU and 1GB RAM for small teams, with disk sized to your mail and attachments, Docker installed, and port 25 open if you receive directly.

## Frequently Asked Questions (FAQs)

### What is Mailflare self hosted?
Mailflare self hosted means running the open-source Mailflare inbox on your own infrastructure, such as Railway or a VPS, so your custom domain email, contacts, and calendar stay under your control.

### How much does Mailflare self hosting cost on Railway?
Usually $5-$10/month for the container and volume. Sending through the Resend or SES free tiers adds nothing for low volume.

### Is Mailflare free to use?
Yes, Mailflare is free and open source under AGPL-3.0. You only pay for hosting and any mail provider usage above the free tiers.

### Can Mailflare receive email on Railway?
Yes, through Resend or Amazon SES inbound webhooks, or a Cloudflare Email Routing relay Worker that posts mail to `/api/inbound`. Direct port 25 SMTP is not available on Railway, so the built-in listener stays off.

### Where can I download Mailflare?
You can get Mailflare from the official [GitHub repository](https://github.com/hieunc229/mailflare), or deploy it on Railway with one click using this template.

### What are some alternatives to Mailflare?
Popular alternatives include Google Workspace, Zoho Mail, Fastmail, Proton Mail, Mailcow, and Mail-in-a-Box, though Mailflare stands out for running as one container with built-in booking pages and AI over MCP.
