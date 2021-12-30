local concord = require("lib.concord")
return concord.component("reach", function(c, length)
	c.val = length
end)
