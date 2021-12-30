local concord = require("lib.concord")

local metabolism = concord.system({pool = {"life"}, blinkers = {"life", "blink"}})

function metabolism:update(dt)
	for _, e in ipairs(self.blinkers) do
		e.blink.curCycleTimer = e.blink.curCycleTimer - dt
		if e.blink.curCycleTimer < 0 then
			e.blink.curCycleTimer = e.blink.cycleLength + love.math.random() * e.blink.cycleLengthRandomness
			e.blink.curBlinkLength = e.blink.blinkLength + love.math.random() * e.blink.blinkLengthRandomness
		end
	end
end

return metabolism
