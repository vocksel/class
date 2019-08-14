# class.lua

A super simple module for defining Lua classes.

This was designed for use with [Roblox](https://roblox.com), and as such follows
their commonly used OOP conventions, but it works just fine in any Lua project.

## Usage

The `__init` method defines the parameters your class takes.

To instantiate, you call the `new` function. This is the convention Roblox's
built-in classes follow.

```lua
-- If you're using this outside of Roblox, you simply need `require("class")`
local class = require(game.ReplicatedStorage.Class)

-- The string is assigned to the `ClassName` property, again following
-- Roblox's conventions.
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

To make a class inherit another, you pass in the class you want to be inherited
as the second argument.

The only part you really have to remember is to call the `__init` method of the
superclass, otherwise you won't inherit the super's properties.

The superclass is also returned after the newly created class so that you can
create a reference to it. This saves you the trouble of using a direct reference
to the superclass, and having to change it everywhere if you want to inherit
something else.

```lua
-- This example continues from the one above

local Guy, super = class("Guy", Person)

function Guy:__init(name, age, manliness)
  -- This calls Person.__init on this instance, and sets the Name and Age
  -- properties for you.
  super.__init(self, name, age)

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

It's also handy to know: if your subclass does not change anything about the
parameters it takes, you don't need to create an `__init` method. Lua will
automatically use the `__init` of the superclass.

## Equivalent

This is what those classes look like in plain Lua. They're a lot longer and
you're constantly dealing with metatables. This module hides all of that
nonsense from view so you can focus on what's important: writing code.

```lua
-- Instantiation with .new() is still the same as above.

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
