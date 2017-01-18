cd /d %~dp0..
call mvn package -DskipTests

call autoconfig %~dp0..\target\ROOT.war -u %~dp0erpweb.prod.properties
@pause