#!/bin/sh

# Script: create_account.sh
# Description: Script to create a user account in Bluesky PDS.
# Usage: ./create_account.sh <handle> <email> <password>
# Author: Your Name
# Date: $(date +%Y-%m-%d)

# Check if the required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <handle> <email> <password>"
    exit 1
fi

HANDLE=$1
EMAIL=$2
PASSWORD=$3

# Generate an invite code
INVITE_CODE_RESPONSE=$(curl -s -X POST http://localhost:2583/xrpc/com.atproto.server.createInviteCodes \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer 96+WZkL6DxTIH0h0P2z" \
  -d '{"codeCount": 1, "useCount": 1}')

INVITE_CODE=$(echo $INVITE_CODE_RESPONSE | jq -r '.codes[0]')

if [ "$INVITE_CODE" = "null" ]; then
    echo "Failed to generate invite code."
    exit 1
fi

echo "Invite code generated: $INVITE_CODE"

# Create an account
ACCOUNT_RESPONSE=$(curl -s -X POST http://localhost:2583/xrpc/com.atproto.server.createAccount \
  -H "Content-Type: application/json" \
  -d "{
    \"handle\": \"$HANDLE\",
    \"email\": \"$EMAIL\",
    \"password\": \"$PASSWORD\",
    \"inviteCode\": \"$INVITE_CODE\"
  }")

echo "Account creation response: $ACCOUNT_RESPONSE"

