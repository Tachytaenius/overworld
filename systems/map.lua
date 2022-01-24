local consts = require("consts")
local tileTypes = require("registry.tileTypes")
local itemTypes = require("registry.itemTypes")

local concord = require("lib.concord")
local assemblages = require("assemblages")
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
			local type
			local vegetation = love.math.noise(x / 50, y / 50, 0) ^ 2
			local rockiness = love.math.noise(x / 100, y / 100, 1) ^ 6
			if love.math.random() * 10 < rockiness then
				type = "rock"
			elseif love.math.random() * 4 < vegetation then
				type = "floweredGrass"
			elseif love.math.random() / 2 + 0.15 < vegetation then
				type = "tree"
			else
				type = "grass"
			end
			tile.type = type
			if love.math.random() * 8 < rockiness then
				if not tileTypes[type].collision then
					if love.math.random() < 0.75 then
						self:addItemToTile(x, y, "pebble")
						if love.math.random() < 0.1 then
							self:addItemToTile(x, y, "pebble")
						end
					else
						self:addItemToTile(x, y, "cobble")
					end
				end
			end
			column[y] = tile
		end
	end
end

function map:addItemToTile(x, y, item)
	local x2, y2 =
	  (x + love.math.random()) * consts.tileSize,
	  (y + love.math.random()) * consts.tileSize
	local entityToAdd = concord.entity():assemble(assemblages.item, x2, y2, item)
	self:getWorld():addEntity(entityToAdd)
end

-- NOTE in case it changes: this method is mentioned in registry/tileTypes.lua as the place where tiles turn to items
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
			local interactionType = itemTypes[currentItem.type] and itemTypes[currentItem.type].interactionType or "none"
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
					for _, itemStack in ipairs(interactionBlueprint.items) do
						for _=1, itemStack.quantity do
							local itemToAdd = {}
							for k, v in pairs(itemStack) do
								itemToAdd[k] = v
							end
							itemToAdd.quantity = nil
							self:addItemToTile(e.will.interactionTileX, e.will.interactionTileY, itemToAdd)
						end
					end
				end
			end
		end
	end
end

return map
