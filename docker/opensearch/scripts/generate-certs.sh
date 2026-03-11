#!/bin/sh
# Generate self-signed CA and node cert for OpenSearch TLS.
# Usage: generate-certs.sh [output_dir]
# Output: root-ca.pem, root-ca-key.pem, node.pem, node-key.pem in output_dir.
# CN=opensearch; SANs: localhost, opensearch (for Docker service name).

set -e
OUT_DIR="${1:-/usr/share/opensearch/config/certs}"
mkdir -p "$OUT_DIR"
cd "$OUT_DIR"

# CA
openssl genrsa -out root-ca-key.pem 2048
openssl req -new -x509 -sha256 -key root-ca-key.pem -out root-ca.pem -days 3650 \
  -subj "/C=US/ST=State/L=City/O=AttackFramework/OU=Dev/CN=OpenSearch-Root-CA"

# Node key and CSR with SANs (localhost, opensearch)
openssl genrsa -out node-key.pem 2048
openssl req -new -key node-key.pem -out node.csr \
  -subj "/C=US/ST=State/L=City/O=AttackFramework/OU=Dev/CN=opensearch"

# Sign node cert with SANs
cat > node.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName=DNS:localhost,DNS:opensearch,DNS:opensearch.url,IP:127.0.0.1
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth,clientAuth
EOF
openssl x509 -req -in node.csr -CA root-ca.pem -CAkey root-ca-key.pem \
  -CAcreateserial -out node.pem -days 3650 -sha256 -extfile node.ext
rm -f node.csr node.ext root-ca.srl

echo "Generated certs in $OUT_DIR"
