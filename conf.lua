local consts = require("consts")
local settings = require("settings")

-- settings("load")

function love.conf(t)
	t.title = "Tachy's Top-Down Game Test"
	-- t.identity = "tachytopdowngametest"
	t.appendidentity = true
	t.version = "11.3"
	-- t.window.icon = "icon.png"
	t.window.fullscreentype = "desktop"
	
	t.window.fullscreen = settings.graphics.fullscreen
	t.window.width = consts.gameCanvasWidth * settings.graphics.scale
	t.window.height = consts.gameCanvasHeight * settings.graphics.scale
end
