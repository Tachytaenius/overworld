-- what's on screen is sent by other systems to this sytem, then what's done is acquired by other systems from this system
-- eg: inventory gets what's on the ground that can be picked up, sends that to ui, ui handles any inputs, wills takes those inputs and makes them into actions and then inventory takes those actions and makes them work

local concord = require("lib.concord")
local ui = concord.system({camera = {"camera", "inventory", "position", "reach", "will"}})

function ui:update(dt)
	-- self.selectedItem -- for persistence when the menu changes
	
	if self.cameraPickupables then
		self.inventoryGrid = {20, 20, 10, 10, self.cameraPickupables}
	end
	
	self.cameraPickupables = nil
end

return ui
