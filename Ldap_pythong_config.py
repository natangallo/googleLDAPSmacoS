#/usr/local/bin/managed_python3
from OpenDirectory import ODNode, ODSession , kODNodeTypeConfigure #kODNodeTypeConfigure
from Foundation import NSMutableData, NSData

import os
import sys

# Reading plist
#GOOGLELDAPCONFIGFILE = open(sys.argv[1], "r")
# inserito l'encoding perchè non si riusciva a farlo da utf-8
GOOGLELDAPCONFIGFILE = open(sys.argv[1], "r", encoding="latin-1")
#CONFIGENCODE = GOOGLELDAPCONFIGFILE.encode('latin-1')
CONFIG = GOOGLELDAPCONFIGFILE.read()
GOOGLELDAPCONFIGFILE.close()

# Write the plist
od_session = ODSession.defaultSession()
#od_conf_node, err = ODNode.nodeWithSession_type_error_(od_session, kODNodeTypeConfigure, None)
od_conf_node, err = ODNode.nodeWithSession_type_error_(od_session, kODNodeTypeConfigure, None)
request = NSMutableData.dataWithBytes_length_(b'\x00'*32, 32)
# Python 2 config
#request.appendData_(NSData.dataWithBytes_length_(CONFIG, len(CONFIG)))
# Python 3 config
#request.appendData_(NSData.dataWithBytes_length_(str.encode(CONFIG), len(CONFIG)))
request.appendData_(NSData.dataWithBytes_length_(bytes(CONFIG, 'latin-1'), len(CONFIG)))

response, err = od_conf_node.customCall_sendData_error_(99991, request, None)

# Edit the default search path and append the new node to allow for login
os.system("dscl -q localhost -append /Search CSPSearchPath /LDAPv3/ldap.google.com")
os.system("bash -c 'echo -e \"TLS_IDENTITY\tLDAP Client\" >> /etc/openldap/ldap.conf' ")