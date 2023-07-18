#!/bin/bash

CA_CERTIFICATE="ca_certificate.pem"
CA_PRIVATE_KEY="ca_private_key.pem"
VALID_DAYS=365

# Prompt for CSR file path
read -p "Enter the path to the CSR file: " CSR_FILE

# Check if CSR file exists
if [ ! -f "$CSR_FILE" ]; then
    echo "CSR file not found!"
    exit 1
fi

# Sign the CSR with the CA
openssl x509 -req -days $VALID_DAYS -in "$CSR_FILE" -CA $CA_CERTIFICATE -CAkey $CA_PRIVATE_KEY -CAcreateserial -out signed_certificate.pem

echo "Certificate signed by the CA successfully."
echo "Signed certificate path: $(pwd)/signed_certificate.pem"

