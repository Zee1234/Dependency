-- Parent class object
local cParent = {}

-- It is its own index
cParent.__index = cParent
-- Nice little feature, but totally not needed. But nice.
cParent.__call = function(_,...)
  return cParent:new(...)
end

--- Creates a new parent instance.
-- @param name plugin (parent) name
-- @param fromParent true if Parent registering self, false if child registering parent
function cParent:new(name,fromParent)
  local obj = setmetatable({},cParent)
  obj.registered = false
  obj.children = {}
  obj.name = name
  if fromParent then obj:register() end

  return obj
end

--- Sets parent object as registered
function cParent:register()
  self.registered = true
end

--- Sets parent object as unregistered
function cParent:unregister()
  self.registered = false
end

--- Check registered state
-- @return registered bool
function cParent:isRegistered()
  return self.registered
end

--- See if plugin is child of parent
-- @param name plugin (child) name
-- @return true on present, false on absent
function cParent:isChild(name)
  for i = 1, #self.children do
    if self.children[i] == name then
      return i
    end
  end
  return false
end

--- Add child to parent instance
-- @param name plugin (child) name
-- @return true on success, false + error on failure
function cParent:addChild(name)
  if not self:isChild(name) then
    self.children[#self.children+1] = name
    if self:isRegistered() then self:notifyOne(name) end
    return true
  else
    return false, "Child already registered"
  end
end

--- Remove child from parent instance
-- @param name plugin (child) name
-- @return true on success, false + error on failure
function cParent:removeChild(name)
  local num = self:isChild(name)
  if num then
    table.remove(self.children,num)
    return true
  else
    return false, "Child already unregistered"
  end
end

--- Notify specific child that parent plugin Initialized
-- @param name plugin (child) name
-- @return true on success, false + error on failure
function cParent:notifyOne(name)
  if next(self.children) == nil then return false, 'No Children' end
  if not self:isChild(name) then return false, 'Not a child' end

  callPlugin(name,calls.parentInit,self.name)
end

--- Notify all children that parent plugin Initialized
-- @return true on success, false + error on failure
function cParent:notifyAll()
  if next(self.children) == nil then return false, 'No Children' end

  -- Funny method: just notifyOne everyone!
  for k,_ in pairs(self) do
    self:notifyOne(k)
  end
end

--- Notify all children that parent parent Unitilialized
-- @return true on success, false + error on failure
function cParent:notifyOff()
  for i=1,#self.children do
    callPlugin(self.children[i],calls.parentUnit,self.name)
  end
end
