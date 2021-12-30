local settings = require("settings")
local consts = require("consts")
-- local input = require("input")

local concord = require("lib.concord")
local wills = concord.system({wills = {"will"}, playerWalkers = {"player", "will", "walk"}, playerInventoryUsers = {"player", "will", "inventory"}})

function wills:update(dt)
	for _, e in ipairs(self.wills) do
		for k in pairs(e.will) do
			e.will[k] = nil -- What if you remove both player and AI from an object? It can't just keep moving in one direction...
			-- If this is unperformant, then it could be replaced with checking for AI or player or any other "will source" before using will.
		end
	end
	
	for _, e in ipairs(self.playerWalkers) do
		local moveX, moveY = 0, 0
		if love.keyboard.isDown(settings.commands.up) then
			moveY = moveY - 1
		end
		if love.keyboard.isDown(settings.commands.down) then
			moveY = moveY + 1
		end
		if love.keyboard.isDown(settings.commands.left) then
			moveX = moveX - 1
		end
		if love.keyboard.isDown(settings.commands.right) then
			moveX = moveX + 1
		end
		local magnitude = math.sqrt(moveX^2 + moveY^2)
		if magnitude > 0 then
			moveX, moveY = moveX / magnitude, moveY / magnitude
		end
		local lastMoveX, lastMoveY = e.will.moveX, e.will.moveY
		e.will.moveX, e.will.moveY = moveX, moveY
		
		local tryNorth, trySouth, tryWest, tryEast =
		  moveY < 0, moveY > 0,
		  moveX < 0, moveX > 0
		
		if moveX == 0 or moveY == 0 then
			e.will.facingDirection =
			  tryNorth and "north" or
			  trySouth and "south" or
			  tryEast and "east" or
			  tryWest and "west"
		else
			e.will.facingDirection = e.walk.facingDirection
		end
		
		-- local fDir = e.walk.facingDirection
		-- local fDirLND = e.walk.facingDirectionLastNonDiagonalMovement
		-- local cdDone = e.walk.curDiagonalStartEffectInversionCooldown <= 0
		-- if tryEast and tryNorth then
		-- 	fDir = fDirLND == "east" and "north" or "east"
		-- 	if not cdDone then
		-- 		fDir = fDir == "east" and "north" or "east"
		-- 	end
		-- elseif tryEast and trySouth then
		-- 	fDir = fDirLND == "east" and "south" or "east"
		-- 	if not cdDone then
		-- 		fDir = fDir == "east" and "south" or "east"
		-- 	end
		-- elseif tryWest and trySouth then
		-- 	fDir = fDirLND == "west" and "south" or "west"
		-- 	if not cdDone then
		-- 		fDir = fDir == "west" and "south" or "west"
		-- 	end
		-- elseif tryWest and tryNorth then
		-- 	fDir = fDirLND == "west" and "north" or "west"
		-- 	if not cdDone then
		-- 		fDir = fDir == "west" and "north" or "west"
		-- 	end
		-- elseif tryNorth or trySouth or tryWest or tryEast then
		-- 	fDir = tryNorth and "north" or trySouth and "south" or tryWest and "west" or tryEast and "east"
		-- end
		-- e.will.facingDirection = fDir
		-- if moveX == 0 or moveY == 0 then
		-- 	e.walk.facingDirectionLastNonDiagonalMovement = fDir
		-- else
		-- 	if cdDone then
		-- 		e.walk.curDiagonalStartEffectInversionCooldown = e.walk.diagonalStartEffectInversionCooldownLength
		-- 	end
		-- end
		-- e.walk.curDiagonalStartEffectInversionCooldown = math.max(e.walk.curDiagonalStartEffectInversionCooldown - dt, 0)
	end
	
	for _, e in ipairs(self.playerInventoryUsers) do
		if e.position and love.keyboard.isDown(settings.commands.useTool) then
			e.will.interaction = true
			local x, y = e.position.x, e.position.y
			local fDir = e.walk.facingDirection
			if e.reach then
				if e.presence then
					local a = e.presence.apothem
					if fDir == "north" then
						y=y-a-e.reach.val
					elseif fDir == "south" then
						y=y+a+e.reach.val
					elseif fDir == "east" then
						x=x+a+e.reach.val
					-- elseif fDir == "west" then
					else
						x=x-a-e.reach.val
					end
				else
					if fDir == "north" then
						y=y-e.reach.val
					elseif fDir == "south" then
						y=y+e.reach.val
					elseif fDir == "east" then
						x=x+e.reach.val
					-- elseif fDir == "west" then
					else
						x=x-e.reach.val
					end
				end
			end
			e.will.interactionTileX = math.floor(x / consts.tileSize) % self:getWorld().map.width
			e.will.interactionTileY = math.floor(y / consts.tileSize) % self:getWorld().map.height
		end
	end
end

return wills
