local concord = require("lib.concord")
local inventory = concord.system({items = {"item", "position"}, cameras = {"camera"}, pickuppers = {"inventory", "position", "reach", "will"}})

-- NOTE: if performance problems arise, use spatial hashing for item pickups

function inventory:update(dt)
	local cameraEntity = self.cameras[1]
	if self.toggleCommandSent then
		self.toggleCommandSent = false
		if cameraEntity then
			if cameraEntity.inventory then
				cameraEntity.inventory.isOpen = not cameraEntity.inventory.isOpen
			end
		end
	end
	if cameraEntity.inventory then
		-- TODO: it's spaghetti now
	end
end

return inventory
