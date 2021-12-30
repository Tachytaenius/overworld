local concord = require("lib.concord")
return concord.component("inventory", function(c, startItems, currentTool)
	c.items = startItems or {}
	c.currentTool = currentTool or "none"
end)
