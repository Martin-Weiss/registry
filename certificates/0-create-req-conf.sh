#!/bin/bash
source ./variables.txt

reg_conf=./req.conf

cat > $reg_conf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
C = $C
ST = $ST
O = $O
CN = $CN
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
EOF
COUNT=1
for SAN in $(echo $SANS|sed 's/,/ /g'); do 
	echo "DNS.$COUNT = $SAN" >> $reg_conf ;
	((COUNT=COUNT+1))
done
exit
DNS.1 = *.suse
DNS.2 = *.cap.suse
DNS.3 = *.uaa.suse
DNS.4 = api.cap.suse
