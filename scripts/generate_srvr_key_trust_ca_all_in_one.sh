#!/bin/bash

KEYSTORE_PASSWORD="changeit"
TRUSTSTORE_PASSWORD="changeit"

# Prompt for root CA details
read -p "Enter root CA common name (CN): " ROOT_CA_CN
read -p "Enter root CA organization name (O): " ROOT_CA_ORG
read -p "Enter root CA organizational unit (OU): " ROOT_CA_OU
read -p "Enter root CA locality (L): " ROOT_CA_LOCALITY
read -p "Enter root CA state or province (ST): " ROOT_CA_STATE
read -p "Enter root CA country (C): " ROOT_CA_COUNTRY

# Generate root CA key pair and self-signed certificate
openssl req -newkey rsa:4096 -nodes -keyout root_ca_private_key.pem -x509 -days 365 -out root_ca_certificate.pem \
    -subj "/C=$ROOT_CA_COUNTRY/ST=$ROOT_CA_STATE/L=$ROOT_CA_LOCALITY/O=$ROOT_CA_ORG/OU=$ROOT_CA_OU/CN=$ROOT_CA_CN"

# Prompt for server details
read -p "Enter server common name (CN): " SERVER_CN
read -p "Enter server organization name (O): " SERVER_ORG
read -p "Enter server organizational unit (OU): " SERVER_OU
read -p "Enter server locality (L): " SERVER_LOCALITY
read -p "Enter server state or province (ST): " SERVER_STATE
read -p "Enter server country (C): " SERVER_COUNTRY

# Generate server key pair and certificate signing request (CSR)
openssl req -newkey rsa:2048 -nodes -keyout server_private_key.pem -out server_csr.pem \
    -subj "/C=$SERVER_COUNTRY/ST=$SERVER_STATE/L=$SERVER_LOCALITY/O=$SERVER_ORG/OU=$SERVER_OU/CN=$SERVER_CN"

# Sign the server CSR with the root CA to get the server certificate
openssl x509 -req -in server_csr.pem -CA root_ca_certificate.pem -CAkey root_ca_private_key.pem -CAcreateserial -out server_certificate.pem -days 365

# Generate server keystore and import server certificate and private key
keytool -importcert -alias server -file server_certificate.pem -keystore server_keystore.jks -storepass "$KEYSTORE_PASSWORD" -noprompt
keytool -importkeystore -srckeystore server_keystore.jks -srcstorepass "$KEYSTORE_PASSWORD" -srcalias server \
    -destkeystore server_keystore.jks -deststorepass "$KEYSTORE_PASSWORD" -destalias server

# Generate server truststore and import root CA certificate
keytool -importcert -alias rootCA -file root_ca_certificate.pem -keystore server_truststore.jks -storepass "$TRUSTSTORE_PASSWORD" -noprompt

# Cleanup intermediate files
rm root_ca_private_key.pem root_ca_certificate.pem server_csr.pem server_certificate.pem root_ca_private_key.pem.srl

echo "Root CA, server certificate, keystore, and truststore generated successfully."
echo "Server keystore path: $(pwd)/server_keystore.jks"
echo "Server truststore path: $(pwd)/server_truststore.jks"

