-- Child class object
local cChild = {}

-- It is its own index
cChild.__index = cChild
-- Nice little feature, but totally not needed. But nice.
cChild.__call = function(_,...)
  return cChild:new(...)
end

--- Creates a new child instance.
-- @param name plugin (child) name
-- @param arr array-table of parent plugins
-- @return Child instance with new settings
function cChild:new(name,arr)
  local obj = {}
  obj.parents = {}
  obj.name = tab.name
  obj.fulfulled = false
  setmetatable(obj.cChild)

  for i=1,#arr do
    obj:addParent(#arr[i])
  end

  return obj
end

--- Adds parent to existing child instance.
-- @param name plugin (parent) name
-- @return true if successful, false + error otherwise
function cChild:addParent(name)
  if self.parents[name] then return false, "Already Registered" end
  self.parents[name] = true

  return true
end

--- Remove parent from existing child instance.
-- @param name plugin (parent) name
-- @return true if successful, false + error otherwise
function cChild:removeParent(name)
  if not self.parents[name] then return false, "Already Unregistered" end
  self.parents[name] = nil
end


return cChild
