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
	local pickupables = {}
	for _, e in ipairs(self.pickuppers) do
		local ePickupables = {}
		local ex, ey = e.position.x, e.position.y
		for _, e2 in ipairs(self.items) do
			local dist = math.sqrt((ex - e2.position.x)^2 + (ey - e2.position.y)^2)
			if dist <= e.reach.itemPickupLength then
				ePickupables[#ePickupables+1] = e2
			end
		end
		pickupables[e] = ePickupables
	end
	if cameraEntity and cameraEntity.inventory and cameraEntity.position and cameraEntity.reach and cameraEntity.will then
		self:getWorld().ui.cameraPickupables = pickupables[cameraEntity] -- cleared every frame in case there is no longer a camera pickupper
	end
	self:getWorld().wills.pickupables = pickupables -- for AIs. sent every frame so not cleared in wills.lua
end

return inventory
