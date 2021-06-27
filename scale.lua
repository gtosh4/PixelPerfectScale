local Addon = unpack(select(2, ...))

local min, max, format = min, max, format

local UIParent = UIParent
local InCombatLockdown = InCombatLockdown
local GetPhysicalScreenSize = GetPhysicalScreenSize

do
    local waitingCombat = false

    function Addon:UIScale()
        if InCombatLockdown() then
            waitingCombat = true
            self:RegisterEvent('PLAYER_REGEN_ENABLED', self.UIScale)
        else
            if UIParent:GetScale() ~= self.config.UIScale then
                UIParent:SetScale(self.config.UIScale)
                self:Printf('Set UIScale to %.4f', self.config.UIScale)
            end

            if waitingCombat then
                self:UnregisterEvent('PLAYER_REGEN_ENABLED')
                waitingCombat = false
            end
        end
    end
end

do
    local lower = 0.4
    local upper = 1.15
    local baseHeight = 768

    function Addon:PixelPerfectScale()
        return max(lower, min(upper, baseHeight / self.height))
    end
end

function Addon:ScaleChanged(event)
    if event == 'UI_SCALE_CHANGED' then
        local lastW, lastH = self.width, self.height
        self.width, self.height = GetPhysicalScreenSize()
        self.config.UIScale = self:PixelPerfectScale()

        if not lastW and not lastH then
            self:Printf(
                'Resolution updated to %dx%d. Computed UIScale: %.4f',
                self.width,
                self.height,
                self.config.UIScale
            )
        elseif self.width ~= lastW or self.height ~= lastH then
            self:Printf(
                'Resolution updated from %dx%d to %dx%d. Computed UIScale: %.4f',
                lastW or 0,
                lastH or 0,
                self.width,
                self.height,
                self.config.UIScale
            )
        end
    end

    self:UIScale()
end
