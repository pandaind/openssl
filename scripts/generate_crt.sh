#!/bin/bash

KEY_FILE="private.key"
CERT_FILE="certificate.pem"
COMMON_NAME="panda.ind.in"

# Generate the private key
openssl genrsa -out $KEY_FILE 2048

# Generate the certificate signing request (CSR)
openssl req -new -key $KEY_FILE -out csr.pem -subj "/CN=$COMMON_NAME"

# Generate the self-signed certificate
openssl x509 -req -in csr.pem -signkey $KEY_FILE -out $CERT_FILE -days 365

# Remove the CSR file
rm csr.pem

echo "Self-signed certificate generated successfully."

