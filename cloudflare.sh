#!/bin/bash

# === CONFIGURATION ===
API_TOKEN="APIKEY"
ZONE_ID="FindItInOverviewOfDomain"
RECORD_NAME="ww10.example.com"

# === GET CURRENT EXTERNAL IP ===
CURRENT_IP=$(curl -s https://api.ipify.org)

if [[ -z "$CURRENT_IP" ]]; then
  echo "❌ Could not fetch external IP."
  exit 1
fi

# === FETCH DNS RECORD DETAILS ===
RECORD_DATA=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json")

# === PARSE RECORD ID AND IP FROM RESPONSE ===
RECORD_ID=$(echo "$RECORD_DATA" | jq -r '.result[0].id')
DNS_IP=$(echo "$RECORD_DATA" | jq -r '.result[0].content')

# === VALIDATE RESPONSE ===
if [[ -z "$RECORD_ID" || "$RECORD_ID" == "null" ]]; then
  echo "❌ Could not retrieve A record ID for $RECORD_NAME."
  echo "$RECORD_DATA"
  exit 1
fi

# === COMPARE IPs ===
if [[ "$CURRENT_IP" == "$DNS_IP" ]]; then
  echo "✅ IP has not changed. Current IP: $CURRENT_IP"
  exit 0
fi

# === UPDATE CLOUDFLARE A RECORD ===
UPDATE_RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"type\": \"A\",
    \"name\": \"$RECORD_NAME\",
    \"content\": \"$CURRENT_IP\",
    \"ttl\": 1,
    \"proxied\": false
}")

if echo "$UPDATE_RESPONSE" | grep -q '"success":true'; then
  echo "✅ Updated A record for $RECORD_NAME to $CURRENT_IP"
else
  echo "❌ Failed to update A record."
  echo "$UPDATE_RESPONSE"
  exit 1
fi
