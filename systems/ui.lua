-- what's on screen is sent by other systems to this sytem, then what's done is acquired by other systems from this system
-- eg: inventory gets what's on the ground that can be picked up, sends that to ui, ui handles any inputs, wills takes those inputs and makes them into actions and then inventory takes those actions and makes them work

local concord = require("lib.concord")
local ui = concord.system({camera = {"camera", "inventory"}})

function ui:update(dt)
	local camera = self.camera[1]
	
	self.inventoryGrids = {}
	
	if camera then
		local cameraInventoryItems = {}
		for i, v in ipairs(camera.inventory.items) do
			cameraInventoryItems[i] = v
		end
		self.inventoryGrids.cameraInventory = {128, 20, 10, 10, cameraInventoryItems, camera.inventory.capacity}
	end
	if self.cameraPickupables then
		self.inventoryGrids.cameraPickupables = {20, 20, 10, 10, self.cameraPickupables, #self.cameraPickupables}
	end
	
	if not camera or not (camera and camera.inventory.isOpen) then
		self.currentInventoryGrid, self.currentInventoryGridSelector, self.selectedItem, self.selectedItemPos = nil
	end
	if self.changeGrid or not self.currentInventoryGrid then
		if camera and camera.inventory.isOpen then
			if not self.currentInventoryGridSelector then
				self.currentInventoryGridSelector = self.inventoryGrids.cameraInventory and "main"
			elseif self.currentInventoryGridSelector == "main" then
				if self.inventoryGrids.cameraPickupables then
					self.currentInventoryGridSelector = "pickupables"
					self.selectedItem, self.selectedItemPos = nil
				end
			elseif self.currentInventoryGridSelector == "pickupables" then
				if self.inventoryGrids.cameraInventory then
					self.currentInventoryGridSelector = "main"
					self.selectedItem, self.selectedItemPos = nil
				end
			end
		end
	end
	
	if self.currentInventoryGridSelector == "main" then
		self.currentInventoryGrid = self.inventoryGrids.cameraInventory
	elseif self.currentInventoryGridSelector == "pickupables" then
		self.currentInventoryGrid = self.inventoryGrids.cameraPickupables
	else
		self.currentInventoryGrid = nil
	end
	
	if self.currentInventoryGrid then
		if #self.currentInventoryGrid[5] == 0 then
			self.selectedItemPos = nil
			self.selectedItem = nil
		else
			if self.selectedItem then
				self.selectedItemPos = nil
				for i, v in ipairs(self.currentInventoryGrid[5]) do
					if v == self.selectedItem then
						self.selectedItemPos = i
					end
				end
				if not self.selectedItemPos then
					self.selectedItem = nil
				end
			end
			if not self.selectedItemPos then
				-- if self.selectorMove then
					self.selectedItemPos = 1
				-- end
			elseif self.selectorMove == "up" then
				self.selectedItemPos = math.max(self.selectedItemPos - self.currentInventoryGrid[1], 1)
			elseif self.selectorMove == "down" then
				self.selectedItemPos = math.min(self.selectedItemPos + self.currentInventoryGrid[1], #self.currentInventoryGrid[5])
			elseif self.selectorMove == "left" then
				self.selectedItemPos = math.max(self.selectedItemPos - 1, 1)
			elseif self.selectorMove == "right" then
				self.selectedItemPos = math.min(self.selectedItemPos + 1, #self.currentInventoryGrid[5])
			end
			if self.selectedItemPos then
				self.selectedItem = self.currentInventoryGrid[5][self.selectedItemPos]
			end
		end
	end
	
	if self.select and self.selectedItem then
		local moved = false
		if self.currentInventoryGridSelector == "pickupables" then
			if self:getWorld().inventory:giveItem(camera, self.selectedItem) then
				self:getWorld():removeEntity(self.selectedItem)
				moved = true
			end
		elseif self.currentInventoryGridSelector == "main" then
			if camera.position then
				local item = self:getWorld().inventory:takeItem(camera, self.selectedItem)
				self:getWorld().map:addItemToWorld(camera.position.x, camera.position.y, item)
				moved = true
			end
		end
		if moved then
			table.remove(self.currentInventoryGrid[5], self.selectedItemPos)
			self.selectedItem.moved = true -- necessary?
			if #self.currentInventoryGrid[5] > 0 then
				self.selectedItemPos = math.min(self.selectedItemPos, #self.currentInventoryGrid[5])
				self.selectedItem = self.currentInventoryGrid[5][self.selectedItemPos]
			else
				self.selectedItem = nil
				self.selectedItemPos = nil
			end
		end
	end
	
	if self.selectedItemPos then
		self.currentInventoryGrid[7] = self.selectedItemPos
	end
	
	for _, v in pairs(self.inventoryGrids) do
		v[8] = v == self.currentInventoryGrid
	end
	
	self.cameraPickupables = nil
	self.changeGrid = nil
	self.selectorMove = nil
	self.select = nil
end

return ui
