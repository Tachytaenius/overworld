local newImage = love.graphics.newImage

local assets = {
	sprites = {
		islandGuy = newImage("assets/sprites/islandGuy.png"),
		player = newImage("assets/sprites/player.png")
	},
	terrain = {
		damage = {
			newImage("assets/terrain/damage/1.png"),
			newImage("assets/terrain/damage/2.png"),
			newImage("assets/terrain/damage/3.png")
		},
		dirt = newImage("assets/terrain/dirt.png"),
		grass = newImage("assets/terrain/grass.png"),
		floweredGrass = newImage("assets/terrain/floweredGrass.png"),
		pebbledGrass = newImage("assets/terrain/pebbledGrass.png"),
		rock = newImage("assets/terrain/rock.png"),
		tree = newImage("assets/terrain/tree.png"),
		treeStump = newImage("assets/terrain/treeStump.png")
	}
}

return assets
