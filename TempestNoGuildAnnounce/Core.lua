TempestNoGuildAnnounce = LibStub("AceAddon-3.0"):NewAddon("TempestNoGuildAnnounce", "AceConsole-3.0", "AceEvent-3.0")

local ace_config = LibStub("AceConfig-3.0")
local ace_config_dialog = LibStub("AceConfigDialog-3.0")

local defaults = {
	profile = {		
		enabled = true,
		shouldPrint = false
	},
}

local options = {
	name = "TempestNoGuildAnnounce",
	handler = TempestNoGuildAnnounce,
	type = "group",
	args = {		
		enabled = {
			type = "toggle",
			name = "Enabled?",
			desc = "Toggles enabling and disabling showing guild achievements.",
			get = "IsEnabled",
			set = "ToggleEnabled"
		},
		shouldPrint = {
        			type = "toggle",
        			name = "Should Print?",
        			desc = "Toggles printing guild achievements.",
        			get = "ShouldPrint",
        			set = "ToggleShouldPrint"
        		},
	},
}

function TempestNoGuildAnnounce:OnInitialize()
	-- Called when the addon is loaded
	self.db = LibStub("AceDB-3.0"):New("TNGADB", defaults, true)	
	ace_config:RegisterOptionsTable("TempestNoGuildAnnounce_options", options)
	
	self.optionsFrame = ace_config_dialog:AddToBlizOptions("TempestNoGuildAnnounce_options", "TempestNoGuildAnnounce")	
	self:RegisterChatCommand("tnga", "SlashCommand")
end

function TempestNoGuildAnnounce:OnEnable()
	
    local guildChatEventHandler = function(self,event,msg, author, ...)
        local chatFilter = function(self, event, msg, author)
            if TempestNoGuildAnnounce:IsEnabled() then
                if TempestNoGuildAnnounce:ShouldPrint() then
					TempestNoGuildAnnounce:Print(msg) 
                end
               return true 
            end            
        end
      ChatFrame_AddMessageEventFilter(event, chatFilter)
    end

	-- Called when the addon is enabled
	self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT", guildChatEventHandler)
	self:RegisterEvent("CHAT_MSG_ACHIEVEMENT", guildChatEventHandler)
	self:RegisterEvent("ACHIEVEMENT_EARNED", guildChatEventHandler)
end

function TempestNoGuildAnnounce:OnDisable()
	-- Called when the addon is disabled
end

function TempestNoGuildAnnounce:SlashCommand(msg)    
    Settings.OpenToCategory(self.optionsFrame.name)
end

function TempestNoGuildAnnounce:IsEnabled(info)
	return self.db.profile.enabled
end

function TempestNoGuildAnnounce:ToggleEnabled(info, value)
	self.db.profile.enabled = value
end

function TempestNoGuildAnnounce:ShouldPrint(info)
	return self.db.profile.shouldPrint
end

function TempestNoGuildAnnounce:ToggleShouldPrint(info, value)
	self.db.profile.shouldPrint = value
end