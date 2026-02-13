--
-- ApolloPortalDB schema for Dameng (DM8)
--
-- Notes:
-- - Execute this script in the target schema/user.
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
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Portal_App" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Portal_App_AppId_DeletedAt" UNIQUE ("AppId", "DeletedAt")
);
CREATE INDEX "IX_Portal_App_DataChange_LastTime" ON "App" ("DataChange_LastTime");
CREATE INDEX "IX_Portal_App_Name" ON "App" ("Name");


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
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Portal_AppNamespace" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Portal_AppNamespace_AppId_Name_DeletedAt" UNIQUE ("AppId", "Name", "DeletedAt")
);
CREATE INDEX "IX_Portal_AppNamespace_Name_AppId" ON "AppNamespace" ("Name", "AppId");
CREATE INDEX "IX_Portal_AppNamespace_DataChange_LastTime" ON "AppNamespace" ("DataChange_LastTime");


CREATE TABLE "Consumer" (
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
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Consumer" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Consumer_AppId_DeletedAt" UNIQUE ("AppId", "DeletedAt")
);
CREATE INDEX "IX_Consumer_DataChange_LastTime" ON "Consumer" ("DataChange_LastTime");


CREATE TABLE "ConsumerAudit" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ConsumerId" BIGINT NOT NULL DEFAULT 0,
  "Uri" VARCHAR(1024) NOT NULL DEFAULT '',
  "Method" VARCHAR(16) NOT NULL DEFAULT '',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  CONSTRAINT "PK_ConsumerAudit" PRIMARY KEY ("Id")
);
CREATE INDEX "IX_ConsumerAudit_ConsumerId" ON "ConsumerAudit" ("ConsumerId");


CREATE TABLE "ConsumerRole" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ConsumerId" BIGINT NOT NULL DEFAULT 0,
  "RoleId" BIGINT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_ConsumerRole" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_ConsumerRole_ConsumerId_RoleId_DeletedAt" UNIQUE ("ConsumerId", "RoleId", "DeletedAt")
);
CREATE INDEX "IX_ConsumerRole_DataChange_LastTime" ON "ConsumerRole" ("DataChange_LastTime");
CREATE INDEX "IX_ConsumerRole_RoleId" ON "ConsumerRole" ("RoleId");


CREATE TABLE "ConsumerToken" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "ConsumerId" BIGINT NOT NULL DEFAULT 0,
  "Token" VARCHAR(128) NOT NULL DEFAULT '',
  "Expires" TIMESTAMP,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_ConsumerToken" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_ConsumerToken_Token_DeletedAt" UNIQUE ("Token", "DeletedAt")
);
CREATE INDEX "IX_ConsumerToken_DataChange_LastTime" ON "ConsumerToken" ("DataChange_LastTime");
CREATE INDEX "IX_ConsumerToken_ConsumerId" ON "ConsumerToken" ("ConsumerId");


CREATE TABLE "Favorite" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "UserId" VARCHAR(128) NOT NULL DEFAULT '',
  "AppId" VARCHAR(500) NOT NULL DEFAULT 'default',
  "Position" INT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Favorite" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Favorite_UserId_AppId_DeletedAt" UNIQUE ("UserId", "AppId", "DeletedAt")
);
CREATE INDEX "IX_Favorite_DataChange_LastTime" ON "Favorite" ("DataChange_LastTime");
CREATE INDEX "IX_Favorite_AppId" ON "Favorite" ("AppId");


CREATE TABLE "Permission" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "PermissionType" VARCHAR(32) NOT NULL DEFAULT '',
  "TargetId" VARCHAR(256) NOT NULL DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Permission" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Permission_TargetId_Type_DeletedAt" UNIQUE ("TargetId", "PermissionType", "DeletedAt")
);
CREATE INDEX "IX_Permission_DataChange_LastTime" ON "Permission" ("DataChange_LastTime");


CREATE TABLE "Role" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "RoleName" VARCHAR(256) NOT NULL DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Role" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Role_RoleName_DeletedAt" UNIQUE ("RoleName", "DeletedAt")
);
CREATE INDEX "IX_Role_DataChange_LastTime" ON "Role" ("DataChange_LastTime");


CREATE TABLE "RolePermission" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "RoleId" BIGINT NOT NULL DEFAULT 0,
  "PermissionId" BIGINT NOT NULL DEFAULT 0,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_RolePermission" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_RolePermission_RoleId_PermissionId_DeletedAt" UNIQUE ("RoleId", "PermissionId", "DeletedAt")
);
CREATE INDEX "IX_RolePermission_DataChange_LastTime" ON "RolePermission" ("DataChange_LastTime");
CREATE INDEX "IX_RolePermission_PermissionId" ON "RolePermission" ("PermissionId");


CREATE TABLE "ServerConfig" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Key" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Value" VARCHAR(2048) NOT NULL DEFAULT 'default',
  "Comment" VARCHAR(1024) DEFAULT '',
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_Portal_ServerConfig" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Portal_ServerConfig_Key_DeletedAt" UNIQUE ("Key", "DeletedAt")
);
CREATE INDEX "IX_Portal_ServerConfig_DataChange_LastTime" ON "ServerConfig" ("DataChange_LastTime");


