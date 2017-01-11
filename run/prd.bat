cd /d %~dp0..
call mvn package -DskipTests

call autoconfig %~dp0..\target\erpresource-web.war -u %~dp0prd.properties
@pause