return function()
	local class = require(script.Parent)

    it("should create a unique new table", function()
		local Class = class("Class")

		expect(Class).to.be.a("table")
		expect(Class).to.never.equal(class("Foo"))
	end)

	it("should error when a name isn't supplied", function()
		expect(function()
			class()
		end).to.throw()
	end)

	it("should instantiate a new class with new()", function()
		local Class = class("Class")

		function Class:foo()
			return "foo"
		end

		local instance = Class.new()

		expect(instance:foo()).to.equal("foo")
	end)

	it("should optionally allow parameters to be assigned in __init()", function()
		local Person = class("Person")

		function Person:__init(name, age)
			self.name = name
			self.age = age
		end

		local person = Person.new("John", 18)

		expect(person.name).to.equal("John")
		expect(person.age).to.equal(18)
	end)

	it("should allow static functions", function()
		local Class = class("Class")

		function Class.staticFunction()
			return true
		end

		local instance = Class.new()

		expect(Class.staticFunction()).to.equal(true)
		expect(instance.staticFunction()).to.equal(true)
	end)

	it("should have a ClassName property set to the name of the class", function()
		local Class = class("Class")
		expect(Class.ClassName).to.equal("Class")
	end)


	it("should reuse the metatable for each instance of a class", function()
		local Class = class("Class")

		local inst1 = Class.new()
		local inst2 = Class.new()

		expect(inst1).to.never.equal(inst2)
		expect(getmetatable(inst1)).to.equal(getmetatable(inst2))
	end)

	describe("subclasses", function()
		it("should return the superclass for easy referencing", function()
			local Base = class("Base")
			local Sub, super = class("Sub", Base)

			expect(super).to.equal(Base)
			expect(Sub).to.never.equal(Base)
		end)

		it("should allow two classes to define the properties they take", function()
			local Base = class("Base")

			function Base:__init(foo)
				self.foo = foo
			end

			local Sub, super = class("Sub", Base)

			function Sub:__init(foo, bar)
				super.__init(self, foo)

				self.bar = bar
			end

			local instance = Sub.new("foo", "bar")

			expect(instance.foo).to.equal("foo")
			expect(instance.bar).to.equal("bar")
		end)

		it("should look up methods in the superclass", function()
			local Base = class("Base")

			function Base:foo()
				return "foo"
			end

			local Sub = class("Sub", Base)

			local instance = Sub.new()

			expect(instance:foo()).to.equal("foo")
		end)

		it("should use the __init method of the superclass", function()
			local Base = class("Base")

			function Base:__init(foo)
				self.foo = foo
			end

			local Sub = class("Sub", Base)

			local instance = Sub.new("foo")

			expect(instance.foo).to.equal("foo")
		end)

		-- Be aware that if you're getting down to 3+ levels of inheritance,
		-- your objects are going to be very complex and hard to reason about.
		-- Consider using composition instead.
		it("should support multiple levels of inheritance", function()
			local Base = class("Base")

			function Base:__init(arg)
				self.arg = arg
			end

			local Sub1 = class("Sub1", Base)

			function Sub1:foo()
				return "foo"
			end

			local Sub2 = class("Sub2", Sub1)

			local instance = Sub2.new("arg")

			expect(instance.arg).to.equal("arg")
			expect(instance:foo()).to.equal("foo")
		end)

		it("should inheret metamethods", function()
			local Base = class("Base")

			function Base:__tostring()
				return self.ClassName
			end

			function Base:__call()
				return 1
			end

			local Sub = class("Sub", Base)
			local instance = Sub.new()

			expect(tostring(instance)).to.equal("Sub")
			expect(instance()).to.equal(1)
		end)

		it("should be able to define its own __init and use the superclass' at the same time", function()
			local Person = class("Foo")
		end)
	end)
end
