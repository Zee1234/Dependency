--- Any plugin that wants to work with Dependency
function DependencyVerify()
  return true
end

function DependencyDisable()
  -- Cleanup for when Dependency shuts down
end


--- Child-specific functions
function DependencyParentInit()
  -- Things to do when informed that a registered parent is online
end

function DependencyParentUninit()
  -- Things to do when informed that a registered parent has disabled
end


--- A useful way to call your Dependency APIs
Dependency = { name = "My Plugin Name"; }

setmetatable(Dependency,{
  __index = function(t,k)
    return function(...)
      cPluginManager:CallPlugin("Dependency",k,t.name,...)
    end
  end
})
--[[
So now you can call the RegisterChild function like:
Dependency.RegisterChild(parent1,parent2,parent3)
As all Dependency API functions request the origin plugin name as the first
    variable, this can save repeated code. It also looks fancy. The alternative
    is of course simpler and technically more resource friendly, so I'll
    include it in this comment.

function Dependency(call,...)
  return cPluginManager:CallPlugin(Dependency,call,"My Plugin Name",...)
end
Easier to read this way, executes faster. probably the smartest way to do it.
But metatables are cool! :P
--]]
