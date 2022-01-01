local consts = require("consts")
local tileTypes = require("registry.tileTypes")
local itemTypes = require("registry.itemTypes")

local concord = require("lib.concord")
local map = concord.system({interactors = {"will", "position"}})

function map:pointColliding(x, y)
	local tileX, tileY = math.floor(x / consts.tileSize), math.floor(y / consts.tileSize)
	
	if not (
	  0 <= tileX and tileX < self.width and
	  0 <= tileY and tileY < self.height
	) then
		return true
	end
	-- tileX, tileY = tileX % self.width, tileY % self.height
	
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
		if not e.will.interaction then
			e:remove("interacting")
		else
			if e.interacting then
				if not (e.will.interactionTileX == e.interacting.tileX and e.will.interactionTileY == e.interacting.tileY) then
					e:remove("interacting")
				end
			end
			local tile = self.tiles[e.will.interactionTileX][e.will.interactionTileY]
			local currentItem = e.inventory and e.inventory.currentItem
			local interactionType = itemTypes[currentItem] and itemTypes[currentItem].interactionType or "none"
			local interactionBlueprint = tileTypes[tile.type].interact and tileTypes[tile.type].interact[interactionType]
			if interactionBlueprint then
				if not e.interacting then
					e:give("interacting", e.will.interactionTileX, e.will.interactionTileY, interactionBlueprint.displayType)
				end
				e.interacting.progress = e.interacting.progress + dt / (interactionBlueprint.baseTime or 0) * (itemTypes[currentTool] and itemTypes[currentTool].interactionSpeed or 1)
				-- that'd make a NaN without baseTime but that's of no consequence
				if not interactionBlueprint.baseTime or interactionBlueprint.baseTime == 0 or e.interacting.progress >= 1 then
					e:remove("interacting")
					-- map interaction completed, make the changes
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
end

return map
