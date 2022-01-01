local concord = require("lib.concord")
return concord.component("inventory", function(c, startItems, currentItem)
	c.items = startItems or {}
	c.currentItem = currentItem
end)
