
-- This is the list of metamethods that are copied from one class to another.
local INHERITED_METAMETHODS = {
  "__add", "__call", "__concat", "__div", "__le", "__lt", "__mod", "__mul",
  "__pow", "__sub", "__tostring", "__unm"
}

-- Copies the metamethods from one class to another.
-- `from` is typically the super, and `to` is the subclass.
local function copyMetaMethods(from, to)
  for _, metamethodName in ipairs(INHERITED_METAMETHODS) do
    to[metamethodName] = from[metamethodName]
  end
end

local function getNewClass(name)
  local Object = {}
  Object.__index = Object
  Object.ClassName = name

  return Object
end

local function subclass(class, super)
  setmetatable(class, super)
  copyMetaMethods(super, class)
end

local function initializeObject(object, ...)
  if object.__init then
    object:__init(...)
  end
end

function class(name, super)
  local Class = getNewClass(name)

  if super then
    subclass(Class, super)
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
