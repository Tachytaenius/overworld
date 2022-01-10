-- can be picked up as an item
local concord = require("lib.concord")
return concord.component("item", function(c, item)
	c.val = item
end)