CREATE TABLE "UserRole" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "UserId" VARCHAR(128) DEFAULT '',
  "RoleId" BIGINT,
  "IsDeleted" SMALLINT NOT NULL DEFAULT 0,
  "DeletedAt" BIGINT NOT NULL DEFAULT 0,
  "DataChange_CreatedBy" VARCHAR(64) NOT NULL DEFAULT 'default',
  "DataChange_CreatedTime" TIMESTAMP NOT NULL,
  "DataChange_LastModifiedBy" VARCHAR(64) DEFAULT '',
  "DataChange_LastTime" TIMESTAMP,
  CONSTRAINT "PK_UserRole" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_UserRole_UserId_RoleId_DeletedAt" UNIQUE ("UserId", "RoleId", "DeletedAt")
);
CREATE INDEX "IX_UserRole_DataChange_LastTime" ON "UserRole" ("DataChange_LastTime");
CREATE INDEX "IX_UserRole_RoleId" ON "UserRole" ("RoleId");


CREATE TABLE "Users" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Username" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Password" VARCHAR(512) NOT NULL DEFAULT 'default',
  "UserDisplayName" VARCHAR(512) NOT NULL DEFAULT 'default',
  "Email" VARCHAR(64) NOT NULL DEFAULT 'default',
  "Enabled" SMALLINT,
  CONSTRAINT "PK_Users" PRIMARY KEY ("Id"),
  CONSTRAINT "UK_Users_Username" UNIQUE ("Username")
);


CREATE TABLE "Authorities" (
  "Id" BIGINT IDENTITY(1, 1) NOT NULL,
  "Username" VARCHAR(64) NOT NULL,
  "Authority" VARCHAR(50) NOT NULL,
  CONSTRAINT "PK_Authorities" PRIMARY KEY ("Id")
);


-- Initial configs
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('apollo.portal.envs', 'dev', '可支持的环境列表');
-- JSON 中双引号在达梦字符串内需写成 ""，否则会被当成标识符导致只存部分内容
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('organizations', '[{""orgId"":""TEST1"",""orgName"":""样例部门1""},{""orgId"":""TEST2"",""orgName"":""样例部门2""}]', '部门列表');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('superAdmin', 'apollo', 'Portal超级管理员');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('api.readTimeout', '10000', 'http接口read timeout');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('consumer.token.salt', 'someSalt', 'consumer token salt');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('admin.createPrivateNamespace.switch', 'true', '是否允许项目管理员创建私有namespace');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('configView.memberOnly.envs', 'pro', '只对项目成员显示配置信息的环境列表，多个env以英文逗号分隔');
INSERT INTO "ServerConfig" ("Key", "Value", "Comment")
VALUES ('apollo.portal.meta.servers', '{}', '各环境Meta Service列表');

INSERT INTO "Users" ("Username", "Password", "UserDisplayName", "Email", "Enabled")
VALUES ('apollo', '$2a$10$7r20uS.BQ9uBpf3Baj3uQOZvMVvB1RN3PYoKE94gtz2.WAOuiiwXS', 'apollo', 'apollo@acme.com', 1);

INSERT INTO "Authorities" ("Username", "Authority") VALUES ('apollo', 'ROLE_user');


-- Spring Session (JDBC), required by Portal (spring.session.store-type=jdbc)
CREATE TABLE SPRING_SESSION (
  PRIMARY_ID CHAR(36) NOT NULL,
  SESSION_ID CHAR(36) NOT NULL,
  CREATION_TIME BIGINT NOT NULL,
  LAST_ACCESS_TIME BIGINT NOT NULL,
  MAX_INACTIVE_INTERVAL INT NOT NULL,
  EXPIRY_TIME BIGINT NOT NULL,
  PRINCIPAL_NAME VARCHAR(100),
  CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (PRIMARY_ID)
);
CREATE UNIQUE INDEX SPRING_SESSION_IX1 ON SPRING_SESSION (SESSION_ID);
CREATE INDEX SPRING_SESSION_IX2 ON SPRING_SESSION (EXPIRY_TIME);
CREATE INDEX SPRING_SESSION_IX3 ON SPRING_SESSION (PRINCIPAL_NAME);

CREATE TABLE SPRING_SESSION_ATTRIBUTES (
  SESSION_PRIMARY_ID CHAR(36) NOT NULL,
  ATTRIBUTE_NAME VARCHAR(200) NOT NULL,
  ATTRIBUTE_BYTES BLOB NOT NULL,
  CONSTRAINT SPRING_SESSION_ATTRIBUTES_PK PRIMARY KEY (SESSION_PRIMARY_ID, ATTRIBUTE_NAME),
  CONSTRAINT SPRING_SESSION_ATTRIBUTES_FK FOREIGN KEY (SESSION_PRIMARY_ID)
    REFERENCES SPRING_SESSION(PRIMARY_ID) ON DELETE CASCADE
);

