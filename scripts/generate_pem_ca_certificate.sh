#!/bin/bash

KEY_SIZE=4096
VALID_DAYS=3650

# Prompt for CA details
read -p "Enter country name (C): " COUNTRY
read -p "Enter state or province name (ST): " STATE
read -p "Enter locality name (L): " LOCALITY
read -p "Enter organization name (O): " ORGANIZATION
read -p "Enter common name for the CA (CN): " COMMON_NAME
read -s -p "Enter password for CA private key encryption: " PASSWORD
echo

# Generate CA private key
openssl genrsa -aes256 -out ca_private_key.pem -passout pass:"$PASSWORD" $KEY_SIZE

# Generate CA self-signed root certificate
openssl req -new -x509 -days $VALID_DAYS -key ca_private_key.pem -passin pass:"$PASSWORD" \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME" -out ca_certificate.pem

echo "Certificate Authority (CA) and private key generated successfully."
echo "CA certificate path: $(pwd)/ca_certificate.pem"
echo "CA private key path: $(pwd)/ca_private_key.pem"

