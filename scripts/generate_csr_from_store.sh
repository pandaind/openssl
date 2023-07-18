#!/bin/bash

KEYSTORE_PASSWORD="changeit"
TRUSTSTORE_PASSWORD="changeit"

# Prompt for server details
read -p "Enter server common name (CN): " SERVER_CN
read -p "Enter server organization name (O): " SERVER_ORG
read -p "Enter server organizational unit (OU): " SERVER_OU
read -p "Enter server locality (L): " SERVER_LOCALITY
read -p "Enter server state or province (ST): " SERVER_STATE
read -p "Enter server country (C): " SERVER_COUNTRY

# Generate server keystore
keytool -genkeypair -alias server -keyalg RSA -keystore server_keystore.jks -storepass "$KEYSTORE_PASSWORD" -keypass "$KEYSTORE_PASSWORD" \
    -dname "CN=$SERVER_CN, OU=$SERVER_OU, O=$SERVER_ORG, L=$SERVER_LOCALITY, ST=$SERVER_STATE, C=$SERVER_COUNTRY"

# Generate certificate signing request (CSR)
keytool -certreq -alias server -keystore server_keystore.jks -storepass "$KEYSTORE_PASSWORD" -file server_csr.pem

# Generate server truststore and import root CA certificate
keytool -importcert -alias rootCA -file root_ca_certificate.pem -keystore server_truststore.jks -storepass "$TRUSTSTORE_PASSWORD" -noprompt

echo "Server keystore and truststore files generated successfully."
echo "Server keystore path: $(pwd)/server_keystore.jks"
echo "Server truststore path: $(pwd)/server_truststore.jks"

# Send the CSR (server_csr.pem) to the third party for certificate signing
echo "Please send the generated CSR (server_csr.pem) to the third party for certificate signing."

