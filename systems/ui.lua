-- what's on screen is sent by other systems to this sytem, then what's done is acquired by other systems from this system
-- eg: inventory gets what's on the ground that can be picked up, sends that to ui, ui handles any inputs, wills takes those inputs and makes them into actions and then inventory takes those actions and makes them work

local concord = require("lib.concord")
local ui = concord.system({camera = {"camera", "inventory", "position", "reach", "will"}})

function ui:update(dt)
	self.inventoryGrid = nil
	if self.cameraPickupables then
		self.inventoryGrid = {20, 20, 10, 10, self.cameraPickupables, #self.cameraPickupables, self.selectedItemPos}
	end
	
	if self.inventoryGrid then
		if #self.inventoryGrid[5] == 0 then
			self.selectedItemPos = nil
			self.selectedItem = nil
		else
			if self.selectedItem then
				self.selectedItemPos = nil
				for i, v in ipairs(self.inventoryGrid[5]) do
					if v == self.selectedItem then
						self.selectedItemPos = i
					end
				end
				if not self.selectedItemPos then
					self.selectedItem = nil
				end
			end
			if not self.selectedItemPos then
				if self.selectorMove then
					self.selectedItemPos = 1
				end
			elseif self.selectorMove == "up" then
				self.selectedItemPos = math.max(self.selectedItemPos - self.inventoryGrid[1], 1)
			elseif self.selectorMove == "down" then
				self.selectedItemPos = math.min(self.selectedItemPos + self.inventoryGrid[1], #self.inventoryGrid[5])
			elseif self.selectorMove == "left" then
				self.selectedItemPos = math.max(self.selectedItemPos - 1, 1)
			elseif self.selectorMove == "right" then
				self.selectedItemPos = math.min(self.selectedItemPos + 1, #self.inventoryGrid[5])
			end
			if self.selectedItemPos then
				self.selectedItem = self.inventoryGrid[5][self.selectedItemPos]
			end
		end
	end
	
	if self.select then
		local camera = self.camera[1]
		if camera and self.selectedItem then
			if self:getWorld().inventory:giveItem(camera, self.selectedItem) then
				table.remove(self.inventoryGrid[5], self.selectedItemPos)
				self:getWorld():removeEntity(self.selectedItem)
				self.selectedItem.item = nil
				self.selectedItem.taken = true -- necessary?
				if #self.inventoryGrid[5] > 0 then
					self.selectedItemPos = math.min(self.selectedItemPos, #self.inventoryGrid[5])
					self.selectedItem = self.inventoryGrid[5][self.selectedItemPos]
				else
					self.selectedItem = nil
					self.selectedItemPos = nil
				end
			end
		end
	end
	
	self.cameraPickupables = nil
	self.selectorMove = nil
	self.select = nil
end

return ui
