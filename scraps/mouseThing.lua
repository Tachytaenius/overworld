local canvasPosX, canvasPosY =
  love.graphics.getWidth()/2 - (consts.gameCanvasWidth*settings.graphics.scale)/2,
  love.graphics.getHeight()/2 - (consts.gameCanvasHeight*settings.graphics.scale)/2
local mouseTileX, mouseTileY =
  math.floor((love.mouse.getX() - canvasPosX - cameraPosX) / settings.graphics.scale / consts.tileSize),
  math.floor((love.mouse.getY() - canvasPosY - cameraPosY) / settings.graphics.scale / consts.tileSize)
local mouseTile = world.map.tiles[mouseTileX] and world.map.tiles[mouseTileX][mouseTileY]
if mouseTile then
	if love.mouse.isDown(1) then
		mouseTile.collision = true
	elseif love.mouse.isDown(2) then
		mouseTile.collision = false
	end
end
