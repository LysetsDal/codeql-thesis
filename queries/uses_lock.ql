/**
 * @name Find locks in projects
 * @description Finds all classes that uses an object lock
 * @kind table
 * @id csharp/locks/find-all
 */

import csharp

from 
    Callable method, Class c, LockStmt lock
where
    lock.getEnclosingCallable() = method and
    method.getDeclaringType() = c and
    lock.fromSource()
select
    c,
    method,
    "Class '" + c.getName() + "' uses a lock in method " + method.getName() + "." as description