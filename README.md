# Lua Classes

This is a simple library that makes creating table-based classes simple.

This was designed for use with [ROBLOX](https://roblox.com), and as such follows
their commonly used OOP conventions. But it works just fine in any Lua project.

## Usage

The `__init` method defines the parameters your class takes. To instantiate, you
call the `new` function. This is the convention ROBLOX's built-in classes
follow.

If you're using this outside of ROBLOX, you'll simply require it with
`require("class")`.

```lua
local class = require(game.ReplicatedStorage.Class)

local Person = class("Person")

function Person:__init(name, age)
  self.Name = name
  self.Age = age
end

function Person:Greet()
  print("Hi, my names "..self.Name.." and I'm "..self.Age.." years old.")
end

local person = Person.new("John Smith", 24)
person:Greet() -- "Hi, my names John Smith and I'm 24 years old."
```

## Inheritance

Inheriting a class is also very easy. The only part you really have to remember
is to call the `__init` method of the super class, otherwise you won't inherit
the super's properties.

This continues from the above example:

```lua
local Guy = class("Guy", Person)

function Guy:__init(name, age, manliness)
  Person.__init(self, name, age)

  self.Manliness = manliness
end

function Guy:AttackABearOrWhateverGuysDo()
  if self.Manliness > 50 then
    print("I could totally fight that bear.")
  else
    print("Here lies "..self.Name..". He tried to fight a bear.")
  end
end

local guy = Guy.new("John Smith", 24, math.huge)
guy:Greet() -- "Hi, my names John Smith and I'm 24 years old."
guy:AttackABearOrWhateverGuysDo() -- "I could totally fight that bear."
```

## Equivalent

This is what those classes look like in plain Lua. They're a lot longer and
you're constantly dealing with metatables. This module hides all of that
nonsense from view so you can focus on what's important: writing code.

Instantiation is still the same as above.

```lua
local Person = {}
Person.__index = Person
Person.ClassName = "Person"

function Person.new(name, age)
  local self = {}
  setmetatable(self, Person)

  self.Name = name
  self.Age = age

  return self
end

function Person:Greet()
  print("Hi, my names "..self.Name.." and I'm "..self.Age.." years old.")
end

local Guy = {}
Guy.__index = Guy
Guy.ClassName = "Guy"
setmetatable(Guy, Person)

function Guy.new(name, age, manliness)
  local self = Person.new(name, age)
  setmetatable(self, Guy)

  self.Manliness = manliness

  return self
end

function Guy:AttackABearOrWhateverGuysDo()
  if self.Manliness > 50 then
    print("I could totally fight that bear.")
  else
    print("Here lies "..self.Name..". He tried to fight a bear.")
  end
end
```
