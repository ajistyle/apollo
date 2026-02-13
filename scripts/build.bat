rem
rem Copyright 2022 Apollo Authors
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem
@echo off

rem apollo config db info (Dameng DM8)
set apollo_config_db_url="jdbc:dm://10.54.1.76:5236?SCHEMA=APOLLOCONFIGDB"
set apollo_config_db_username="SYSDBA"
set apollo_config_db_password="DMDBA_hust4400"

rem apollo portal db info (Dameng DM8)
set apollo_portal_db_url="jdbc:dm://10.54.1.76:5236?SCHEMA=APOLLOPORTALDB"
set apollo_portal_db_username="SYSDBA"
set apollo_portal_db_password="DMDBA_hust4400"

rem apollo runtime profile (Dameng: github,dm)
set apollo_profile_configdb=github,dm
set apollo_profile_portal=github,auth,dm

rem meta server url, different environments should have different meta server addresses
set dev_meta="http://localhost:8080"
set fat_meta="http://someIp:8080"
set uat_meta="http://anotherIp:8080"
set pro_meta="http://yetAnotherIp:8080"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=%apollo_profile_configdb% -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=%apollo_profile_portal% -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
