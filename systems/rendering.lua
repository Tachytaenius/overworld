local consts = require("consts")
local assets = require("assets")
local spritesheetTypes = require("registry.spritesheetTypes")

local quadreasonable = require("lib.quadreasonable")
local concord = require("lib.concord")
local rendering = concord.system({cameraEntities = {"camera"}, items = {"item", "position"}, spritesheets = {"spritesheet", "position"}, interactors = {"interacting"}})

local inventoryPaddingTLQuad = love.graphics.newQuad(0, 0, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingTQuad = love.graphics.newQuad(8, 0, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingTRQuad = love.graphics.newQuad(16, 0, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingLQuad = love.graphics.newQuad(0, 8, 8, 8, assets.ui.inventoryTiles)
local inventorySlotSquareQuad = love.graphics.newQuad(8, 8, 8, 8, assets.ui.inventoryTiles)
local inventorySlotlessSquareQuad = love.graphics.newQuad(16, 8, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingRQuad = love.graphics.newQuad(24, 8, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingBLQuad = love.graphics.newQuad(0, 16, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingBQuad = love.graphics.newQuad(8, 16, 8, 8, assets.ui.inventoryTiles)
local inventoryPaddingBRQuad = love.graphics.newQuad(16, 16, 8, 8, assets.ui.inventoryTiles)
-- x and y are the top left of the first item square, not the padding
function rendering:drawInventoryGrid(x, y, width, height, items, itemCount, highlightedItemIndex)
	itemCount = itemCount or width * height
	love.graphics.push()
	love.graphics.translate(x, y)
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			local i = y * width + x + 1
			love.graphics.draw(assets.ui.inventoryTiles, i > itemCount and inventorySlotlessSquareQuad or inventorySlotSquareQuad, x*8, y*8)
			local item = items[i]
			if item then
				if item.item then -- entity, as in the pickupables menu, or just in an inventory?
					item = item.item.val
				end
				love.graphics.draw(assets.items[item.type], x*8, y*8)
			end
		end
	end
	love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingTLQuad, -8, -8)
	love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingTRQuad, width*8, -8)
	love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingBLQuad, -8, height*8)
	love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingBRQuad, width*8, height*8)
	for x = 0, width - 1 do
		love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingTQuad, x*8, -8)
		love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingBQuad, x*8, height*8)
	end
	for y = 0, height - 1 do
		love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingLQuad, -8, y*8)
		love.graphics.draw(assets.ui.inventoryTiles, inventoryPaddingRQuad, width*8, y*8)
	end
	if highlightedItemIndex then
		local x = (highlightedItemIndex - 1) % width
		local y = math.floor((highlightedItemIndex - 1) / width)
		love.graphics.draw(assets.ui.itemSelector, x*8-4, y*8-4)
	end
	love.graphics.pop()
end

function rendering:init()
	self.output = love.graphics.newCanvas(consts.gameCanvasWidth, consts.gameCanvasHeight)
	-- self.depthShader = love.graphics.newShader("shaders/depth.glsl")
end

-- tileLayer = 0 -- The world tiles
-- tileDecalLayer = 1 -- Stuff like racks from mining
-- itemLayer = 2 -- Dropped items
-- actorLayer = 3 -- The player and other actors
-- infoLayer = 4 -- Stuff like health bars
-- UILayer = 5 -- Inventory etc

