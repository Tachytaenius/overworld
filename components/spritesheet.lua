local concord = require("lib.concord")
return concord.component("spritesheet", function(c, name)
	c.val = name
end)
