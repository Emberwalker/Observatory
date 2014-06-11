-----------------------------------------------------------------------------------------------
-- Client Lua Script for Observatory
-- Arkan 2014; MIT License.
-- Base file template provided by Gemini:Addon
-----------------------------------------------------------------------------------------------

require "GameLib"
 
local Observatory = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("Observatory", false)
local RPCore = Apollo.GetPackage("RPCore").tPackage
local Utils = Apollo.GetPackage("Arkan:Utils-1.0").tPackage

-----------------------------------------------------------------------------------------------
-- Constants
-----------------------------------------------------------------------------------------------
local MAJOR, MINOR = "Observatory", 1

-----------------------------------------------------------------------------------------------
-- Initialisers
-----------------------------------------------------------------------------------------------
-- Called at init
function Observatory:OnInitialize()
	-- TODO: Event registration, hooks, frames, load XML, etc.
	self:GenerateProfileMeta()
end

-- Called after player enters game world.
function Observatory:OnEnable()
	-- TODO: Finalise init cycle.
	Apollo.RegisterSlashCommand("obs", "OnObsCommand", self)
end

-----------------------------------------------------------------------------------------------
-- Setup agents
-----------------------------------------------------------------------------------------------
function Observatory:GenerateProfileMeta()
	local player = GameLib.GetPlayerUnit()
	self.playerProfile = {
		fullname = player:GetName(),
		title = "",
		rpstate = 0,
		shortdesc = "",
		bio = ""
	}
	self:SyncProfileToRPC()
end

-----------------------------------------------------------------------------------------------
-- Handlers
-----------------------------------------------------------------------------------------------
function Observatory:OnObsCommand(...)
	Utils.Log(MAJOR, "Observatory dbg:")
	Utils.LogTable(MAJOR, Utils.Explode(" ", arg[2]))
end

-----------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------
function Observatory:SyncProfileToRPC()
	RPCore:SetLocalTrait(RPCore.Trait_Name, self.playerProfile.fullname)
	RPCore:SetLocalTrait(RPCore.Trait_NameAndTitle, self.playerProfile.title)
	RPCore:SetLocalTrait(RPCore.Trait_RPState, self.playerProfile.rpstate)
	RPCore:SetLocalTrait(RPCore.Trait_Description, self.playerProfile.shortdesc)
	RPCore:SetLocalTrait(RPCore.Trait_Biography, self.playerProfile.bio)
end

function Observatory:SetTrait(sTrait, data)
	self.playerProfile[sTrait] = data
	self:SyncProfileToRPC()
end

-----------------------------------------------------------------------------------------------
-- Persistence
-----------------------------------------------------------------------------------------------
function Observatory:OnSave(eLevel)
	if eLevel ~= GameLib.CodeEnumAddonSaveLevel.General then return nil end
	return self.playerProfile
end

function Observatory:OnRestore(eLevel, tData)
	if eLevel ~= GameLib.CodeEnumAddonSaveLevel.General or not tData then return nil end
	self.playerProfile = tData
end



