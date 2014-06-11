-- Lua Utils
-- Arkan 2014; MIT License.

local MAJOR, MINOR = "Arkan:Utils-1.0", 1
local APkg = Apollo.GetPackage(MAJOR)
if APkg and (APkg.nVersion or 0) >= MINOR then
	return -- no upgrade is needed
end
local Utils = APkg and APkg.tPackage or {}

require "ChatSystemLib"

function Utils.Log(sAddon, sStr)
	ChatSystemLib.PostOnChannel(ChatSystemLib.ChatChannel_System, tostring(sStr), sAddon)
end

function Utils.LogTable(sAddon, tTab)
	if tTab == nil then return end

	for k, v in pairs(tTab) do
		Utils.Log(sAddon, tostring(k).." : "..tostring(v))
	end
end

-- explode from http://lua-users.org/wiki/SplitJoin -- Lua is a silly language.
-- explode(seperator, string)
function Utils.Explode(sSep, sStr)
	local d, p = sSep, sStr
	local t, ll
	t={}
	ll=0
	if(#p == 1) then return {p} end
	while true do
		l=string.find(p,d,ll,true) -- find the next d in the string
		if l~=nil then -- if "not not" found then..
			table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
			ll=l+1 -- save just after where we found it for searching next time.
		else
			table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
			break -- Break at end, as it should be, according to the lua manual.
		end
	end
	return t
end

Apollo.RegisterPackage(Utils, MAJOR, MINOR, {})