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
	
	rock = {
		collision = true
	}
}

return tileTypes
