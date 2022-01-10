love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setLineStyle("rough")

local concord = require("lib.concord")
package.loaded.systems = {}
package.loaded.assemblages = {}
concord.utils.loadNamespace("components")
concord.utils.loadNamespace("systems", package.loaded.systems)
concord.utils.loadNamespace("assemblages", package.loaded.assemblages)
local systems = require("systems")
local assemblages = require("assemblages")
require("monkeypatch")

local consts = require("consts")
local settings = require("settings")
-- local input = require("input")

local paused, world
function love.load(arg)
	world = concord.world()
	-- world.initialTreeCount = 1000
	world
	  -- :addSystem(systems.plants)
	  :addSystem(systems.inventory)
	  :addSystem(systems.metabolism)
	  :addSystem(systems.wills)
	  :addSystem(systems.movement)
	  :addSystem(systems.map)
	  :addSystem(systems.rendering)
	world:emit("newWorld", 512, 512)
	local player = concord.entity()
	player
	  :give("position", world.map.width*consts.tileSize/2+8, world.map.height*consts.tileSize/2+8)
	  :give("presence", 14)
	  :give("walk", 64)
	  :give("will")
	  :give("spritesheet", "islandGuy")
	  :give("player")
	  :give("camera")
	  :give("inventory", 5, nil, {type="stonePickaxe"})
	  :give("reach", 6)
	  :give("blink", 4, 1, 0.25, 0.1)
	  :give("life")
	world:addEntity(player)
	paused = false
end

function love.update(dt)
	world:emit("update", dt)
end

function love.draw()
	world:emit("draw")
	love.graphics.draw(world.rendering.output,
	  love.graphics.getWidth()/2 - (consts.gameCanvasWidth*settings.graphics.scale)/2, -- topLeftX == centreX - width/2
	  love.graphics.getHeight()/2 - (consts.gameCanvasHeight*settings.graphics.scale)/2,
	  0, settings.graphics.scale
	)
end

function love.keypressed(key, scancode)
	if key == settings.commands.openCloseInventory then
		world.inventory.toggleCommandSent = true -- gets false'd after being received
	end
end

function love.keyreleased(key, scancode)
	local displayChange = false
	if key == settings.commands.toggleFullscreen then
		settings.graphics.fullscreen = not settings.graphics.fullscreen
		displayChange = true
	elseif key == settings.commands.scaleUp then
		settings.graphics.scale = settings.graphics.scale + 1
		if not settings.graphics.fullscreen then
			displayChange = true
		end
	elseif key == settings.commands.scaleDown then
		if settings.graphics.scale ~= 1 then
			settings.graphics.scale = math.max(settings.graphics.scale - 1, 1)
			if not settings.graphics.fullscreen then
				displayChange = true
			end
		end
	end
	if displayChange then
		love.window.setMode(
		  consts.gameCanvasWidth * settings.graphics.scale,
		  consts.gameCanvasHeight * settings.graphics.scale,
		  {fullscreen = settings.graphics.fullscreen}
		)
	end
end

if true then return end

function love.run()
	love.load(love.arg.parseGameArguments(arg))
	local lag = consts.tickLength
	local updatesSinceLastDraw, lastLerp = 0, 1
	love.timer.step()
	
	return function()
		love.event.pump()
		for name, a,b,c,d,e,f in love.event.poll() do -- Events
			if name == "quit" then
				if not love.quit() then
					return a or 0
				end
			end
			love.handlers[name](a,b,c,d,e,f)
		end
		
		do -- Update
			local delta = love.timer.step()
			lag = math.min(lag + delta, consts.tickLength * consts.maxTicksPerFrame) -- NOTE: maxTicksPerFrame could be settings?
			local frames = math.floor(lag / consts.tickLength)
			lag = lag % consts.tickLength
			love.update(dt)
			if not paused then
				local start = love.timer.getTime()
				for _=1, frames do
					updatesSinceLastDraw = updatesSinceLastDraw + 1
					love.fixedUpdate(consts.tickLength)
				end
			end
		end
		
		if love.graphics.isActive() then -- Rendering
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
			
			local lerp = lag / consts.tickLength
			deltaDrawTime = ((lerp + updatesSinceLastDraw) - lastLerp) * consts.tickLength
			love.draw(lerp, deltaDrawTime)
			updatesSinceLastDraw, lastLerp = 0, lerp
			
			love.graphics.present()
		end
		
		love.timer.sleep(0.001)
	end
end

function love.quit()
	
end
