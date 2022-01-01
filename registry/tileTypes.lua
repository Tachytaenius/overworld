local tileTypes = {
	grass = {
		collision = false
	},
	floweredGrass = {
		collision = false,
		interact = {
			none = {
				items = {flower=5},
				newTile = "grass"
			}
		}
	},
	tree = {
		-- smallCollision = {
		-- 	x1 = 4, x2 = 12,
		-- 	y1 = 4, y2 = 12
		-- }
		collision = true,
		interact = {
			axe = {
				baseTime = 5,
				displayType = "healthBar",
				items = {wood=3,foliage=4},
				newTile = "treeStump"
			}
		}
	},
	treeStump = {
		-- smallCollision . . .
		collision = false,
		interact = {
			shovel = {
				baseTime = 8,
				items = {wood=1},
				newTile = "grass"
			}
		}
	},
	pebbledGrass = {
		collision = false,
		interact = {
			none = {
				items = {pebbles=4},
				newTile = "grass"
			}
		}
	},
	dirt = {
		collision = false
	},
	rock = {
		collision = true,
		interact = {
			pickaxe = {
				displayType = "cracks",
				baseTime = 12,
				items = {pebbles=20},
				newTile = "dirt"
			}
		}
	}
}

return tileTypes
