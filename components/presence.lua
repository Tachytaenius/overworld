local concord = require("lib.concord")
return concord.component("presence", function(c, sideLength)
	c.apothem = sideLength / 2
end)

