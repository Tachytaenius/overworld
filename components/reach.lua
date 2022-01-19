local concord = require("lib.concord")
return concord.component("reach", function(c, interaction, itemPickup)
	c.interactionLength = interaction
	c.itemPickupLength = itemPickup
end)
