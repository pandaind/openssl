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

# Prompt for client details
read -p "Enter client common name (CN): " CLIENT_CN
read -p "Enter client organization name (O): " CLIENT_ORG
read -p "Enter client organizational unit (OU): " CLIENT_OU
read -p "Enter client locality (L): " CLIENT_LOCALITY
read -p "Enter client state or province (ST): " CLIENT_STATE
read -p "Enter client country (C): " CLIENT_COUNTRY

# Generate server keystore
keytool -genkeypair -alias server -keyalg RSA -keystore server_keystore.jks -storepass "$KEYSTORE_PASSWORD" -keypass "$KEYSTORE_PASSWORD" \
    -dname "CN=$SERVER_CN, OU=$SERVER_OU, O=$SERVER_ORG, L=$SERVER_LOCALITY, ST=$SERVER_STATE, C=$SERVER_COUNTRY"

# Generate client keystore
keytool -genkeypair -alias client -keyalg RSA -keystore client_keystore.jks -storepass "$KEYSTORE_PASSWORD" -keypass "$KEYSTORE_PASSWORD" \
    -dname "CN=$CLIENT_CN, OU=$CLIENT_OU, O=$CLIENT_ORG, L=$CLIENT_LOCALITY, ST=$CLIENT_STATE, C=$CLIENT_COUNTRY"

# Import CA certificate into server truststore
keytool -importcert -alias rootCA -file root_ca_certificate.pem -keystore server_truststore.jks -storepass "$TRUSTSTORE_PASSWORD" -noprompt

# Import CA certificate into client truststore
keytool -importcert -alias rootCA -file root_ca_certificate.pem -keystore client_truststore.jks -storepass "$TRUSTSTORE_PASSWORD" -noprompt

echo "Server and client keystore and truststore files generated successfully."
echo "Server keystore path: $(pwd)/server_keystore.jks"
echo "Client keystore path: $(pwd)/client_keystore.jks"
echo "Server truststore path: $(pwd)/server_truststore.jks"
echo "Client truststore path: $(pwd)/client_truststore.jks"

