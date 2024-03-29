#!/bin/sh

############################################################################################################
# Use this script at your own risk.
# This script can be used as a postinstall script in a pkg created using your preferred software
# 
# Before Deploying this Script, please check that the Google Certificate has been installed on the client
# If not created, Create a Mac Profile with the P12 certificate. (look at the Google KB site)
# To convert the certificate and key files in P12, execute the following example command
# openssl pkcs12 -export -out ldap-client.p12 -in ldap-client.crt -inkey ldap-client.key
############################################################################################################

# Script default path
pathDir="/usr/local/GooogleLDAPS"

# Log Settings
filename="gldapsinstall"
now=$(date +'%m-%d-%Y-%T')
dateSub=$(echo "$now" | sed 's/-//g' | sed 's/://g')
logFile="$pathDir""/$filename""_""$dateSub.log"
if [ ! -e "$logFile" ]; then
	touch "$logFile"
fi

#######################
#    Do all checks    #
#######################
echo "############ SCRIPT STARTED #############" >> $logFile
echo "$now Starting the PostInstall Script and doing all Pre-Cheks" >> $logFile

# Create the Directory config file (plist) xml 
#checks if the ldap.google.com.plist file exists and if not, it creates one
plistPath="$pathDir/ldap.google.com.plist"
if [ -e "$plistPath" ];then
	echo "$now ldap Plist File Still exists. The process will move on." >> $logFile
	sudo plutil -convert xml1 $plistPath
