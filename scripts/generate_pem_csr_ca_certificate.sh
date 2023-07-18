#!/bin/bash

CA_CERTIFICATE="ca_certificate.pem"
CA_PRIVATE_KEY="ca_private_key.pem"
VALID_DAYS=365

# Prompt for certificate details
read -p "Enter country name (C): " COUNTRY
read -p "Enter state or province name (ST): " STATE
read -p "Enter locality name (L): " LOCALITY
read -p "Enter organization name (O): " ORGANIZATION
read -p "Enter common name for the certificate (CN): " COMMON_NAME

# Generate certificate signing request (CSR)
openssl req -new -key private_key.pem \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME" -out csr.pem

# Sign the CSR with the CA
openssl x509 -req -days $VALID_DAYS -in csr.pem -CA $CA_CERTIFICATE -CAkey $CA_PRIVATE_KEY -CAcreateserial -out signed_certificate.pem

# Remove the CSR file
rm csr.pem

echo "Certificate signed by the CA successfully."
echo "Signed certificate path: $(pwd)/signed_certificate.pem"

