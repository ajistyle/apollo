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

import org.hibernate.dialect.Oracle12cDialect;
import org.hibernate.dialect.identity.IdentityColumnSupport;

/**
 * Hibernate dialect for Dameng (DM8).
 *
 * <p>Extends Oracle12cDialect so that pagination uses OFFSET ... FETCH NEXT ... ROWS ONLY
 * (SQL standard), which DM8 supports. Apollo uses manually maintained SQL scripts for schema.
 *
 * <p>Uses DamengIdentityColumnSupport so that INSERT does not include the identity column
 * (Dameng does not allow DEFAULT as explicit value for IDENTITY columns).
 */
public class DamengDialect extends Oracle12cDialect {

  @Override
  public IdentityColumnSupport getIdentityColumnSupport() {
    return new DamengIdentityColumnSupport();
  }
}

