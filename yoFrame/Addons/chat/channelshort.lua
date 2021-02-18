local addon, ns = ...
local L, yo, n = unpack( ns)

if not yo.Chat.EnableChat then return end
----------------------------------------------------------------------------------------
--	Short channel name
----------------------------------------------------------------------------------------

local hooks = {}
local abbrev = {
	GUILD 	= "G",
	PARTY 	= "P",
	RAID 	= "R",
	OFFICER = "O",
	PARTY_LEADER 	= "PL",
	RAID_LEADER 	= "RL",
	INSTANCE_CHAT 	= "I",
	INSTANCE_CHAT_LEADER = "IL",
	PET_BATTLE_COMBAT_LOG = "PBC",
}

local function Abbreviate(channel)
    -- Replaces channel name from the table above, or uses channel numbers
    return string.format('|Hchannel:%s|h[%s]|h', channel, abbrev[channel] or channel:gsub('channel:', ''))
end

local function AddMessage(self, message, ...)
	if not message:find( L.chatLeft) then
		if not message:find( L.chatChange) then
    		message = message:gsub('|Hchannel:(.-)|h%[(.-)%]|h', Abbreviate)
    	end
    end

    return hooks[self](self, message, ...)
end

for index = 1, NUM_CHAT_WINDOWS do
    if(index ~= 2) then
        local frame = _G['ChatFrame'..index]
        hooks[frame] = frame.AddMessage
        frame.AddMessage = AddMessage
    end
end