else
	echo "$now Plist File does not exists. Creating one"  >> $logFile
	mkdir $pathDir
	tee > $plistPath << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>description</key>
	<string>ldap.google.com</string>
	<key>mappings</key>
	<dict>
		<key>attributes</key>
		<array>
			<string>objectClass</string>
		</array>
		<key>function</key>
		<string>ldap:translate_recordtype</string>
		<key>recordtypes</key>
		<dict>
			<key>dsRecTypeStandard:Automount</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:AutomountInformation</key>
					<dict>
						<key>native</key>
						<string>automountInformation</string>
					</dict>
					<key>dsAttrTypeStandard:Comment</key>
					<dict>
						<key>native</key>
						<string>description</string>
					</dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>automountKey</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>automount</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:AutomountMap</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:Comment</key>
					<dict>
						<key>native</key>
						<string>description</string>
					</dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>automountMapName</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>automountMap</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:CertificateAuthorities</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:AuthorityRevocationList</key>
					<dict>
						<key>native</key>
						<string>authorityRevocationList;binary</string>
					</dict>
					<key>dsAttrTypeStandard:CACertificate</key>
					<dict>
						<key>native</key>
						<string>cACertificate;binary</string>
					</dict>
					<key>dsAttrTypeStandard:CertificateRevocationList</key>
					<dict>
						<key>native</key>
						<string>certificateRevocationList;binary</string>
					</dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:CrossCertificatePair</key>
					<dict>
						<key>native</key>
						<string>crossCertificatePair;binary</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>certificationAuthority</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:Groups</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:GroupMembership</key>
					<dict>
						<key>native</key>
						<string>memberUid</string>
					</dict>
					<key>dsAttrTypeStandard:Member</key>
					<dict>
						<key>native</key>
						<string>memberUid</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:PrimaryGroupID</key>
					<dict>
						<key>native</key>
						<string>gidNumber</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>posixGroup</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:Mounts</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
					<key>dsAttrTypeStandard:VFSDumpFreq</key>
					<dict>
						<key>native</key>
						<string>mountDumpFrequency</string>
					</dict>
					<key>dsAttrTypeStandard:VFSLinkDir</key>
					<dict>
						<key>native</key>
						<string>mountDirectory</string>
					</dict>
					<key>dsAttrTypeStandard:VFSOpts</key>
					<dict>
						<key>native</key>
						<string>mountOption</string>
					</dict>
					<key>dsAttrTypeStandard:VFSPassNo</key>
					<dict>
						<key>native</key>
						<string>mountPassNo</string>
					</dict>
					<key>dsAttrTypeStandard:VFSType</key>
					<dict>
						<key>native</key>
						<string>mountType</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>mount</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:OrganizationalUnit</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:AddressLine1</key>
					<dict>
						<key>native</key>
						<string>street</string>
					</dict>
					<key>dsAttrTypeStandard:City</key>
					<dict>
						<key>native</key>
						<string>l</string>
					</dict>
					<key>dsAttrTypeStandard:Comment</key>
					<dict>
						<key>native</key>
						<string>description</string>
					</dict>
					<key>dsAttrTypeStandard:Country</key>
					<dict>
						<key>native</key>
						<string>c</string>
					</dict>
					<key>dsAttrTypeStandard:FAXNumber</key>
					<dict>
						<key>native</key>
						<string>facsimileTelephoneNumber</string>
					</dict>
					<key>dsAttrTypeStandard:Password</key>
					<dict>
						<key>native</key>
						<string>userPassword</string>
					</dict>
					<key>dsAttrTypeStandard:PhoneNumber</key>
					<dict>
						<key>native</key>
						<string>telephoneNumber</string>
					</dict>
					<key>dsAttrTypeStandard:PostalAddress</key>
					<dict>
						<key>native</key>
						<string>postalAddress</string>
					</dict>
					<key>dsAttrTypeStandard:PostalCode</key>
					<dict>
						<key>native</key>
						<string>postalCode</string>
					</dict>
					<key>dsAttrTypeStandard:RealName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>ou</string>
					</dict>
					<key>dsAttrTypeStandard:State</key>
					<dict>
						<key>native</key>
						<string>st</string>
					</dict>
					<key>dsAttrTypeStandard:Street</key>
					<dict>
						<key>native</key>
						<string>street</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>organizationalUnit</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:People</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:AddressLine1</key>
					<dict>
						<key>native</key>
						<string>street</string>
					</dict>
					<key>dsAttrTypeStandard:Building</key>
					<dict>
						<key>native</key>
						<string>buildingName</string>
					</dict>
					<key>dsAttrTypeStandard:City</key>
					<dict>
						<key>native</key>
						<string>l</string>
					</dict>
					<key>dsAttrTypeStandard:Country</key>
					<dict>
						<key>native</key>
						<string>c</string>
					</dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:Department</key>
					<dict>
						<key>native</key>
						<string>departmentNumber</string>
					</dict>
					<key>dsAttrTypeStandard:EMailAddress</key>
					<dict>
						<key>native</key>
						<string>mail</string>
					</dict>
					<key>dsAttrTypeStandard:FAXNumber</key>
					<dict>
						<key>native</key>
						<string>facsimileTelephoneNumber</string>
					</dict>
					<key>dsAttrTypeStandard:FirstName</key>
					<dict>
						<key>native</key>
						<string>givenName</string>
					</dict>
					<key>dsAttrTypeStandard:HomePhoneNumber</key>
					<dict>
						<key>native</key>
						<string>homePhone</string>
					</dict>
					<key>dsAttrTypeStandard:JobTitle</key>
					<dict>
						<key>native</key>
						<string>title</string>
					</dict>
					<key>dsAttrTypeStandard:LastName</key>
					<dict>
						<key>native</key>
						<string>sn</string>
					</dict>
					<key>dsAttrTypeStandard:MobileNumber</key>
					<dict>
						<key>native</key>
						<string>mobile</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:OrganizationName</key>
					<dict>
						<key>native</key>
						<string>o</string>
					</dict>
					<key>dsAttrTypeStandard:PagerNumber</key>
					<dict>
						<key>native</key>
						<string>pager</string>
					</dict>
					<key>dsAttrTypeStandard:PhoneNumber</key>
					<dict>
						<key>native</key>
						<string>telephoneNumber</string>
					</dict>
					<key>dsAttrTypeStandard:PostalAddress</key>
					<dict>
						<key>native</key>
						<string>postalAddress</string>
					</dict>
					<key>dsAttrTypeStandard:PostalCode</key>
					<dict>
						<key>native</key>
						<string>postalCode</string>
					</dict>
					<key>dsAttrTypeStandard:RealName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
					<key>dsAttrTypeStandard:State</key>
					<dict>
						<key>native</key>
						<string>st</string>
					</dict>
					<key>dsAttrTypeStandard:Street</key>
					<dict>
						<key>native</key>
						<string>street</string>
					</dict>
					<key>dsAttrTypeStandard:UserCertificate</key>
					<dict>
						<key>native</key>
						<string>userCertificate;binary</string>
					</dict>
					<key>dsAttrTypeStandard:UserPKCS12Data</key>
					<dict>
						<key>native</key>
						<string>userPKCS12</string>
					</dict>
					<key>dsAttrTypeStandard:UserSMIMECertificate</key>
					<dict>
						<key>native</key>
						<string>userSMIMECertificate</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>inetOrgPerson</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
			<key>dsRecTypeStandard:Users</key>
			<dict>
				<key>attributetypes</key>
				<dict>
					<key>dsAttrTypeStandard:Change</key>
					<dict>
						<key>native</key>
						<string>shadowLastChange</string>
					</dict>
					<key>dsAttrTypeStandard:Comment</key>
					<dict>
						<key>native</key>
						<string>description</string>
					</dict>
					<key>dsAttrTypeStandard:CreationTimestamp</key>
					<dict>
						<key>native</key>
						<string>createTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:Expire</key>
					<dict>
						<key>native</key>
						<string>shadowExpire</string>
					</dict>
					<key>dsAttrTypeStandard:GeneratedUID</key>
					<dict>
						<key>native</key>
						<string>apple-generateduid</string>
					</dict>
					<key>dsAttrTypeStandard:ModificationTimestamp</key>
					<dict>
						<key>native</key>
						<string>modifyTimestamp</string>
					</dict>
					<key>dsAttrTypeStandard:NFSHomeDirectory</key>
					<dict>
						<key>native</key>
						<string>#/Users/$uid$</string>
					</dict>
					<key>dsAttrTypeStandard:Password</key>
					<dict>
						<key>native</key>
						<string>userPassword</string>
					</dict>
					<key>dsAttrTypeStandard:PrimaryGroupID</key>
					<dict>
						<key>native</key>
						<string>gidNumber</string>
					</dict>
					<key>dsAttrTypeStandard:RealName</key>
					<dict>
						<key>native</key>
						<string>cn</string>
					</dict>
					<key>dsAttrTypeStandard:RecordName</key>
					<dict>
						<key>native</key>
						<string>uid</string>
					</dict>
					<key>dsAttrTypeStandard:UniqueID</key>
					<dict>
						<key>native</key>
						<string>uidNumber</string>
					</dict>
					<key>dsAttrTypeStandard:UserShell</key>
					<dict>
						<key>native</key>
						<string>loginShell</string>
					</dict>
				</dict>
				<key>info</key>
				<dict>
					<key>Group Object Classes</key>
					<string>OR</string>
					<key>Object Classes</key>
					<array>
						<string>posixAccount</string>
						<string>inetOrgPerson</string>
						<string>shadowAccount</string>
					</array>
					<key>Search Base</key>
					<string>dc=volta-alessandria,dc=it</string>
				</dict>
			</dict>
		</dict>
	</dict>
	<key>module options</key>
	<dict>
		<key>AppleODClient</key>
		<dict>
			<key>Server Mappings</key>
			<false/>
		</dict>
		<key>ldap</key>
		<dict>
			<key>Denied SASL Methods</key>
			<array>
				<string>DIGEST-MD5</string>
			</array>
			<key>Template Search Base Suffix</key>
			<string>dc=volta-alessandria,dc=it</string>
		</dict>
	</dict>
	<key>node name</key>
	<string>/LDAPv3/ldap.google.com</string>
	<key>options</key>
	<dict>
		<key>connection idle disconnect</key>
		<integer>120</integer>
		<key>destination</key>
		<dict>
			<key>host</key>
			<string>ldap.google.com</string>
			<key>other</key>
			<string>ldaps</string>
			<key>port</key>
			<integer>636</integer>
		</dict>
		<key>man-in-the-middle</key>
		<false/>
		<key>no cleartext authentication</key>
		<false/>
		<key>packet encryption</key>
		<integer>3</integer>
		<key>packet signing</key>
		<integer>1</integer>
	</dict>
	<key>template</key>
	<string>LDAPv3</string>
	<key>trusttype</key>
	<string>anonymous</string>
	<key>uuid</key>
	<string>BD5636C5-C3F1-431F-8400-32AD662F9069</string>
