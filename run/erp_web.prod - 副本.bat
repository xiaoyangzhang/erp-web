cd /d %~dp0..
call mvn package -DskipTests

call autoconfig %~dp0..\target\ROOT.war -u %~dp0erp_web.prod.properties
@pause