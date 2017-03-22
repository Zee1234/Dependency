--- Function that external plugins call to register a child (dependent) plugin
-- @param name plugin(child) name
-- @param ... list of strings of plugin(parent) names
-- @return true or false + error
function RegisterChild(name,...)
  if not type(name) == 'string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end
  if Children[name] then return false, 'Child Already Registered!' end

  Children[name] = cChild(name)
  for i = 1, args.n do
    if args[i] and type(args[i]) == 'string' then
      AddParent(name,args[i])
      child:addParent(args[i])
    end
  end

  return true
end

--- Function that external plugins call to unregister a child (dependent) plugins
-- @param name plugin(child) name
-- @return true or false + error
function UnregisterChild(name)
  if not type(name) == 'string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end
  if not Children[name] then return false, 'Child Already Unregistered!' end

  for _,v in pairs(Parents) do
    if v:isChild(name) then v:removeChild(name) end
  end
  Children[name] = nil

  return true
end

--- Function that external plugins call to add a parent to their registered child
-- @param name plugin(child) name
-- @param parent plugin(parent) name
-- @return true or false + error
function AddParent(name,parent)
  if not type(name) == 'string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end
  if not Children[name] then return false, 'Register child first!' end

  if not type(parent) == 'string' then return false, 'Invalid parent identifier type!' end

  if not Parents[parent] then                 -- Parent does not exist
    Parents[parent] = cParent(parent,false)
    Parents[parent]:addChild(name)
  elseif Parents[parent]:isChild(name) then   -- Parent does exist, but child already registered
    return false, 'Already a child!'
  else                                        -- Parent does exist, child not registered
    Parents[parent]:addChild(name)
  end

  Children[name]:addParent(parent)

  return true
end

--- Function that external plugins call to remove a parent from their registered child
-- @param name plugin(child) name
-- @param parent plugin(parent) name
-- @return true or false + error
function RemoveParent(name,parent)
  if not type(name) == 'string' then return false, 'Invalid plugin identifier type!' end
  if not verify(name) then return false, 'Invalid plugin name!' end
  if not Children[name] then return false, 'Register child first!' end

  if not type(parent) == 'string' then return false, 'Invalid parent identifier type!' end
  if not Parents[parent] then return false, 'Parent does not exist!' end

  Parents[parent]:removeChild(name)
  Children[name]:removeParent(parent)
end
