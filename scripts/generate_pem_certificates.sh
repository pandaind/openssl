#!/bin/bash

KEY_SIZE=4096

# Prompt for variables
read -p "Enter country name (C): " COUNTRY
read -p "Enter state or province name (ST): " STATE
read -p "Enter locality name (L): " LOCALITY
read -p "Enter organization name (O): " ORGANIZATION
read -p "Enter common name (CN): " COMMON_NAME
read -s -p "Enter password for private key encryption: " PASSWORD
echo

# Generate a new private key with password encryption
openssl genrsa -aes256 -out private_key.pem -passout pass:"$PASSWORD" $KEY_SIZE

# Create a self-signed certificate signing request (CSR)
openssl req -new -key private_key.pem -out csr.pem -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME"

# Generate a self-signed certificate using the CSR
openssl x509 -req -days 365 -in csr.pem -signkey private_key.pem -out certificate.pem

# Remove the CSR file
rm csr.pem

echo "Self-signed certificate and private key generated successfully."
echo "Certificate path: $(pwd)/certificate.pem"
echo "Private key path: $(pwd)/private_key.pem"

