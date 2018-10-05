###chmod +x ~/mikrotik_chr/mikrotik_ssl_update.py
#!/usr/bin/env python

####
# Configure here
VHOST = '*.skynode.link'
DESTINATION = '{}/mikrotik_upload'

####

from os.path import expanduser, join, exists
from os import makedirs
import json
import sys

if (exists('{}/.cpanel/nvdata/letsencrypt-cpanel'.format(expanduser('~')))):
  print ("Let's Encrypt cPanel application is INSTALLED")
  
  # Check for destination directory existance
  if not (exists(DESTINATION.format(expanduser('~')))):
    print ("Destination directory is NOT AVAILABLE")
    makedirs(DESTINATION.format(expanduser('~')))
    print ("Destination directory is CREATED")
  else:
    print ("Destination directory is AVAILABLE")
	
  # Read information from the Let's Encrypt App Data
  nvdata = None
  with open('{}/.cpanel/nvdata/letsencrypt-cpanel'.format(expanduser('~'))) as file:
    nvdata = json.loads(file.read())
  if not VHOST in nvdata['certs']:
    print ('No certificate data is present for {}'.format(VHOST))
    sys.exit(1)

  vhost_data = nvdata['certs'][VHOST]

  # Write the private key to destination
  with open(join(DESTINATION.format(expanduser('~')), 'skynode_link.key'), 'w') as f:
    f.write(vhost_data['key'])
	f.close()
    print ('Saved private key to {}'.format(DESTINATION.format(expanduser('~'))))

  # Write the certificate + cabundle to destination
  with open(join(DESTINATION.format(expanduser('~')), 'skynode_link.crt'), 'w') as f:
    f.write(vhost_data['cert'] +  vhost_data['issuer'])
	f.close()
    print ('Saved private key to {}'.format(DESTINATION.format(expanduser('~'))))
else:
  print ('Lets Encrypt cPanel application is NOT INSTALLED')
  sys.exit(1)