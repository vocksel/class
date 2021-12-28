# class()

A super simple module for defining Lua classes.

This was designed for use with [Roblox](https://roblox.com), and as such follows
their commonly used OOP conventions, but it works just fine in any Lua project.

## Usage

```lua
local class = require(ReplicatedStorage.Packages.Class)

local Person = class("Person")

-- This method defines the parameters your class takes
function Person:__init(name, age)
	self.Name = name
	self.Age = age
end

function Person:Greet()
	print("Hi, my names " .. self.Name .. " and I'm " .. self.Age .. " years old.")
end

-- To instantiate, you call the `new` function
local person = Person.new("John", 18)

person:Greet() -- "Hi, my names John and I'm 18 years old."
```

## Installation

Installing the package is quick and easy whether you use a package manager like [Wally](https://github.com/UpliftGames/wally) or work directly in Studio.

### Wally (Recommended)

Add the following to your `wally.toml` and run `wally install` to download the package.

```toml
[dependencies]
class = "vocksel/class@0.1.1"
```

Make sure the resulting `Packages` folder is synced into your experience using a tool like [Rojo](https://github.com/rojo-rbx/rojo/).

### Roblox Studio

* Download a copy of the rbxm from the [releases page](https://github.com/vocksel/class/releases/latest) under the Assets section.
* Drag and drop the file into Roblox Studio to add it to your experience.

## Inheritance

To make a class inherit another, you pass in the class you want to be inherited
as the second argument.

The only thing you need to do manually is call the `__init` method of the
superclass, otherwise you won't inherit the super's properties.

The superclass is also returned after the newly created class so that you can
create a reference to it. This saves you the trouble of using a direct reference
to the superclass, and having to change it everywhere if you want to inherit
something else.

```lua
-- This example continues from the one above

local Guy, super = class("Guy", Person)

function Guy:__init(name, age, manliness)
	-- This calls Person.__init on this instance, and sets the `Name` and `Age`
	-- properties for you.
	super.__init(self, name, age)

	-- Now we can extend it and add on our properties.
	self.manliness = manliness
end

function Guy:AttackABearOrWhateverGuysDo()
	if self.manliness > 50 then
		print("I could totally fight that bear.")
	else
		print("Here lies " .. self.Name .. ". He tried to fight a bear.")
	end
end

local guy = Guy.new("John", 18, math.huge)

guy:Greet() -- "Hi, my names John and I'm 18 years old."
guy:AttackABearOrWhateverGuysDo() -- "I could totally fight that bear."
```

If your subclass does not change anything about the parameters it takes, you
don't need to create an `__init` method for it. The subclass will automatically
use the `__init` of the superclass.

## Contributing

See the [contributing guide](CONTRIBUTING.md).
## License

[MIT License](LICENSE)