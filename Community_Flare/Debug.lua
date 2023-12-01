local ADDON_NAME, NS = ...

-- get locale
assert(NS.Libs)
local L = NS.Libs.AceLocale:GetLocale(ADDON_NAME)
if (not L) then
	-- finished
	return
end

-- localize stuff
local _G                                        = _G
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local SetBattlefieldScoreFaction                = _G.SetBattlefieldScoreFaction
local PvPGetActiveMatchState                    = _G.C_PvP.GetActiveMatchState
local PvPGetScoreInfo                           = _G.C_PvP.GetScoreInfo
local strformat                                 = _G.string.format
local strlower                                  = _G.string.lower
local tonumber                                  = _G.tonumber
local type                                      = _G.type

-- process debug arg1
function NS.CommunityFlare_Process_Debug_Command(sender, args)
	-- not debug mode?
	if (NS.db.profile.debugMode ~= true) then
		-- not enabled
		return
	end

	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender) == false) then
		-- finished
		return
	end

	-- verify debug!
	local command = strlower(args[1])
	if (command ~= "!debug") then
		-- finished
		return
	end

	-- process sub command
	local subcommand = strlower(args[2])
	if (subcommand == "numscores") then
		-- not active match?
		subcommand = "NumScores"
		if (PvPGetActiveMatchState() == Enum.PvPMatchState.Inactive) then
			-- send not in active match
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Not currently in an active match."], subcommand))
			return
		end

		-- send number of battlefield scores
		SetBattlefieldScoreFaction()
		local scores = GetNumBattlefieldScores()
		NS.CommunityFlare_SendMessage(sender, strformat("%s: %d", subcommand, scores))
	elseif (subcommand == "runtime") then
		-- not active match?
		subcommand = "RunTime"
		if (PvPGetActiveMatchState() == Enum.PvPMatchState.Inactive) then
			-- send not in active match
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Not currently in an active match."], subcommand))
			return
		end

		-- send battlefield run time
		local runtime = GetBattlefieldInstanceRunTime()
		NS.CommunityFlare_SendMessage(sender, strformat("%s: %d", subcommand, runtime))
	elseif (subcommand == "scoreinfo") then
		-- not active match?
		subcommand = "ScoreInfo"
		if (PvPGetActiveMatchState() == Enum.PvPMatchState.Inactive) then
			-- send not in active match
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Not currently in an active match."], subcommand))
			return
		end

		-- string value?
		if (type(args[3]) == "string") then
			-- convert to number
			args[3] = tonumber(args[3])
		end

		-- still not number?
		if (type(args[3]) ~= "number") then
			-- invalid index
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Invalid index!"], subcommand))
			return
		end

		-- get score info
		local info = PvPGetScoreInfo(args[3])
		if (not info) then
			-- not found
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Info not found!"], subcommand))
		else
			-- send score info
			NS.CommunityFlare_SendMessage(sender, strformat("%s: %s = %s; %s: %s; %s = %d; %s: %s", subcommand, L["Player"], info.name, L["GUID"], info.guid, L["Faction"], info.faction, L["Specialization"], info.talentSpec))
		end
	elseif (subcommand == "state") then
		-- not active match?
		subcommand = "State"
		if (PvPGetActiveMatchState() == Enum.PvPMatchState.Inactive) then
			-- send not in active match
			NS.CommunityFlare_SendMessage(sender, strformat(L["%s: Not currently in an active match."], subcommand))
			return
		end

		-- send active state
		local state = PvPGetActiveMatchState()
		NS.CommunityFlare_SendMessage(sender, strformat("%s: %d", subcommand, state))
	end
end
