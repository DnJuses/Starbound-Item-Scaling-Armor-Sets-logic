-- Implemented by DnJuses

require "/scripts/messageutil.lua"

local IApromise

function init()
	self.statGroup = effect.addStatModifierGroup({{stat = "protection", amount = 0}})
	self.itemId = config.getParameter("scaleItemId", "dirtmaterial")
	self.itemRequired = config.getParameter("scaleItemRequired", 100)
	self.scaleAmount = config.getParameter("scaleAmount", 1)
	self.maxScale = config.getParameter("scaleMax", 40)
end

function update(dt)
    IApromise = world.sendEntityMessage(entity.id(), "getItemAmount", self.itemId) -- "player" class cannot be accessed here, so we send an entity message to get item amount
    if IApromise and IApromise:finished() then
    	if IApromise:succeeded() then
    		local currentItemAmount = IApromise:result()
    		local totalDefenceScale = math.min(currentItemAmount / self.itemRequired * self.scaleAmount, self.maxScale)
    		effect.setStatModifierGroup(self.statGroup, {{stat = "protection", amount = totalDefenceScale}})
    	end
    end
end

-- Implemented by DnJuses
