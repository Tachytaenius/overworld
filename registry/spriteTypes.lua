local function isBlinking(e)
	return not e.life or e.blink.curCycleTimer < e.blink.curBlinkLength
end

local spriteTypes = {
	islandGuy = {
		size = 16,
		walkCycleStages = 4,
		poses = 4, -- shaved, shaved blinking, bearded, bearded blinking
		yOffset = -2,
		poseOffsetToUse = function(e)
			return "shaved" and 0
		end
	},
	player = {
		size = 16,
		walkCycleStages = 4,
		poses = 8, -- start capped, start blinking capped, happy capped, happy blinking capped, start, start blinking, happy, happy blinking
		yOffset = -2,
		poseOffsetToUse = function(e)
			local blink = isBlinking(e)
			return blink and 1 or 0
		end
	},
	-- tree = {
	-- 	size = 16,
	-- 	noRotation = true
	-- }
}

return spriteTypes
