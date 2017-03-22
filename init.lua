local localFolder = cPluginManager:GetCurrentPlugin():GetLocalFolder()

cChild = require(localFolder..'/classes/cChild.lua')
cParent = require(localFolder..'/classes/cParent.lua')
require(localFolder..'/API/Child.lua')
require(localFolder..'/API/Parent.lua')

Plugin = nil --I know this does nothing, it's a note.
Children = {} --Stores child objects
Parents = {} --Stores parent objects


--- Start plugin.
-- @param plugin cPlugin instance for 'this'
-- @return true upon successful initialization
function Initialize(plugin)
  plugin:SetName(g_PluginInfo.Name)
  plugin:SetVersion(g_PluginInfo.Version)

  Plugin = plugin
  LOG('Initialized '..plugin:GetName()..' v.'.. plugin:GetVersion())
  return true
end


--- Stop plugin.
-- Performs cleanup, informs parents and children of state
-- @return nothing because it doesn't matter
function OnDisable()
  announceOff()
  LOG(Plugin:GetName()..' is disabled')
end

--- Checks for existance of a plugin as well as determining if it is compatible
-- @param name plugin name
-- @return true on match, false otherwise
function verify(name)
  return not cPluginManager:ForEachPlugin(function(plugin)
      if plugin:GetName() == name then return true end
    end) and cPluginManager:CallPlugin(name,calls.verify)
end

--- Run when shutting down to inform plugins of such
function announceOff()
  for k,v in pairs(Parents) do
    if v:isRegistered() then
      callPlugin(k,calls.shutdown)
    end
  end

  for k,_ in pairs(Children) do
    callPlugin(k,calls.shutdown)
  end
end

--- Shortcut to cPluginManager:CallPlugin()
function callPlugin(...)
  cPluginManager:CallPlugin(...)
end
