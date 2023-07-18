#!/bin/bash

KEYSTORE_PASSWORD="changeit"
TRUSTSTORE_PASSWORD="changeit"

# Prompt for PKCS#12 file details
read -p "Enter PKCS#12 file path: " PKCS12_FILE
read -s -p "Enter password for PKCS#12 file: " PKCS12_PASSWORD
echo

# Generate keystore and import PKCS#12 file
keytool -importkeystore -srckeystore "$PKCS12_FILE" -srcstoretype PKCS12 -srcstorepass "$PKCS12_PASSWORD" \
    -destkeystore server_keystore.jks -deststorepass "$KEYSTORE_PASSWORD"

# Generate truststore and import root CA certificate
keytool -importcert -alias rootCA -file root_ca_certificate.pem -keystore server_truststore.jks -storepass "$TRUSTSTORE_PASSWORD" -noprompt

echo "Keystore and truststore files generated successfully."
echo "Keystore path: $(pwd)/server_keystore.jks"
echo "Truststore path: $(pwd)/server_truststore.jks"

