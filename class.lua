
local function getNewClass(name)
  local Object = {}
  Object.__index = Object
  Object.ClassName = name

  return Object
end

local function subclass(class, super)
  setmetatable(class, super)
end

local function initializeObject(object, ...)
  if object.__init then
    object:__init(...)
  end
end

function class(name, super)
  local Class = getNewClass(name)

  if super then
    subclass(class, super)
  end

  -- This follows ROBLOX's convention of instantiating classes with `.new()`.
  function Class.new(...)
    local self = setmetatable({}, Class)
    initializeObject(self, ...)
    return self
  end

  return Class
end

return class
