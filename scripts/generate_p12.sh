#!/bin/bash

# Prompt for server details
read -p "Enter server common name (CN): " SERVER_CN
read -p "Enter server organization name (O): " SERVER_ORG
read -p "Enter server organizational unit (OU): " SERVER_OU
read -p "Enter server locality (L): " SERVER_LOCALITY
read -p "Enter server state or province (ST): " SERVER_STATE
read -p "Enter server country (C): " SERVER_COUNTRY

# Prompt for PKCS#12 file details
read -p "Enter output PKCS#12 file name: " PKCS12_FILE_NAME
read -s -p "Enter password for PKCS#12 file: " PKCS12_PASSWORD
echo

# Generate server key pair and certificate signing request (CSR)
openssl req -newkey rsa:2048 -nodes -keyout server_private_key.pem -out server_csr.pem \
    -subj "/C=$SERVER_COUNTRY/ST=$SERVER_STATE/L=$SERVER_LOCALITY/O=$SERVER_ORG/OU=$SERVER_OU/CN=$SERVER_CN"

# Sign the server CSR with the root CA to get the server certificate
openssl x509 -req -in server_csr.pem -CA root_ca_certificate.pem -CAkey root_ca_private_key.pem -CAcreateserial -out server_certificate.pem -days 365

# Generate PKCS#12 file
openssl pkcs12 -export -inkey server_private_key.pem -in server_certificate.pem -name "Server Certificate" -out "$PKCS12_FILE_NAME" -passout pass:"$PKCS12_PASSWORD"

echo "PKCS#12 file generated successfully."
echo "PKCS#12 file path: $(pwd)/$PKCS12_FILE_NAME"

