local concord = require("lib.concord")
return concord.component("inventory", function(c, capacity, startItems, currentItem, isOpen)
	c.capacity = capacity
	c.items = startItems or {}
	c.currentItem = currentItem
	c.isOpen = isOpen
end)
