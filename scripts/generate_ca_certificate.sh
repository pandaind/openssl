#!/bin/bash

# Variables
ca_cert_file="ca_certificate.crt"
ca_key_file="ca_private.key"
days_valid=3650
rsa_bits=4096

# Generate private key for CA
openssl genpkey -algorithm RSA -out "$ca_key_file" -pkeyopt rsa_keygen_bits:"$rsa_bits"

# Generate CA certificate signing request (CSR)
openssl req -new -key "$ca_key_file" -out "$ca_cert_file".csr

# Generate self-signed CA certificate
openssl x509 -req -days "$days_valid" -in "$ca_cert_file".csr -signkey "$ca_key_file" -out "$ca_cert_file"

# Clean up the CSR file
rm "$ca_cert_file".csr

# Display generated CA certificate and private key paths
echo "CA certificate generated: $ca_cert_file"
echo "CA private key generated: $ca_key_file"

