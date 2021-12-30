do
	math.tau = math.pi * 2
	function math.sign(x)
		return
		  x > 0 and 1 or
		  x == 0 and 0 or
		  x < 0 and -1 
	end
	function math.round(x)
		return math.floor(x + 0.5)
	end
end

do
	local list = require("lib.list")
	function list:elements() -- Convenient iterator
		local i = 1
		return function()
			local v = self:get(i)
			i = i + 1
			if v ~= nil then
				return v
			end
		end, self, 0
	end
	function list:find(obj) -- Same as List:has but without "and true"
		return self.pointers[obj]
	end
end

do
	-- Augment worlds by allowing world.systemName behaviour, relying on this project's string -> system class table.
	local systems = require("systems")
	local concord = require("lib.concord")
	local oldWorldNew = concord.world.new
	local newWorldMetatable = {
		__index = function(self, k)
			local v = rawget(self, k)
			if v then return v end
			local v = rawget(concord.world, k)
			if v then return v end
			-- Here is where it is (functionally) different from concord.world.__mt:
			return self:getSystem(systems[k])
		end
	}
	function concord.world.new()
		return setmetatable(oldWorldNew(), newWorldMetatable)
	end
end
