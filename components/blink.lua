local concord = require("lib.concord")
return concord.component("blink", function(c, cycleLength, cycleLengthRandomness, blinkLength, blinkLengthRandomness, curCycleTimer, curBlinkLength)
	c.cycleLength, c.cycleLengthRandomness, c.blinkLength, c.blinkLengthRandomness = cycleLength, cycleLengthRandomness or 0, blinkLength, blinkLengthRandomness or 0
	c.curCycleTimer = curCycleTimer or 0
	c.curBlinkLength = curBlinkLength or blinkLength
end)