function rendering:draw()
	love.graphics.setCanvas({self.output, depth = true})
	-- love.graphics.setShader(self.depthShader)
	love.graphics.clear()
	
	local cameraEntity = self.cameraEntities[1]
	if not cameraEntity then return end
	local world = self:getWorld()
	-- NOTE: The maths here could really do with being simplified.
	-- love.graphics.translate(
	-- 	math.max(-(world.map.width * consts.tileSize - consts.gameCanvasWidth), math.min(0, math.round(-cameraEntity.position.x + consts.gameCanvasWidth / 2))),
	-- 	math.max(-(world.map.height * consts.tileSize - consts.gameCanvasHeight), math.min(0, math.round(-cameraEntity.position.y + consts.gameCanvasHeight / 2)))
	-- )
	love.graphics.translate(
		math.round(-cameraEntity.position.x + consts.gameCanvasWidth / 2),
		math.round(-cameraEntity.position.y + consts.gameCanvasHeight / 2)
	)
	-- love.graphics.scale(4/16)
	
	local world = self:getWorld()
	-- for
	--   x = math.max(0, math.floor((cameraEntity.position.x - consts.gameCanvasWidth / 2) / consts.tileSize)),
	--   math.min(world.map.width - 1, math.floor((cameraEntity.position.x + consts.gameCanvasWidth / 2) / consts.tileSize))
	-- do
	-- 	for
	-- 	  y = math.max(0, math.floor((cameraEntity.position.y - consts.gameCanvasHeight / 2) / consts.tileSize)),
	-- 	  math.min(world.map.height - 1, math.floor((cameraEntity.position.y + consts.gameCanvasHeight / 2) / consts.tileSize))
	-- 	do
	-- self.depthShader:send("z", tileLayer)
	for x0 = cameraEntity.position.x - consts.gameCanvasWidth / 2, cameraEntity.position.x + consts.gameCanvasWidth / 2, consts.tileSize do
	-- for x = 0, world.map.width - 1 do
		local x = math.floor(x0 / consts.tileSize) % world.map.width
		for y0 = cameraEntity.position.y - consts.gameCanvasHeight, cameraEntity.position.y + consts.gameCanvasHeight, consts.tileSize do
		-- for y = 0, world.map.height - 1 do
			local y = math.floor(y0 / consts.tileSize) % world.map.height
			local tile = world.map.tiles[x][y]
			love.graphics.draw(assets.terrain[tile.type], x * consts.tileSize, y * consts.tileSize)
		end
	end
	
	for _, e in ipairs(self.interactors) do
		if e.interacting.type == "cracks" then
			-- self.depthShader:send("z", tileDecalLayer)
			local x, y = e.interacting.tileX * consts.tileSize, e.interacting.tileY * consts.tileSize
			if e.interacting.progress > 0.75 then
				love.graphics.draw(assets.terrain.damage[3], x, y)
			elseif e.interacting.progress > 0.5 then
				love.graphics.draw(assets.terrain.damage[2], x, y)
			elseif e.interacting.progress > 0.25 then
				love.graphics.draw(assets.terrain.damage[1], x, y)
			else
				
			end
		end
	end
	
	for _, e in ipairs(self.items) do
		local x, y =
		  math.round(e.position.x-consts.itemSize/2),
		  math.round(e.position.y-consts.itemSize/2)
		love.graphics.draw(assets.items[e.item.val.type], x, y)
		-- love.graphics.points(e.position.x, e.position.y)
	end
	
	for _, e in ipairs(self.spritesheets) do
		local spritesheetType = spritesheetTypes[e.spritesheet.val]
		local image = assets.spritesheets[e.spritesheet.val]
		local quad = quadreasonable.getQuad(
			e.walk and
			  (e.walk.facingDirection == "north" and 0 or
			  e.walk.facingDirection == "east" and 1 or
			  e.walk.facingDirection == "south" and 2 or
			  e.walk.facingDirection == "west" and 3)
			  or 0,
			e.walk and
			  ((e.walk.curWalkCyclePos and (math.floor(e.walk.curWalkCyclePos / e.walk.walkCycleLength * spritesheetType.walkCycleStages) + 1) or 0) +
			  ((spritesheetType.poseOffsetToUse and spritesheetType.poseOffsetToUse(e) or 0) * ((spritesheetType.walkCycleStages or 0) + 1)))
			  or 0,
			spritesheetType.noRotation and 1 or 4, ((spritesheetType.walkCycleStages or 0) + 1) * (spritesheetType.poses or 1),
			spritesheetType.size, spritesheetType.size
		)
		local s = spritesheetType.size
		local x, y =
		  math.round(e.position.x-s/2 + (spritesheetType.xOffset or 0)),
		  math.round(e.position.y-s/2 + (spritesheetType.yOffset or 0))
		love.graphics.draw(image, quad, x, y)
		-- local a = e.presence.apothem
		-- love.graphics.rectangle("line", e.position.x-a, e.position.y-a, a*2, a*2)
		-- love.graphics.points(e.position.x, e.position.y)
	end
	
	love.graphics.origin()
	-- love.graphics.setShader()
	
	-- HUD
	
	if cameraEntity.inventory and cameraEntity.inventory.isOpen then
		self:drawInventoryGrid(6, 6, 1, 1, {cameraEntity.inventory.currentItem})
		if self:getWorld().ui then
			if self:getWorld().ui.inventoryGrid then
				self:drawInventoryGrid(unpack(self:getWorld().ui.inventoryGrid))
			end
		end
	end
	
	love.graphics.setCanvas()
end

return rendering
