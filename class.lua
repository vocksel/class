
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

local function subclass(NewClass, SuperClass)
  -- The superclass is set as a property so subclasses can easily reference it
  -- without having to use the actual name of the superclass.
  NewClass.Super = SuperClass

  setmetatable(NewClass, SuperClass)
  copyMetaMethods(SuperClass, NewClass)
end

local function initializeObject(object, ...)
  -- The __init method is not expected to be defined for every class, so we need
  -- to make sure things won't break if it's not.
  if object.__init then object:__init(...) end
end

local function getNewClass(className)
  local NewClass = {}
  NewClass.__index = NewClass
  NewClass.ClassName = className

  -- This follows ROBLOX's convention of instantiating classes with `.new()`.
  function NewClass.new(...)
    local self = setmetatable({}, NewClass)
    initializeObject(self, ...)
    return self
  end

  return NewClass
end

--------------------------------------------------------------------------------

function class(className, SuperClass)
  local NewClass = getNewClass(className)

  if SuperClass then
    subclass(NewClass, SuperClass)
  end

  return NewClass
end

return class
