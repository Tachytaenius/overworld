local concord = require("lib.concord")
return concord.component("walk", function(c, speed, walkCycleSeconds)
	c.speed = speed
	c.walkCycleLength = speed * (walkCycleSeconds or 1)
	c.curWalkCyclePos = nil
	c.facingDirection = "south"
	-- c.facingDirectionLastNonDiagonalMovement = "south"
	-- c.curDiagonalStartEffectInversionCooldown = 0 -- I'm sorry, you'll have to look at the wills system for this to make any sense
	-- c.diagonalStartEffectInversionCooldownLength = 0.1 -- Better here than in consts
	
	-- Failed attempts at smoothing out diagonal movement
	-- c.lastXDir = 0
	-- c.lastYDir = 0
	-- c.lastFrameWasDiagonal = false
end)
