#!/bin/bash

# Variables
cert_file="self-signed.crt"
key_file="private.key"
key_password="secret"
days_valid=365
rsa_bits=4096

# Generate private key
openssl genpkey -aes256 -algorithm RSA -out "$key_file" -pkeyopt rsa_keygen_bits:"$rsa_bits" -pass pass:"$key_password"

# Generate certificate signing request (CSR)
openssl req -new -key "$key_file" -out "$cert_file".csr -passin pass:"$key_password"

# Generate self-signed certificate
openssl x509 -req -days "$days_valid" -in "$cert_file".csr -signkey "$key_file" -out "$cert_file" -passin pass:"$key_password"

# Clean up the CSR file
rm "$cert_file".csr

# Display generated certificate and private key paths
echo "Self-signed certificate generated: $cert_file"
echo "Private key generated: $key_file"

