-----------------------------------------------------------------------------------------------
-- Client Lua Script for Observatory
-- Arkan 2014; MIT License.
-- Base file template provided by Gemini:Addon
-----------------------------------------------------------------------------------------------
 
local Observatory = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon("Observatory", false)

-----------------------------------------------------------------------------------------------
-- Initialisers
-----------------------------------------------------------------------------------------------
-- Called at init
function Observatory:OnInitialize()
	-- TODO: Event registration, hooks, frames, load XML, etc.
end

-- Called after player enters game world.
function Observatory:OnEnable()
	-- TODO: Finalise init cycle.
	Apollo.RegisterSlashCommand("obs", "OnObsCommand", self)
end

-----------------------------------------------------------------------------------------------
-- Handlers
-----------------------------------------------------------------------------------------------
function Observatory:OnObsCommand()
	Print("Observatory.")
end
