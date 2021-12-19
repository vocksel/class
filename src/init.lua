-- This is the list of metamethods that are copied from one class to another.
local INHERITED_METAMETHODS = {
	"__add",
	"__call",
	"__concat",
	"__div",
	"__le",
	"__lt",
	"__mod",
	"__mul",
	"__pow",
	"__sub",
	"__tostring",
	"__unm",
}

-- Copies the metamethods from one class to another.
-- `from` is typically the super, and `to` is the subclass.
local function copyMetaMethods(from, to)
	for _, metamethodName in ipairs(INHERITED_METAMETHODS) do
		to[metamethodName] = from[metamethodName]
	end
end

local function subclass(NewClass, SuperClass)
	setmetatable(NewClass, SuperClass)
	copyMetaMethods(SuperClass, NewClass)
end

local function getNewClass(className)
	local NewClass = {}
	NewClass.__index = NewClass
	NewClass.ClassName = className

	function NewClass.new(...)
		local self = {}
		setmetatable(self, NewClass)

		if self.__init then
			self:__init(...)
		end

		return self
	end

	return NewClass
end

local function class(className, SuperClass)
	assert(type(className) == "string", "First argument to class() must be a string for the ClassName")

	local NewClass = getNewClass(className)

	if SuperClass then
		subclass(NewClass, SuperClass)
	end

	return NewClass, SuperClass
end

return class
