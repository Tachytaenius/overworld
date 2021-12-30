local concord = require("lib.concord")
local consts = require("consts")
local assemblages = require("assemblages")

local plants = concord.system({})

function plants:newWorld(width, height)
	local world = self:getWorld()
	for _=1, world.initialTreeCount do
		local x, y =
		  love.math.random() * width * consts.tileSize,
		  love.math.random() * height * consts.tileSize
		local tree = concord.entity():assemble(assemblages.tree, x, y)
		if not world.map:squareColliding(x, y, tree.presence.apothem) then
			world:addEntity(tree)
		end
	end
end

return plants
