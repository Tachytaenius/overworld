-- item stacks don't exist in the game. an entry like {type = "flower", quantity = 5} is copied 5 times with the quantity key removed. NOTE: shallow copy! If deep copy is needed later (i.e. if the structure of an item deepens) then the place to edit is systems/map.lua's map:update

local tileTypes = {
	grass = {
		collision = false
	},
	floweredGrass = {
		collision = false,
		interact = {
			none = {
				items = {{type = "flower", quantity = 5}},
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
				items = {{type = "wood", quantity = 3}, {type = "foliage", quantity = 4}},
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
				items = {{type = "wood", quantity = 1}},
				newTile = "grass"
			}
		}
	},
	-- pebbledGrass = {
	-- 	collision = false,
	-- 	interact = {
	-- 		none = {
	-- 			items = {pebbles=4},
	-- 			newTile = "grass"
	-- 		}
	-- 	}
	-- },
	dirt = {
		collision = false
	},
	rock = {
		collision = true,
		interact = {
			pickaxe = {
				displayType = "cracks",
				baseTime = 1,
				items = {{type = "cobble", quantity = 4}, {type = "pebble", quantity = 2}},
				newTile = "dirt"
			}
		}
	}
}

return tileTypes
