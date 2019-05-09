-- Implemented by DnJuses

require "/scripts/messageutil.lua"

local old = init;

function init()
  	old()
  	message.setHandler("getItemAmount", sendItemAmount) -- the 'player' class cannot be accessed in effect files, so we'll send an entity message to get what we need.
end

function sendItemAmount(messageType, isLocal, itemId) -- A reaction to 'getItemAmount' entity message. Returns an amount of itemId 
	if isLocal then
		if player.hasItem(itemId, true) then
			return player.hasCountOfItem(itemId, true)
		end
	end
	return 0
end


function update()
	local headPiece = player.equippedItem("head")
	local chestPiece = player.equippedItem("chest")
	local legsPiece = player.equippedItem("legs")
	-- Check if all 3 slots of armor are filled
	if isPlayerWearingFullArmor(headPiece, chestPiece, legsPiece) then
		-- Check if all 3 pieces belongs to same armor set
		if isFromSameArmorSet(headPiece, chestPiece, legsPiece) then
			local armorSetId = root.itemConfig(headPiece).config.armorSet -- Here we get an armor set id (those can be found in /items/armors/armor.sets)
	   		local armorSetConfig = root.assetJson("/items/armors/armor.sets") -- Asset json file containing all armor sets information, so now we can extract values from it.
	   		local setBonusEffect = armorSetConfig[armorSetId].effect -- Extracting 'effect' value
	   		status.setPersistentEffects("ARMOR SET BONUS", {setBonusEffect}) -- Apply set bonus effect as persistent effect, so we dont need to worry about duration and can easily remove this effect if needed
	   		return
	   	end
	end
	status.clearPersistentEffects("ARMOR SET BONUS") -- If player wears no sets - clear set bonus effects pool
end

function isPlayerWearingFullArmor(headPiece, chestPiece, legsPiece) -- check if player have equiped all 3 pieces of armor (e.g helmet, chestplate and pants)
	-- Is all equiped
	if headPiece and chestPiece and legsPiece then
	    return true
	end

	return false
end

function isFromSameArmorSet(headPiece, chestPiece, legsPiece) -- check if all 3 pieces of armor belongs to same armor set
	local headSetInfo = root.itemConfig(headPiece).config.armorSet
   	local chestSetInfo = root.itemConfig(chestPiece).config.armorSet
   	local legsSetInfo = root.itemConfig(legsPiece).config.armorSet
   	-- Is set piece have 'armorSet' value in its Json
   	if headSetInfo and chestSetInfo and legsSetInfo then
   		-- Is from same armor set
   		if headSetInfo == chestSetInfo and 
	   	   headSetInfo == legsSetInfo and
	   	   chestSetInfo == legsSetInfo then
	   		return true
	   	end
	end

	return false
end

function uninit()
	-- nothing to uninit
end

-- Implemented by DnJuses