</dict>
</plist>
	
EOF
fi

# Checks if the Python Script exists
pythonPath="$pathDir/Ldap_pythong_config.py"
if [ -e "$pythonPath" ];then
	echo "$now Python Script File Still exists. The process will move on." >> $logFile
else
	# Create a python script to automate the configuration on your end-user devices
	echo "$now Python Script does not exist. Creating one." >> $logFile
	tee > $pythonPath << EOF
#!/usr/bin/python
from OpenDirectory import ODNode, ODSession, kODNodeTypeConfigure
from Foundation import NSMutableData, NSData

import os
import sys

# Reading plist
GOOGLELDAPCONFIGFILE = open(sys.argv[1], "r")
CONFIG = GOOGLELDAPCONFIGFILE.read()
GOOGLELDAPCONFIGFILE.close()

# Write the plist
od_session = ODSession.defaultSession()
od_conf_node, err = ODNode.nodeWithSession_type_error_(od_session, kODNodeTypeConfigure, None)
request = NSMutableData.dataWithBytes_length_(b'\x00'*32, 32)
request.appendData_(NSData.dataWithBytes_length_(CONFIG, len(CONFIG)))
response, err = od_conf_node.customCall_sendData_error_(99991, request, None)

# Edit the default search path and append the new node to allow for login
os.system("dscl -q localhost -append /Search CSPSearchPath /LDAPv3/ldap.google.com")
os.system("bash -c 'echo -e \"TLS_IDENTITY\tLDAP Client\" >> /etc/openldap/ldap.conf' ")
EOF
	chmod 600 "$pythonPath"
	chown "root":wheel "$pythonPath"
	chmod +x "$pythonPath"
