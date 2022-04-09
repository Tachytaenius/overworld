-- TODO: automate

local newImage = love.graphics.newImage

local assets = {
	ui = {
		inventoryTiles = newImage("assets/ui/inventoryTiles.png"),
		itemSelector = newImage("assets/ui/itemSelector.png")
	},
	spritesheets = {
		islandGuy = newImage("assets/spritesheets/islandGuy.png"),
		player = newImage("assets/spritesheets/player.png")
	},
	items = {
		stoneAxe = newImage("assets/items/stoneAxe.png"),
		stonePickaxe = newImage("assets/items/stonePickaxe.png"),
		cobble = newImage("assets/items/cobble.png"),
		pebble = newImage("assets/items/pebble.png"),
		stick = newImage("assets/items/stick.png")
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
		-- pebbledGrass = newImage("assets/terrain/pebbledGrass.png"),
		rock = newImage("assets/terrain/rock.png"),
		tree = newImage("assets/terrain/tree.png"),
		treeStump = newImage("assets/terrain/treeStump.png")
	}
}

return assets
