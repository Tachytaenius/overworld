local concord = require("lib.concord")
return concord.component("sprite", function(c, name)
	c.val = name
end)