fi

# Checks if Python3 Is installed on the system
pythonBin="/usr/local/bin/managed_python3"
if [ -e "$pythonBin" ];then
	echo "Python Still Installed. The process will move on."
	sudo python3 -m pip install pyobjc-framework-opendirectory
else
	echo "$now Python not installed. Exiting the Script." >> $logFile
	echo "############ SCRIPT ENDED #############"
	echo ""
	osascript << EOF
tell application "System Events" to display dialog "Python not Installed." with title "Avviso" buttons {"OK"} default button 1 with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns"
EOF
	exit 1
fi

###################################
# Auto configure end-user devices #
###################################
# Check First if XCode is already installed.

xcode-select --install > /dev/null 2>&1
if [ 0 == $? ]; then
    # sleep 1
    echo "$now Command Line Developer Tools is not Installed. Proceeding with System Event Notification." >> $logFile
    osascript <<EOF
tell application "System Events"
    tell process "Install Command Line Developer Tools"
        keystroke return
        click button "Agree" of window "License Agreement"
    end tell
end tell
EOF
else
    echo "Command Line Developer Tools are already installed!"
    echo "$now Proceeding with the LDAP configuration Install" >> $logFile
	# Runs the ldap configuration
	sudo python3 $pythonPath $plistPath
	echo "$now Python Script Executed. Now Rebooting." >> $logFile
	echo "############ SCRIPT ENDED #############" >> $logFile
	echo "" >> $logFile
	sudo shutdown -r +1
	osascript << EOF
tell application "System Events" to display dialog "La configurazione per LDAPs di Google è stata installata. Il computer si riavvierà entro 1 minuto." with title "Avviso" buttons {"OK"} default button 1 with icon POSIX file "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns"
EOF
fi

# exit 0		## Success
# exit 1		## Failure