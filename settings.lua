local json = require("lib.json")

local settings = {}

settings.commands = {
	up = "w",
	down = "s",
	left = "a",
	right = "d",
	retainDirection = "lshift",
	useTool = "space",
	
	openCloseInventory = "i",
	
	toggleFullscreen = "f11",
	scaleUp = "f10",
	scaleDown = "f9"
}

settings.graphics = {
	scale = 3,
	fullscreen = false
}

return settings
