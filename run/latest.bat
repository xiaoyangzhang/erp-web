cd /d %~dp0..
call mvn package -DskipTests

call autoconfig %~dp0..\target\erp-web.war -u %~dp0test.properties
@pause