local AddonName, Engine = ...

local AceAddon = _G.LibStub('AceAddon-3.0')

local Addon = AceAddon:NewAddon(AddonName, 'AceConsole-3.0', 'AceEvent-3.0')
Engine[1] = Addon

-- TODO ace stuff & configurability
Addon.config = {
    eyefinity = true,
    ultrawide = true,
    UIScale = 1.0
}

function Addon:OnInitialize()
    self:RegisterEvent('UI_SCALE_CHANGED', 'ScaleChanged')
end
