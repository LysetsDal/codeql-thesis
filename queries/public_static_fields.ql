/**
 * @name Public Static Fields
 * @description Finds all public static fields in .cs files.
 * @kind table
 * @id csharp/architectural/public-static-fields
 * @problem.severity warning
 * @precision medium
 * @tags reliability
 */

import csharp

from Field field, Class in_class
where 
    // Link field to a class; returns the type where field is defined.
    field.getDeclaringType() = in_class and
    field.isPublic() and
    field.isStatic() and
    // Only target source .cs files
    field.fromSource()
select
    field,
    in_class, 
    "Public static field '" + field.getName() + "' in class " + in_class.getName() + "." as description