local concord = require("lib.concord")
return concord.component("position", function(c, x, y)
	c.x, c.y = x, y
end)
