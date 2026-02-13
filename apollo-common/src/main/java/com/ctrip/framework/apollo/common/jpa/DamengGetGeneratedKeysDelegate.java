/*
 * Copyright 2022 Apollo Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ctrip.framework.apollo.common.jpa;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.hibernate.dialect.Dialect;
import org.hibernate.dialect.identity.GetGeneratedKeysDelegate;
import org.hibernate.engine.spi.SharedSessionContractImplementor;
import org.hibernate.id.PostInsertIdentityPersister;

/**
 * Delegate for Dameng (DM8) to read generated identity from getGeneratedKeys() by column index.
 *
 * <p>Dameng's getGeneratedKeys() ResultSet may use a column label that does not match the entity
 * column name (e.g. "ID" vs "Id"), causing "无效的列" when Hibernate reads by name. This delegate
 * reads the generated key by index 1 instead.
 */
public class DamengGetGeneratedKeysDelegate extends GetGeneratedKeysDelegate {

  public DamengGetGeneratedKeysDelegate(PostInsertIdentityPersister persister, Dialect dialect) {
    super(persister, dialect);
  }

  @Override
  public Serializable executeAndExtract(PreparedStatement insert, SharedSessionContractImplementor session)
      throws SQLException {
    session.getJdbcCoordinator().getResultSetReturn().executeUpdate(insert);
    ResultSet rs = null;
    try {
      rs = insert.getGeneratedKeys();
      if (!rs.next()) {
        throw new SQLException("getGeneratedKeys() returned no row");
      }
      // Use the actual column name from getGeneratedKeys() ResultSet to avoid "无效的列"
      // (Dameng may return a different label than the entity column name "Id")
      ResultSetMetaData meta = rs.getMetaData();
      String columnLabel = meta.getColumnLabel(1);
      PostInsertIdentityPersister persister = (PostInsertIdentityPersister) getPersister();
      return (Serializable) persister.getIdentifierType().nullSafeGet(rs, columnLabel, session, null);
    } finally {
      if (rs != null) {
        session.getJdbcCoordinator().getLogicalConnection().getResourceRegistry().release(rs, insert);
      }
    }
  }
}
