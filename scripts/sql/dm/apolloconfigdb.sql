ALTER SESSION SET CURRENT_SCHEMA = APOLLOCONFIGDB;

--
-- ApolloConfigDB schema for Dameng (DM8)
--
-- Notes:
-- - Execute this script in the target schema/user (e.g. SYSDBA or a dedicated user).
-- - Apollo uses quoted identifiers (globally_quoted_identifiers=true), so keep table/column names in the exact case.
--

CREATE TABLE "App" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Name" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OrgId" VARCHAR(32) NOT NULL DEFAULT 'default',
  "OrgName" VARCHAR(64) NOT NULL DEFAULT 'default',
  "OwnerName" VARCHAR(500) NOT NULL DEFAULT 'default',
  "OwnerEmail" VARCHAR(500) NOT NULL DEFAULT 'default',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_App" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_App_AppId_DeletedAt" UNIQUE ("AppId", "DeletedAt")
);
CREATE INDEX "IX_App_DataChange_LastTime" ON "App" ("DataChange_LastTime");
CREATE INDEX "IX_App_Name" ON "App" ("Name");


CREATE TABLE "AppNamespace" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Name" VARCHAR(32) NOT NULL DEFAULT '',
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "Format" VARCHAR(32) NOT NULL DEFAULT 'properties',
  "IsPublic" SMALLINT NOT NULL DEFAULT 0,
  "Comment" VARCHAR(64) NOT NULL DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_AppNamespace" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_AppNamespace_AppId_Name_DeletedAt" UNIQUE ("AppId", "Name", "DeletedAt")
);
CREATE INDEX "IX_AppNamespace_Name_AppId" ON "AppNamespace" ("Name", "AppId");
CREATE INDEX "IX_AppNamespace_DataChange_LastTime" ON "AppNamespace" ("DataChange_LastTime");


CREATE TABLE "Audit" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "EntityName" VARCHAR(50) NOT NULL DEFAULT 'default',
  "EntityId" BIGINT,
  "OpName" VARCHAR(50) NOT NULL DEFAULT 'default',
  "Comment" VARCHAR(500),
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Audit" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_Audit_DataChange_LastTime" ON "Audit" ("DataChange_LastTime");


CREATE TABLE "Cluster" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Name" VARCHAR(32) NOT NULL DEFAULT '',
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ParentClusterId" BIGINT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Cluster" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Cluster_AppId_Name_DeletedAt" UNIQUE ("AppId", "Name", "DeletedAt")
);
CREATE INDEX "IX_Cluster_DataChange_LastTime" ON "Cluster" ("DataChange_LastTime");


CREATE TABLE "Commit" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ChangeSets" CLOB NOT NULL,
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "NamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "Comment" VARCHAR(500),
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Commit" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_Commit_AppId" ON "Commit" ("AppId");
CREATE INDEX "IX_Commit_DataChange_LastTime" ON "Commit" ("DataChange_LastTime");


CREATE TABLE "GrayReleaseRule" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "NamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "BranchName" VARCHAR(32) NOT NULL DEFAULT '',
  "Rules" VARCHAR(16000),
  "ReleaseId" BIGINT NOT NULL DEFAULT 0,
  "BranchStatus" INT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_GrayReleaseRule" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_GrayReleaseRule_DataChange_LastTime" ON "GrayReleaseRule" ("DataChange_LastTime");


CREATE TABLE "Instance" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "DataCenter" VARCHAR(64) NOT NULL DEFAULT '',
  "Ip" VARCHAR(32) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastTime" TIMESTAMP NOT NULL,
  CONSTRAINT "PK_Instance" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_Instance_DataChange_LastTime" ON "Instance" ("DataChange_LastTime");
CREATE UNIQUE INDEX "IX_UNIQUE_KEY_Instance" ON "Instance" ("AppId", "ClusterName", "Ip", "DataCenter");


CREATE TABLE "InstanceConfig" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "InstanceId" BIGINT NOT NULL,
  "ConfigAppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ConfigClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "ConfigNamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "ReleaseKey" VARCHAR(64) NOT NULL DEFAULT '',
  "ReleaseDeliveryTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  CONSTRAINT "PK_InstanceConfig" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_InstanceConfig_DataChange_LastTime" ON "InstanceConfig" ("DataChange_LastTime");
CREATE INDEX "IX_InstanceConfig_InstanceId" ON "InstanceConfig" ("InstanceId");
CREATE UNIQUE INDEX "IX_UNIQUE_KEY_InstanceConfig" ON "InstanceConfig" ("InstanceId", "ConfigAppId", "ConfigClusterName", "ConfigNamespaceName");


CREATE TABLE "Item" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "NamespaceId" BIGINT NOT NULL DEFAULT 0,
  "Key" VARCHAR(128) NOT NULL DEFAULT '',
  "Type" INT NOT NULL DEFAULT 0,
  "Value" CLOB NOT NULL,
  "Comment" VARCHAR(1024),
  "LineNum" INT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Item" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_Item_NamespaceId" ON "Item" ("NamespaceId");
CREATE INDEX "IX_Item_DataChange_LastTime" ON "Item" ("DataChange_LastTime");
CREATE UNIQUE INDEX "UK_Item_NamespaceId_Key_DeletedAt" ON "Item" ("NamespaceId", "Key", "DeletedAt");


