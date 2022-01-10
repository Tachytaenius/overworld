local concord = require("lib.concord")
return concord.component("presence", function(c, sideLength, nonSolid)
	c.nonSolid = nonSolid
	c.apothem = sideLength / 2
end)

