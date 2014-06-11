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
local RENDER_TRAITS = { -- f = field, hr = human-readable
	{f = "title", hr = "Full name/title"},
	{f = "shortdesc", hr = "Description"},
	{f = "bio", hr = "Biography"},
	{f = "rpstate", hr = "RP status"}
}

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
	self.playerProfile = { -- TODO: Save flags as well.
		fullname = player:GetName(),
		title = "",
		shortdesc = "",
		bio = ""
	}
	self:SyncProfileToRPC()
end

-----------------------------------------------------------------------------------------------
-- Handlers
-----------------------------------------------------------------------------------------------
function Observatory:OnObsCommand(...)
	local exp = Utils.Explode(" ", arg[2])
	if exp[1] and exp[1] == "set" then
		self:OnObsSetCommand(exp)
	elseif exp[1] and exp[1] == "get" then
		self:OnObsGetCommand(exp)
	elseif exp[1] and exp[1] == "help" then
		Utils.Log(MAJOR, "Observatory - RP profile manager/viewer.")
		Utils.Log(MAJOR, "/obs get [name] -- Get a summary of PC by name.")
		Utils.Log(MAJOR, "/obs set [var] [...] -- Set a variable. Valid vars:")
		Utils.Log(MAJOR, "fullname, title, shortdesc, bio")
	else
		Utils.Log(MAJOR, "No subcommand provided. Try /obs help")
	end
end

function Observatory:OnObsSetCommand(tExploded)
	local var = tExploded[2]
	local data = table.concat(tExploded, " ", 3)
	if var == nil then
		Utils.Log(MAJOR, "No variable specified. See /obs help")
		return
	end
	if not self:IsValidTrait(var) then
		Utils.Log(MAJOR, "Invalid variable, see /obs help: "..var)
		return
	end
	if data == nil then
		Utils.Log(MAJOR, "Something went horribly wrong, data is nil.")
		return
	end
	Utils.Log(MAJOR, "Updating "..var.." to: "..data)
	self:SetTrait(var, data)
end

function Observatory:OnObsGetCommand(tExploded)
	local name = tExploded[2]
	if name == nil then
		Utils.Log(MAJOR, "No name provided.")
		return
	end
	for _, r in pairs(RENDER_TRAITS) do
		local v = RPCore:GetTrait(name, r.f)
		if v ~= nil then
			Utils.Log(MAJOR, r.hr..": "..v)
		end
	end
end

-----------------------------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------------------------
function Observatory:SyncProfileToRPC()
	RPCore:SetLocalTrait(RPCore.Trait_Name, self.playerProfile.fullname)
	RPCore:SetLocalTrait(RPCore.Trait_NameAndTitle, self.playerProfile.title)
	--RPCore:SetLocalTrait(RPCore.Trait_RPState, self.playerProfile.rpstate) -- TODO: Find a better way to represent/do this.
	RPCore:SetLocalTrait(RPCore.Trait_Description, self.playerProfile.shortdesc)
	RPCore:SetLocalTrait(RPCore.Trait_Biography, self.playerProfile.bio)
end

function Observatory:SetTrait(sTrait, data)
	if sTrait == "rpstate" then
		Utils.Log(MAJOR, "Cannot set rpstate at this time. This will be fixed later in GUI form.") -- TODO: Find way to do this
		return
	end
	
	self.playerProfile[sTrait] = data
	self:SyncProfileToRPC()
end

function Observatory:IsValidTrait(sTrait)
	for k, _ in pairs(self.playerProfile) do
		if k == sTrait then return true end
	end
	return false
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



