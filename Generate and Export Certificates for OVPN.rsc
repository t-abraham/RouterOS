######################################################################
Identity: Generate and Export Certificates for OVPN
Author: Tahasanul Abraham
Created: Oct 16 2016
Last Edited: Jan 5 2018
Compatible Versions: ROS 6.x
Tested on: ROS 6.2 - 6.42
######################################################################

### Working Script ### 
/certificate
add name=ca-template common-name=common-server-name days-valid=3650 key-size=4096 key-usage=crl-sign,key-cert-sign
add name=server-template common-name=server-name days-valid=3650 key-size=4096 key-usage=digital-signature,key-encipherment,tls-server
add name=client-template common-name=client-name days-valid=3650 key-size=4096 key-usage=tls-client

/certificate
sign ca-template name=ca-certificate
sign server-template name=server-certificate ca=ca-certificate
sign client-template name=client-certificate ca=ca-certificate

/certificate
export-certificate ca-certificate export-passphrase=""
export-certificate client-certificate export-passphrase=password