/**
 * @name Find Monitors (Basic Names Only)
 * @description Finds Monitor.Enter by manually checking the string names of the method and its parent type.
 * @kind table
 * @id csharp/monitors/find-all-basics
 * @problem.severity warning
 * @precision medium
 * @tags reliability
 */

import csharp

from MethodCall call, Method monitorMethod, Type monitorType, Class c, Callable method
where
    // 1. Link the call to the method 'Enter'
    call.getTarget() = monitorMethod and
    (monitorMethod.getName() = "Enter" or monitorMethod.getName() = "Exit") and
    
    // 2. Link the method to the type 'Monitor'
    monitorMethod.getDeclaringType() = monitorType and
    monitorType.getName() = "Monitor" and
    
    // 3. Link back to your source code context
    call.getEnclosingCallable() = method and
    method.getDeclaringType() = c and
    call.fromSource()
select
    c as found_in,
    method,
    "Found Monitor.Enter/Exit call" as description