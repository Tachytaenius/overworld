local consts = require("consts")
local tileTypes = require("registry.tileTypes")

local concord = require("lib.concord")
local map = concord.system({interactors = {"will", "position", "inventory"}})

function map:pointColliding(x, y)
	local tileX, tileY = math.floor(x / consts.tileSize), math.floor(y / consts.tileSize)
	
	-- if not (
	--   0 <= tileX and tileX < self.width and
	--   0 <= tileY and tileY < self.height
	-- ) then
	-- 	return true
	-- end
	tileX, tileY = tileX % self.width, tileY % self.height
	
	local tileType = tileTypes[self.tiles[tileX][tileY].type]
	if tileType.collision then
		return true
	-- elseif tileType.smallCollision then
	-- 	local sc = tileType.smallCollision
	-- 	local x, y = x%consts.tileSize,y%consts.tileSize
	-- 	return
	-- 	  sc.x1 <= x and x <= sc.x2 and
	-- 	  sc.y1 <= y and y <= sc.y2
	else
		return false
	end
end

function map:squareColliding(x, y, a)
	-- TODO: larger-than-a-tile hitboxes
	if
	  self:pointColliding(x-a, y-a) or
	  self:pointColliding(x+a, y-a) or
	  self:pointColliding(x-a, y+a) or
	  self:pointColliding(x+a, y+a)
	then
		return true
	end
	return false
end

function map:newWorld(width, height)
	self.width, self.height = width, height
	local tiles = {}
	self.tiles = tiles
	for x = 0, width - 1 do
		local column = {}
		tiles[x] = column
		for y = 0, height - 1 do
			local tile = {}
			local randomVal = love.math.random()
			local type
			if love.math.random() < 0.98 then
				local noiseVal = love.math.noise(x / 50, y / 50) ^ 2
				if love.math.random() < noiseVal then
					type = "tree"
				else
					type = love.math.random() < 0.1 and "floweredGrass" or love.math.random() < 0.05 and "pebbledGrass" or "grass"
				end
			else
				type = "rock"
			end
			tile.type = type
			column[y] = tile
			-- tile.type =
			--   randomVal < 0.01 and "rock" or
			--   randomVal < 0.25 and "floweredGrass" or
			--   randomVal < 0.30 and "tree" or
			--   "grass"
		end
	end
end

function map:update(dt)
	for _, e in ipairs(self.interactors) do
		if e.will.interaction then
			local tile = self.tiles[e.will.interactionTileX][e.will.interactionTileY]
			local interactionBlueprint = tileTypes[tile.type].interact and tileTypes[tile.type].interact[e.inventory.currentTool]
			if interactionBlueprint then
				tile.type = interactionBlueprint.newTile
				for getItem, getQuantity in ipairs(interactionBlueprint.items) do
					local newStackRequired = true
					for _, stack in ipairs(e.inventory.items) do
						local haveItem, haveQuantity = stack.item, stack.quantity
						if haveItem == getItem then
							newStackRequired = false
							stack.quantity=getQuantity+haveQuantity
							break
						end
					end
					if newStackRequired then
						table.insert(e.inventory.items, {item = getItem, quantity = getQuantity})
					end
				end
			end
		end
	end
end

return map