CREATE TABLE "Namespace" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "NamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Namespace" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Namespace_AppId_ClusterName_NamespaceName_DeletedAt" UNIQUE ("AppId", "ClusterName", "NamespaceName", "DeletedAt")
);
CREATE INDEX "IX_Namespace_DataChange_LastTime" ON "Namespace" ("DataChange_LastTime");


CREATE TABLE "NamespaceLock" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "NamespaceId" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  CONSTRAINT "PK_NamespaceLock" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_NamespaceLock_NamespaceId_DeletedAt" UNIQUE ("NamespaceId", "DeletedAt")
);
CREATE INDEX "IX_NamespaceLock_DataChange_LastTime" ON "NamespaceLock" ("DataChange_LastTime");


CREATE TABLE "Release" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ReleaseKey" VARCHAR(64) NOT NULL DEFAULT '',
  "Name" VARCHAR(64) NOT NULL DEFAULT '',
  "Comment" VARCHAR(256),
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "NamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "Configurations" CLOB NOT NULL,
  "IsAbandoned" SMALLINT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Release" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Release_ReleaseKey_DeletedAt" UNIQUE ("ReleaseKey", "DeletedAt")
);
CREATE INDEX "IX_Release_Namespace" ON "Release" ("AppId", "ClusterName", "NamespaceName");
CREATE INDEX "IX_Release_DataChange_LastTime" ON "Release" ("DataChange_LastTime");


CREATE TABLE "ReleaseHistory" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(64) NOT NULL DEFAULT '',
  "ClusterName" VARCHAR(32) NOT NULL DEFAULT '',
  "NamespaceName" VARCHAR(32) NOT NULL DEFAULT '',
  "BranchName" VARCHAR(32) NOT NULL DEFAULT 'default',
  "ReleaseId" BIGINT NOT NULL DEFAULT 0,
  "PreviousReleaseId" BIGINT NOT NULL DEFAULT 0,
  "Operation" INT NOT NULL DEFAULT 0,
  "OperationContext" CLOB NOT NULL,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_ReleaseHistory" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_ReleaseHistory_Namespace" ON "ReleaseHistory" ("AppId", "ClusterName", "NamespaceName", "BranchName");
CREATE INDEX "IX_ReleaseHistory_ReleaseId" ON "ReleaseHistory" ("ReleaseId");
CREATE INDEX "IX_ReleaseHistory_PreviousReleaseId" ON "ReleaseHistory" ("PreviousReleaseId");
CREATE INDEX "IX_ReleaseHistory_DataChange_LastTime" ON "ReleaseHistory" ("DataChange_LastTime");


CREATE TABLE "ReleaseMessage" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Message" VARCHAR(1024) NOT NULL DEFAULT '',
  "DataChange_LastTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  CONSTRAINT "PK_ReleaseMessage" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_ReleaseMessage_DataChange_LastTime" ON "ReleaseMessage" ("DataChange_LastTime");
CREATE INDEX "IX_ReleaseMessage_Message" ON "ReleaseMessage" ("Message");


CREATE TABLE "ServerConfig" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Key" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Cluster" VARCHAR(32) NOT NULL DEFAULT 'default',
  "Value" VARCHAR(2048) NOT NULL DEFAULT 'default',
  "Comment" VARCHAR(1024) DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_ServerConfig" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_ServerConfig_Key_Cluster_DeletedAt" UNIQUE ("Key", "Cluster", "DeletedAt")
);
CREATE INDEX "IX_ServerConfig_DataChange_LastTime" ON "ServerConfig" ("DataChange_LastTime");


CREATE TABLE "AccessKey" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Secret" VARCHAR(128) NOT NULL DEFAULT '',
  "IsEnabled" SMALLINT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP NOT NULL,
  CONSTRAINT "PK_AccessKey" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_AccessKey_AppId_Secret_DeletedAt" UNIQUE ("AppId", "Secret", "DeletedAt")
);
CREATE INDEX "IX_AccessKey_DataChange_LastTime" ON "AccessKey" ("DataChange_LastTime");


CREATE TABLE "ServiceRegistry" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ServiceName" VARCHAR(64) NOT NULL,
  "Uri" VARCHAR(64) NOT NULL,
  "Cluster" VARCHAR(64) NOT NULL,
  "Metadata" VARCHAR(1024) NOT NULL DEFAULT '{}',
  "DataChange_CreatedTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  "DataChange_LastTime" TIMESTAMP  NOT NULL DEFAULT SYSDATE,
  CONSTRAINT "PK_ServiceRegistry" PRIMARY KEY ("Id")
);
CREATE UNIQUE INDEX "IX_UNIQUE_KEY_ServiceRegistry" ON "ServiceRegistry" ("ServiceName", "Uri");
CREATE INDEX "IX_ServiceRegistry_DataChange_LastTime" ON "ServiceRegistry" ("DataChange_LastTime");


-- Initial configs
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES ('eureka.service.url', 'default', 'http://localhost:8080/eureka/', 'Eureka服务Url，多个service以英文逗号分隔');
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES ('namespace.lock.switch', 'default', 'false', '一次发布只能有一个人修改开关');
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES ('item.key.length.limit', 'default', '128', 'item key 最大长度限制');
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES ('item.value.length.limit', 'default', '20000', 'item value最大长度限制');
INSERT INTO "ServerConfig" ("Key", "Cluster", "Value", "Comment")
VALUES ('config-service.cache.enabled', 'default', 'false', 'ConfigService是否开启缓存，开启后能提高性能，但是会增大内存消耗！');
