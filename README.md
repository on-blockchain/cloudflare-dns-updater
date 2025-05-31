# Cloudflare DNS Updater

This is a Bash script that connects to the Cloudflare API and updates the A record of a domain with your current external IP address. Useful for dynamic IP setups like home servers or VPS instances without static IPs.

---

## 🔧 Configuration

Open the script file `cloudflare.sh` and update the following variables at the top:

```bash
API_TOKEN="your_cloudflare_api_token"
ZONE_ID="your_zone_id"
RECORD_NAME="your.domain.com"
```

### How to Get These:

- **API_TOKEN**: Go to [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens) and create a token with DNS edit permissions.
- **ZONE_ID**:
  1. Login to Cloudflare dashboard
  2. Go to your domain → Overview tab
  3. Scroll down to find the Zone ID
- **RECORD_NAME**: This is the full domain/subdomain whose A record you want to update (e.g., `www10.example.com`).

---

## ▶️ Usage

Make the script executable and run it:

```bash
chmod +x cloudflare.sh
./cloudflare.sh
```

Or run with `bash`:

```bash
bash cloudflare.sh
```

---

## ⏰ Setup as Cron Job

To automatically run the script every minute (or at your preferred interval):

1. Open your crontab:

```bash
crontab -e
```

2. Add this line at the bottom:

```cron
* * * * * bash /root/cloudflare.sh >> /tmp/cloudflare.log 2>&1
```

✅ Replace `/root/cloudflare.sh` with the absolute path to the script on your system.

This will:
- Run the script every minute
- Log output to `/tmp/cloudflare.log` (optional)

---
