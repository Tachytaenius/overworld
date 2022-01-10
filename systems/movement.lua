local consts = require("consts")

local concord = require("lib.concord")
local movement = concord.system({pool = {"will", "position"}})

function movement:update(dt)
	local world = self:getWorld()
	for _, e in ipairs(self.pool) do
		if e.will.facingDirection then
			e.walk.facingDirection = e.will.facingDirection
		end
		local x, y, dx, dy =
		  e.position.x, e.position.y,
		  e.will.moveX * e.walk.speed * dt, e.will.moveY * e.walk.speed * dt
		if e.presence then
			local a = e.presence.apothem
			-- local thisFrameDiagonal = dx ~= 0 and dy ~= 0
			-- if thisFrameDiagonal and not e.walk.lastFrameWasDiagonal then
			-- 	-- Gets stuck on tiles... ... ... ... ... ... ... ... ... ...
			-- 	x = e.walk.lastXDir == 1 and math.floor(x) or e.walk.lastXDir == -1 and math.ceil(x) or math.round(x)
			-- 	y = e.walk.lastYDir == 1 and math.floor(y) or e.walk.lastYDir == -1 and math.ceil(y) or math.round(y)
			-- end
			if world.map:squareColliding(x+dx,y,a) then
				dx = 0
			end
			if world.map:squareColliding(x,y+dy,a) then
				dy = 0
			end
			if world.map:squareColliding(x+dx,y+dy,a) then
				dx, dy = 0, 0
			end
		end
		e.position.x, e.position.y = x+dx, y+dy
		if e.walk then
			if dx ~= 0 or dy ~= 0 then
				e.walk.curWalkCyclePos = ((e.walk.curWalkCyclePos or 0) + math.sqrt(dx^2 + dy^2)) % e.walk.walkCycleLength
			else
				e.walk.curWalkCyclePos = nil
			end
			-- e.walk.lastFrameWasDiagonal = thisFrameDiagonal
			-- e.walk.lastXDir = math.sign(dx)
			-- e.walk.lastYDir = math.sign(dy)
		end
	end
end

return movement
