#!/bin/bash

ROOT_CA_CERTIFICATE="root_ca_certificate.pem"
ROOT_CA_PRIVATE_KEY="root_ca_private_key.pem"
VALID_DAYS=3650

# Prompt for Intermediate CA details
read -p "Enter country name (C): " COUNTRY
read -p "Enter state or province name (ST): " STATE
read -p "Enter locality name (L): " LOCALITY
read -p "Enter organization name (O): " ORGANIZATION
read -p "Enter common name for the Intermediate CA (CN): " COMMON_NAME
read -s -p "Enter password for Intermediate CA private key encryption: " PASSWORD
echo

# Generate Intermediate CA private key
openssl genrsa -aes256 -out intermediate_ca_private_key.pem -passout pass:"$PASSWORD" 4096

# Generate Intermediate CA certificate signing request (CSR)
openssl req -new -key intermediate_ca_private_key.pem -out intermediate_ca_csr.pem \
    -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME"

# Sign Intermediate CA CSR with Root CA
openssl x509 -req -days $VALID_DAYS -in intermediate_ca_csr.pem -CA $ROOT_CA_CERTIFICATE \
    -CAkey $ROOT_CA_PRIVATE_KEY -CAcreateserial -out intermediate_ca_certificate.pem

echo "Intermediate Certificate Authority (CA) and private key generated successfully."
echo "Intermediate CA certificate path: $(pwd)/intermediate_ca_certificate.pem"
echo "Intermediate CA private key path: $(pwd)/intermediate_ca_private_key.pem"

