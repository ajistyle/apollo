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

import org.hibernate.dialect.Dialect;
import org.hibernate.dialect.identity.GetGeneratedKeysDelegate;
import org.hibernate.dialect.identity.Oracle12cIdentityColumnSupport;
import org.hibernate.id.PostInsertIdentityPersister;

/**
 * Identity column support for Dameng (DM8).
 *
 * <p>Dameng does not allow "DEFAULT" as explicit value for IDENTITY columns
 * (error -2871: DEFAULT不允许作为显式标识值). Return null from getIdentityInsertString()
 * so Hibernate omits the identity column from INSERT and uses getGeneratedKeys
 * to retrieve the generated value.
 *
 * <p>Dameng's getGeneratedKeys() ResultSet may use a column label that causes
 * "无效的列" when Hibernate reads by entity column name; we use DamengGetGeneratedKeysDelegate
 * to read by index 1 instead.
 */
public class DamengIdentityColumnSupport extends Oracle12cIdentityColumnSupport {

  @Override
  public String getIdentityInsertString() {
    return null;
  }

  @Override
  public GetGeneratedKeysDelegate buildGetGeneratedKeysDelegate(
      PostInsertIdentityPersister persister, Dialect dialect) {
    return new DamengGetGeneratedKeysDelegate(persister, dialect);
  }
}
