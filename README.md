# Google LDAPs Project for macOS

## File Structure
The PKG must be constructed with the following file/folder structure:
usr
|_ local
   |_ GoogleLDAPS
      |_ ldap.google.com.plist
      |_ ldap_pythong_config.py

The PKG must contain a Postinstall Script with the contents of the file googleSLDAPmacOS.sh
and copy the two files listed above.
Use your preferred PKG builder software.

## Some Explainations
### Additional Softwares
Once the PKG is built, some additional software needs to be downloaded and deployed. 
Please Provide this installers to all clients before deploying this package:
- XCode Command Line Tools (https://developer.apple.com/download/all/)
- MacAdmins Python (https://github.com/macadmins/python/releases/tag/v3.9.10.02082022223633)
 This is a replacement planned for when Apple removes /usr/bin/python (which will happen 
 with the release of macOS 12.3 in spring 2022).

### Certificate distribution
Before Deploying the Custom PKG, please check that the Google Certificate has been 
installed on the client, using a mobileconfig profile. In this repo there is an example.
Before importing the certificate in the Profile, be sure to Convert the key and cert into 
a PKCS 12 (p12) file. Run the following command in the terminal:

openssl pkcs12 -export -out ldap-client.p12 -in ldap-client.crt -inkey ldap-client.keye" data.

### Script behavior
The googleSLDAPmacOS.sh script contained in the PKG that you built earlier is intended to 
check if XCode and Python are installed.
If Python is not installed, it stops the setup process.
If Command Line Tools are not installed, it proposes a pop-up that is closed as soon as 
the installation finishes.
Some User Interaction are in Italian Language, so, please be free to customize it.

When the process is completed, the computer will reboot automatically in 1 minute.

You will then be able to find the files in the path indicated above and the LDAP 
configuration working, which you can verify from the macOS Users and Groups settings.

## Final Consideration
For a better experience, maybe you can customize your client to show user and password at login page and, 
bypass all user creation customisation process
You can then remove all files at /usr/local/GoogleLDAPS path in all clients