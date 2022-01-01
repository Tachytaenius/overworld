local concord = require("lib.concord")
return concord.component("interacting", function(c, tileX, tileY, displayType)
	c.tileX, c.tileY = tileX, tileY
	c.type = displayType
	c.progress = 0
end)
