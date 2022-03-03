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
		if e.inventory.isOpen then
			local ePickupables = {}
			local ex, ey = e.position.x, e.position.y
			for _, e2 in ipairs(self.items) do
				local dist = math.sqrt((ex - e2.position.x)^2 + (ey - e2.position.y)^2)
				if dist <= e.reach.itemPickupLength then
					ePickupables[#ePickupables+1] = e2
				end
			end
			table.sort(ePickupables, function(a, b)
				local distA = math.sqrt((ex - a.position.x)^2 + (ey - a.position.y)^2)
				local distB = math.sqrt((ex - b.position.x)^2 + (ey - b.position.y)^2)
				return distA < distB
			end)
			pickupables[e] = ePickupables
		end
	end
	if cameraEntity and cameraEntity.inventory and cameraEntity.position and cameraEntity.reach and cameraEntity.will then
		self:getWorld().ui.cameraPickupables = pickupables[cameraEntity] -- cleared every frame in case there is no longer a camera pickupper
	end
	self:getWorld().wills.pickupables = pickupables -- for AIs. sent every frame so not cleared in wills.lua
end

function inventory:giveItem(e, item) -- returns success as boolean
	if item.item then -- dropped item entity was passed
		if item.moved then return false end
		item = item.item
	end
	if not e.inventory then return false end
	if not (#e.inventory.items < e.inventory.capacity) then return false end
	e.inventory.items[#e.inventory.items + 1] = item
	return true -- use this to remove the item from wherever it is being taken from
end

function inventory:takeItem(e, item) -- returns item if successful, false if not
	if not e.inventory then return false end
	local place
	for i = 1, #e.inventory.items do
		if e.inventory.items[i] == item then
			place = i
		end
	end
	if not place then return false end
	local item2 = table.remove(e.inventory.items, place)
	assert(item == item2)
	return item2
end

return inventory
