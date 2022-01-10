local consts = require("consts")

local concord = require("lib.concord")
local map = concord.system({})

function map:tileAt(x, y)
	local tileX, tileY = math.floor(x / consts.tileSize), math.floor(y / consts.tileSize)
	local column = self.tiles[tileX]
	if not column then
		return nil
	end
	return column[tileY]
end

function map:pointCollision(x, y)
	local tile = self:tileAt(x, y)
	if not tile then
		return true
	end
	return tile.collision
end

function map:moveSquare(x, y, a, dx, dy)
	if dx < 0 then
		if
		  self:pointCollision(x-a+dx, y-a) or
		  self:pointCollision(x-a+dx, y+a)
		then
			dx = -((x-a) % consts.tileSize)
		end
	elseif dx > 0 then
		if
		  self:pointCollision(x+a+dx, y-a) or
		  self:pointCollision(x+a+dx, y+a)
		then
			dx = -(consts.tileSize - (x+a) % consts.tileSize)
		end
	end
	return dx, dy
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
			tile.collision = love.math.random() < 0.05
			column[y] = tile
		end
	end
end

return map

local consts = require("consts")

local concord = require("lib.concord")
local movement = concord.system({pool = {"will", "position", "presence"}})

function movement:update(dt)
	local world = self:getWorld()
	for _, e in ipairs(self.pool) do
		local x, y, a, dx, dy =
		  e.position.x, e.position.y,
		  e.presence.apothem,
		  e.will.moveX * e.walk.speed * dt, e.will.moveY * e.walk.speed * dt
		local dx, dy = world.map:moveSquare(x,y,a,dx,dy)
		e.position.x, e.position.y = x+dx, y+dy
	end
end

return movement

function map:pointColliding(x, y)
	local tileX, tileY = math.floor(x / consts.tileSize), math.floor(y / consts.tileSize)
	if not (
	  0 <= tileX and tileX < self.width and
	  0 <= tileY and tileY < self.height
	) then
		return true
	end
	return self.tiles[tileX][tileY].collision
end

function map:hitboxColliding(x, y, w, h)
	-- TODO: larger-than-a-tile hitboxes
	if
	  self:pointColliding(x, y) or
	  self:pointColliding(x+w, y) or
	  self:pointColliding(x, y+h) or
	  self:pointColliding(x+w, y+h)
	then
		return true
	end
	return false
end

if world.map:hitboxColliding(x+dx,y,w,h) then
	dx = 0
end
if world.map:hitboxColliding(x,y+dy,w,h) then
	dy = 0
end
if world.map:hitboxColliding(x+dx,y+dy,w,h) then
	dx, dy = 0, 0
end
