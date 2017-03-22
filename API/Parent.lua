
--- Function that external plugins call to register a parent (library) plugin
-- @param name plugin(parent) name
-- @return true or false + error
function RegisterParent(name)
  if not type(name)=='string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end

  if not Parents[name] then
    Parents[name] = cParent(name,true)
  elseif Parents[name]:isRegistered() then
    return false, 'Already registered'
  else
    Parents[name]:register()
    cRoot:Get():GetDefaultWorld():ScheduleTask(1,function() Parents[name]:notifyAll() end)
  end

  return true
end


--- Function that external plugins call to unregister a parent (library) plugin
-- @param name plugin(parent) name
-- @return true or false + error
function UnregisterParent(name)
  if not type(name)=='string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end
  if not Parents[name] then return false, 'Plugin already unregistered' end

  Parents[name]:notifyOff()
  Parents[name]:unregister()
end
