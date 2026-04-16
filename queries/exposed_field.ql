/**
 * @name exposed field
 * @description 
 * @kind table
 * @id exposed_field
 */

import csharp

from Field field, Access accessA, Access accessB
where
    accessA.getTarget() = field and
    accessB.getTarget() = field and
    field.fromSource() and
    
    accessA != accessB
select
    field, 
    accessA,
    accessB, 
    "Access A is in: " + accessA.getEnclosingCallable().getName() + 
    ", Access B is in: " + accessB.getEnclosingCallable().getName() as comparison
