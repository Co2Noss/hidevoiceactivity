local AceAddon = LibStub('AceAddon-3.0')
local AceDB = LibStub('AceDB-3.0')
local AceDBOptions = LibStub('AceDBOptions-3.0')
local AceConfig = LibStub('AceConfig-3.0')
local AceConfigDialog = LibStub('AceConfigDialog-3.0')

local LDB = LibStub("LibDataBroker-1.1")
local LDBI = LibStub("LibDBIcon-1.0")
local LQT = LibStub("LibQTip-1.0")

local ADDON_NAME = 'Hide Blizzard Voice Activity'
local ADDON_DB = 'HideBlizzardVoiceActivityDB'

local Addon = AceAddon:NewAddon(ADDON_NAME)
local theVersion = GetAddOnMetadata(ADDON_NAME, "Version")
local theNotes = GetAddOnMetadata(ADDON_NAME, "Notes")

local tmn_tooltip

--------------------------------------------------
-- defaults VoiceActivityManager:Hide()
--------------------------------------------------
local defaults = {
	profile = {
		minimapPos = 220,
		hide = false,
	},
}

--------------------------------------------------
-- LibDataBroker
--------------------------------------------------
local LDBButton = LDB:NewDataObject(ADDON_NAME, {
	type = "data source",
	icon = "Interface\\AddOns\\Hide Blizzard Voice Activity\\Images\\Icon",
	label = ADDON_NAME,
	text = ADDON_NAME
})

--------------------------------------------------
-- functions VoiceActivityManager:Hide()
--------------------------------------------------
function LDBButton:OnClick(button)
	-- left click for name toggle
	if (button == "LeftButton") then
		VoiceActivityManager:Hide()
        print("Voice Activity Disabled")
	end

	-- right click for config
	if (button == "RightButton") then
		VoiceActivityManager:Show()
        print("Voice Activity Enabled")
	end
end
--------------------------------------------------
--function LDBButton.OnLeave(self) end

--function tmn_OnOff(var)
	--if (GetCVar(var) == "1") then return "VoiceActivityManager:Show()" else return "VoiceActivityManager:Hide()" end
--end

--function Entry_OnMouseUp(frame, var, button)
	--if (button == "LeftButton") then
	--	ToggleVoice(var)
	--end
--end

--function ToggleVoice(var)
	--SetCVar(var, GetCVar(var) == "1" and 0 or 1)
--end

--------------------------------------------------
-- initialize
--------------------------------------------------
function Addon:OnInitialize()

	self.db = AceDB:New(ADDON_DB, defaults, true)
	LDBI:Register(ADDON_NAME, LDBButton, self.db.profile)

	local options = {
		name = ADDON_NAME,
		desc = theNotes,
		order = 0,
		type = 'group',
		args = {
			version = {
				order = 1,
				name = theVersion,
				type = 'description',
			},
			blankdesc1 = {
				order = 2,
				name = ' ',
				type = 'description',
			},
			show_minimap = {
				order = 3,
				name = 'Show Minimap Button',
				desc = 'Toggles the display of the minimap button',
				type = 'toggle',
				get = function()
					return not self.db.profile.hide
				end,
				set = function(_,v)
					self.db.profile.hide = not v
					if self.db.profile.hide then
						LDBI:Hide(ADDON_NAME)
					else
						LDBI:Show(ADDON_NAME)
					end
				end,
				width = 'normal',
			},
			blankdesc3 = {
				order = 4,
				name = ' ',
				type = 'description',
			},
			angle = {
				order = 5,
				name = 'Angle',
				desc = 'Set the angle for the minimap button',
				type = 'range',
				min = 0,
				max = 360,
				step = 1,
				get = function(f)
					return self.db.profile.minimapPos
				end,
				set = function(f, v)
					self.db.profile.minimapPos = v
					if not self.db.profile.hide then
						LDBI:Show(ADDON_NAME)
					end
				end,
			},
		},
	}

	AceConfig:RegisterOptionsTable(ADDON_NAME, options)
	AceConfigDialog:AddToBlizOptions(ADDON_NAME, ADDON_NAME)

end
