local json = require("lib.json")

local settings = {}

settings.commands = {
	up = "w",
	down = "s",
	left = "a",
	right = "d",
	
	useTool = "space",
	
	toggleFullscreen = "f11",
	scaleUp = "f10",
	scaleDown = "f9"
}

settings.graphics = {
	scale = 2,
	fullscreen = false
}

return settings
