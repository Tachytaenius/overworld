local consts = require("consts")
local assets = require("assets")
local spriteTypes = require("registry.spriteTypes")

local quadreasonable = require("lib.quadreasonable")
local concord = require("lib.concord")
local rendering = concord.system({cameras = {"camera"}, sprites = {"sprite", "position"}, interactors = {"interacting"}})

function rendering:init()
	self.output = love.graphics.newCanvas(consts.gameCanvasWidth, consts.gameCanvasHeight)
end

function rendering:draw()
	love.graphics.setCanvas(self.output)
	love.graphics.clear()
	
	local camera = self.cameras[1]
	if not camera then return end
	local world = self:getWorld()
	-- NOTE: The maths here could really do with being simplified.
	-- love.graphics.translate(
	-- 	math.max(-(world.map.width * consts.tileSize - consts.gameCanvasWidth), math.min(0, math.round(-camera.position.x + consts.gameCanvasWidth / 2))),
	-- 	math.max(-(world.map.height * consts.tileSize - consts.gameCanvasHeight), math.min(0, math.round(-camera.position.y + consts.gameCanvasHeight / 2)))
	-- )
	love.graphics.translate(
		math.round(-camera.position.x + consts.gameCanvasWidth / 2),
		math.round(-camera.position.y + consts.gameCanvasHeight / 2)
	)
	
	local world = self:getWorld()
	-- for
	--   x = math.max(0, math.floor((camera.position.x - consts.gameCanvasWidth / 2) / consts.tileSize)),
	--   math.min(world.map.width - 1, math.floor((camera.position.x + consts.gameCanvasWidth / 2) / consts.tileSize))
	-- do
	-- 	for
	-- 	  y = math.max(0, math.floor((camera.position.y - consts.gameCanvasHeight / 2) / consts.tileSize)),
	-- 	  math.min(world.map.height - 1, math.floor((camera.position.y + consts.gameCanvasHeight / 2) / consts.tileSize))
	-- 	do
	for x0 = camera.position.x - consts.gameCanvasWidth / 2, camera.position.x + consts.gameCanvasWidth / 2, consts.tileSize do
		local x = math.floor(x0 / consts.tileSize) % world.map.width
		for y0 = camera.position.y - consts.gameCanvasHeight, camera.position.y + consts.gameCanvasHeight, consts.tileSize do
			local y = math.floor(y0 / consts.tileSize) % world.map.height
			local tile = world.map.tiles[x][y]
			love.graphics.draw(assets.terrain[tile.type], x * consts.tileSize, y * consts.tileSize)
		end
	end
	
	
	for _, e in ipairs(self.interactors) do
		if e.interacting.type == "cracks" then
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
	
	for _, e in ipairs(self.sprites) do
		local spriteType = spriteTypes[e.sprite.val]
		local image = assets.sprites[e.sprite.val]
		local quad = quadreasonable.getQuad(
			e.walk and
			  (e.walk.facingDirection == "north" and 0 or
			  e.walk.facingDirection == "east" and 1 or
			  e.walk.facingDirection == "south" and 2 or
			  e.walk.facingDirection == "west" and 3)
			  or 0,
			e.walk and
			  ((e.walk.curWalkCyclePos and (math.floor(e.walk.curWalkCyclePos / e.walk.walkCycleLength * spriteType.walkCycleStages) + 1) or 0) +
			  ((spriteType.poseOffsetToUse and spriteType.poseOffsetToUse(e) or 0) * ((spriteType.walkCycleStages or 0) + 1)))
			  or 0,
			spriteType.noRotation and 1 or 4, ((spriteType.walkCycleStages or 0) + 1) * (spriteType.poses or 1),
			spriteType.size, spriteType.size
		)
		local s = spriteType.size
		local x, y =
		  math.round(e.position.x-s/2 + (spriteType.xOffset or 0)),
		  math.round(e.position.y-s/2 + (spriteType.yOffset or 0))
		love.graphics.draw(image, quad, x, y)
		-- local a = e.presence.apothem
		-- love.graphics.rectangle("line", e.position.x-a, e.position.y-a, a*2, a*2)
		-- love.graphics.points(e.position.x, e.position.y)
	end
	
	
	
	love.graphics.setCanvas()
	love.graphics.origin()
end

return rendering
