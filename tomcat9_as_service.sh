#!/bin/bash
### Install Tomcat 9 + JRE on CentOS7
### http://www.ferhatdal.com

echo "TOMCAT9 AS A SERVICE"

yum -y  update
yum -y install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64
rpm -Uvh https://harbottle.gitlab.io/harbottle-main/7/x86_64/harbottle-main-release.rpm
xdotool key y
yum -y install tomcat9 && yum -y install tomcat9-admin-webapps && yum -y install tomcat9-docs-webapp && yum -y install tomcat9-native && yum -y install tomcat9-webapps
echo "=========================================================================="
systemctl start tomcat9
systemctl status tomcat9
systemctl enable tomcat9
echo "=========================================================================="
rm -rf /etc/tomcat9/tomcat-users.xml
touch /etc/tomcat9/tomcat-users.xml
echo "Setting Tomcat User" 
echo "DO NOT FORGET TO CHANGE PASSWD !!!"
echo "manager:manager passwd:manager"
echo "manager:admin passwd:admin"
echo ' limitations under the License.
-->
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<!--
  NOTE:  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary. It is
  strongly recommended that you do NOT use one of the users in the commented out
  section below since they are intended for use with the examples web
  application.
-->
<!--
  NOTE:  The sample user and role entries below are intended for use with the
  examples web application. They are wrapped in a comment and thus are ignored
  when reading this file. If you wish to configure these users for use with the
  examples web application, do not forget to remove the <!.. ..> that surrounds
  them. You will also need to set the passwords to something appropriate.
-->
<role rolename="manager-gui"/>
<user username="manager" password="manager" roles="manager-gui"/>

<role rolename="admin-gui"/>
<user username="admin" password="admin" roles="admin-gui"/>
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="<must-be-changed>" roles="tomcat"/>
  <user username="both" password="<must-be-changed>" roles="tomcat,role1"/>
  <user username="role1" password="<must-be-changed>" roles="role1"/>
-->
</tomcat-users>' >>/etc/tomcat9/tomcat-users.xml
echo "=========================================================================="
echo "Allowing Any IP For Access"
echo '<Context privileged="true" antiResourceLocking="false"
  docBase="${catalina.home}/webapps/manager">
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />
</Context>' >> /usr/share/tomcat9/webapps/host-manager/META-INF/context.xml

echo '<Context privileged="true" antiResourceLocking="false"
  docBase="${catalina.home}/webapps/manager">
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />
</Context>' >> /usr/share/tomcat9/webapps/manager/META-INF/context.xml
echo "==========================================================================="
echo "Updated Config for 250MB WAR Upload"
echo '<multipart-config>
  <max-file-size>262144000</max-file-size>
  <max-request-size>262144000</max-request-size>
  <file-size-threshold>0</file-size-threshold>
</multipart-config>' >> /usr/share/tomcat9/webapps/manager/WEB-INF/web.xml

systemctl restart tomcat9

echo "Checking Tomcat Service Socket tcp/8080"
netstat -antp | grep 8080

echo "COMPLETED!"

## Open in web browser:
## http://server_IP_address:8080
