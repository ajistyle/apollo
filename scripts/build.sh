#!/bin/sh
#
# Copyright 2022 Apollo Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# use Java from JAVA_HOME if set (e.g. JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home)
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  PATH="$JAVA_HOME/bin:$PATH"
fi
# use Maven from M2_HOME if set (e.g. M2_HOME=/Users/zhuji/work/apps/apache-maven-3.9.9)
if [ -n "$M2_HOME" ] && [ -x "$M2_HOME/bin/mvn" ]; then
  PATH="$M2_HOME/bin:$PATH"
fi

# apollo config db info (Dameng DM8)
apollo_config_db_url='jdbc:dm://10.54.1.76:5236?SCHEMA=APOLLOCONFIGDB'
apollo_config_db_username='SYSDBA'
apollo_config_db_password='DMDBA_hust4400'

# apollo portal db info (Dameng DM8)
apollo_portal_db_url='jdbc:dm://10.54.1.76:5236?SCHEMA=APOLLOPORTALDB'
apollo_portal_db_username='SYSDBA'
apollo_portal_db_password='DMDBA_hust4400'

# apollo runtime profile
# - for MySQL: github (or github,auth)
# - for Dameng: github,dm (or github,auth,dm)
apollo_profile_configdb='github,dm'
apollo_profile_portal='github,auth,dm'

# meta server url, different environments should have different meta server addresses
dev_meta=http://fill-in-dev-meta-server:8080
fat_meta=http://fill-in-fat-meta-server:8080
uat_meta=http://fill-in-uat-meta-server:8080
pro_meta=http://fill-in-pro-meta-server:8080

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}" || exit 

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=$apollo_profile_configdb -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=$apollo_profile_portal -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="
