/**
 * @name Conflicting Access to Field
 * @description Finds fields accessed outside of locks, ignoring initializers and constructors.
 * @kind problem
 * @id csharp/architectural/conflicting-access-fixed
 */

import csharp

from Field field, Access protectedAccess, Access unprotectedAccess, LockStmt lock
where
    protectedAccess.getTarget() = field and
    unprotectedAccess.getTarget() = field and
    field.fromSource() and
    
    // 1. One access is inside a lock
    protectedAccess.getEnclosingStmt().getParent+() = lock and
    
    // 2. The other access is NOT inside any lock
    not exists(LockStmt otherLock | 
        unprotectedAccess.getEnclosingStmt().getParent+() = otherLock
    ) and
    
    // 3. EXCLUDE the field declaration/initializer itself
    // In CodeQL, we check if the access is the field's own initializer expression
    not unprotectedAccess = field.getInitializer().getAChild*() and

    // 4. EXCLUDE accesses inside Constructors
    not unprotectedAccess.getEnclosingCallable() instanceof Constructor and
    
    protectedAccess != unprotectedAccess
select 
    unprotectedAccess, 
    "This access to '" + field.getName() + "' is not locked, but it is locked elsewhere in " + 
    protectedAccess.getEnclosingCallable().getName() + "."