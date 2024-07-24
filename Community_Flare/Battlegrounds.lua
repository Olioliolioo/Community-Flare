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
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNInviteFriend                            = _G.BNInviteFriend
local BNRequestInviteFriend                     = _G.BNRequestInviteFriend
local CopyTable                                 = _G.CopyTable
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetDisplayedInviteType                    = _G.GetDisplayedInviteType
local GetLFGInfoServer                          = _G.GetLFGInfoServer
local GetLFGQueueStats                          = _G.GetLFGQueueStats
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetPVPRoles                               = _G.GetPVPRoles
local GetRaidRosterInfo                         = _G.GetRaidRosterInfo
local IsAddOnLoaded                             = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToAssistant                        = _G.PromoteToAssistant
local PromoteToLeader                           = _G.PromoteToLeader
local RaidWarningFrame_OnEvent                  = _G.RaidWarningFrame_OnEvent
local UnitFactionGroup                          = _G.UnitFactionGroup
local UnitGUID                                  = _G.UnitGUID
local UnitInRaid                                = _G.UnitInRaid
local UnitName                                  = _G.UnitName
local AreaPoiInfoGetAreaPOIForMap               = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                       = _G.C_PartyInfo.InviteUnit
local PvPGetActiveBrawlInfo                     = _G.C_PvP.GetActiveBrawlInfo
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPGetAvailableBrawlInfo                  = _G.C_PvP.GetAvailableBrawlInfo
local PvPGetScoreInfo                           = _G.C_PvP.GetScoreInfo
local PvPGetScoreInfoByPlayerGuid               = _G.C_PvP.GetScoreInfoByPlayerGuid
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local PvPIsInBrawl                              = _G.C_PvP.IsInBrawl
local TimerAfter                                = _G.C_Timer.After
local GetDoubleStatusBarWidgetVisualizationInfo = _G.C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo
local GetIconAndTextWidgetVisualizationInfo     = _G.C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo
local date                                      = _G.date
local ipairs                                    = _G.ipairs
local next                                      = _G.next
local pairs                                     = _G.pairs
local print                                     = _G.print
local time                                      = _G.time
local tonumber                                  = _G.tonumber
local tostring                                  = _G.tostring
local type                                      = _G.type
local mfloor                                    = _G.math.floor
local strformat                                 = _G.string.format
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split
local tinsert                                   = _G.table.insert
local tsort                                     = _G.table.sort

-- epic battlegrounds
NS.EpicBattlegrounds = {
	[1] = { id = 1, name = L["Random Epic Battleground"] },
	[2] = { id = 2, name = L["Alterac Valley"] },
	[3] = { id = 3, name = L["Isle of Conquest"] },
	[4] = { id = 4, name = L["Battle for Wintergrasp"] },
	[5] = { id = 5, name = L["Wintergrasp"] },
	[6] = { id = 6, name = L["Ashran"] },
	[7] = { id = 7, name = L["Korrak's Revenge"] },
}

-- random battlegrounds
NS.RandomBattlegrounds = {
	[1] = { id = 1, name = L["Random Battleground"] },
	[2] = { id = 2, name = L["Warsong Gulch"] },
	[3] = { id = 3, name = L["Arathi Basin"] },
	[4] = { id = 4, name = L["Eye of the Storm"] },
	[5] = { id = 5, name = L["The Battle for Gilneas"] },
	[6] = { id = 6, name = L["Twin Peaks"] },
	[7] = { id = 7, name = L["Silvershard Mines"] },
	[8] = { id = 8, name = L["Temple of Kotmogu"] },
	[9] = { id = 9, name = L["Seething Shore"] },
	[10] = { id = 10, name = L["Deepwind Gorge"] },
}

-- brawls
NS.Brawls = {
	[1] = { id = 1, name = "Brawl: Arathi Blizzard" },
	[2] = { id = 1, name = "Arathi Basin Winter" },
	[3] = { id = 2, name = "Brawl: Classic Ashran" },
	[4] = { id = 2, name = "Classic Ashran" },
	[5] = { id = 3, name = "Brawl: Comp Stomp" },
	[6] = { id = 3, name = "Comp Stomp" },
	[7] = { id = 4, name = "Brawl: Cooking: Impossible" },
	[8] = { id = 4, name = "Cooking: Impossible" },
	[9] = { id = 5, name = "Brawl: Deep Six" },
	[10] = { id = 5, name = "Deep Six" },
	[11] = { id = 6, name = "Brawl: Deepwind Dunk" },
	[12] = { id = 6, name = "Deepwind Dunk" },
	[13] = { id = 7, name = "Brawl: Gravity Lapse" },
	[14] = { id = 7, name = "Gravity Lapse" },
	[15] = { id = 8, name = "Brawl: Packed House" },
	[16] = { id = 8, name = "Packed House" },
	[17] = { id = 9, name = "Brawl: Shado-Pan Showdown" },
	[18] = { id = 9, name = "Shado-Pan Showdown" },
	[19] = { id = 10, name = "Brawl: Southshore vs. Tarren Mill" },
	[20] = { id = 10, name = "Southshore vs. Tarren Mill" },
	[21] = { id = 10, name = "Hillsbrad Foothills (Southshore vs. Tarren Mill)" },
	[22] = { id = 11, name = "Brawl: Temple of Hotmogu" },
	[23] = { id = 11, name = "Temple of Hotmogu" },
	[24] = { id = 12, name = "Brawl: Warsong Scramble" },
	[25] = { id = 12, name = "Warsong Scramble" },
}

-- is epic battleground?
function NS.CommunityFlare_IsEpicBG(name)
	-- no name given?
	if (not name) then
		-- nope
		return false
	end

	-- process all epic battlegrounds
	for k,v in ipairs(NS.EpicBattlegrounds) do
		-- matches?
		if (v.name == name) then
			-- yup
			return true
		end
	end

	-- nope
	return false
end

-- is random battleground?
function NS.CommunityFlare_IsRandomBG(name)
	-- no name given?
	if (not name) then
		-- nope
		return false
	end

	-- process all random battlegrounds
	for k,v in ipairs(NS.RandomBattlegrounds) do
		-- matches?
		if (v.name == name) then
			-- yup
			return true
		end
	end

	-- nope
	return false
end

-- is brawl?
function NS.CommunityFlare_IsBrawl(name)
	-- no name given?
	if (not name) then
		-- nope
		return false
	end


	-- process all brawls
	for k,v in ipairs(NS.Brawls) do
		-- matches?
		if (v.name == name) then
			-- yup
			return true
		end
	end

	-- nope
	return false
end

-- is tracked pvp?
function NS.CommunityFlare_IsTrackedPVP(name)
	-- check against tracked maps
	local isBrawl = NS.CommunityFlare_IsBrawl(name)
	local isEpicBattleground = NS.CommunityFlare_IsEpicBG(name)
	local isRandomBattleground = NS.CommunityFlare_IsRandomBG(name)

	-- is epic or random battleground?
	if ((isEpicBattleground == true) or (isRandomBattleground == true) or (isBrawl == true)) then
		-- tracked
		return true, isEpicBattleground, isRandomBattleground, isBrawl
	end

	-- nope
	return false, nil, nil, nil
end

-- is mercenary queued?
function NS.CommunityFlare_Battleground_IsMercenaryQueued()
	-- process all
	for k,v in pairs(NS.CommFlare.CF.LocalQueues) do
		-- mercenary?
		if (v.mercenary and (v.mercenary == true)) then
			-- yes
			return true
		end
	end

	-- no
	return false
end

-- initialize battleground status
function NS.CommunityFlare_Initialize_Battleground_Status()
	-- reset stuff
	NS.CommFlare.CF.MapID = 0
	NS.CommFlare.CF.AB = {}
	NS.CommFlare.CF.ASH = {}
	NS.CommFlare.CF.AV = {}
	NS.CommFlare.CF.BFG = {}
	NS.CommFlare.CF.DWG = {}
	NS.CommFlare.CF.EOTS = {}
	NS.CommFlare.CF.IOC = {}
	NS.CommFlare.CF.SSH = {}
	NS.CommFlare.CF.SSM = {}
	NS.CommFlare.CF.SSvTM = {}
	NS.CommFlare.CF.TOK = {}
	NS.CommFlare.CF.TWP = {}
	NS.CommFlare.CF.WG = {}
	NS.CommFlare.CF.WSG = {}
	NS.CommFlare.CF.MapInfo = {}
	NS.CommFlare.CF.MatchStartTime = 0
	NS.CommFlare.CF.Reloaded = false

	-- get MapID
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (NS.CommFlare.CF.MapID) then
		-- get map info
		NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
	end
end

-- reset battleground status
function NS.CommunityFlare_Reset_Battleground_Status()
	-- reset stuff
	NS.CommFlare.CF.Reloaded = false
end

-- get player raid rank
function NS.CommunityFlare_GetRaidRank(player)
	-- process all raid members
	for i=1, MAX_RAID_MEMBERS do
		local name, rank = GetRaidRosterInfo(i)
		if (player == name) then
			return rank
		end
	end
	return nil
end

-- promote player to raid leader
function NS.CommunityFlare_PromoteToRaidLeader(player)
	-- is player full name in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end

	-- try using short name
	local name, realm = strsplit("-", player)
	if (realm == NS.CommFlare.CF.PlayerServerName) then
		player = name
	end

	-- unit is in raid?
	if (UnitInRaid(player) ~= nil) then
		PromoteToLeader(player)
		return true
	end
	return false
end

-- get current roster list
function NS.CommunityFlare_Battlefield_Get_Current_Roster(type)
	-- inside battleground?
	local roster = {}
	if (PvPIsBattleground() == true) then
		-- horde only?
		if (type:find("Horde")) then
			-- get horde roster
			type = 0
		-- alliance only?
		elseif (type:find("Alliance")) then
			-- get alliance roster
			type = 1
		-- all roster
		else
			-- unset
			type = nil
		end

		-- process all scores
		for i=1, GetNumBattlefieldScores() do
			local info = PvPGetScoreInfo(i)
			if (info) then
				-- should log player?
				if (not type or (info.faction == type)) then
					-- force name-realm format
					local player = info.name
					if (not strmatch(player, "-")) then
						-- add realm name
						player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
					end

					-- get specID
					local specID = NS.CommunityFlare_Get_SpecID(info.className, info.talentSpec)
					if (specID and (specID > 0)) then
						-- append specID
						player = strformat("%s:%d", player, tonumber(specID))
					end

					-- insert
					tinsert(roster, player)
				end
			end
		end
	
		-- setup type
		if (type == 0) then
			-- horde
			type = "Horde"
		elseif (type == 1) then
			-- alliance
			type = "Alliance"
		else
			-- full
			type = "Full"
		end
	else
		-- process all
		for k,v in pairs(NS.CommFlare.CF.SocialQueues) do
			-- process queues
			local found = false
			for k2,v2 in ipairs(v.queues) do
				-- has queue data?
				local mapName = nil
				if (v2.queueData and v2.queueData.mapName) then
					-- save map name
					mapName = v2.queueData.mapName
				-- local queue?
				elseif (v2.name) then
					-- save map name
					mapName = v2.name
				end

				-- found map?
				if (mapName) then
					-- is tracked pvp?
					local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
					if (isTracked == true) then
						-- found
						found = true
					end
				end
			end

			-- found tracked queue?
			if (found == true) then
				-- get members
				for k2,v2 in ipairs(v.members) do
					-- insert player
					local player = strformat("%s-%s", v2.name, v2.realm)
					tinsert(roster, player)
				end
			end
		end

		-- setup type
		type = "Queued"
	end

	-- has roster?
	if (#roster > 0) then
		-- sort
		tsort(roster)

		-- process all
		local text = nil
		for k,v in ipairs(roster) do
			-- first?
			if (not text) then
				-- add first
				text = v
			else
				-- append
				text = strformat("%s;%s", text, v)
			end
		end

		-- return text
		return strformat("%s@%s", type, text)
	else
		-- none
		return strformat("%s@None", type)
	end
end

-- look for players with 0 damage and 0 healing
function NS.CommunityFlare_Check_For_Inactive_Players()
	-- has match started yet?
	if (PvPGetActiveMatchDuration() > 0) then
		-- calculate time elapsed
		NS.CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
		NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
		NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
		NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

		-- process all scores
		local count = 0
		for i=1, GetNumBattlefieldScores() do
			local info = PvPGetScoreInfo(i)
			if (info and info.name) then
				-- damage and healing done found?
				if ((info.damageDone ~= nil) and (info.healingDone ~= nil)) then
					-- both equal zero?
					if ((info.damageDone == 0) and (info.healingDone == 0)) then
						-- display
						print(strformat(L["%s: AFK after %d minutes, %d seconds?"], info.name, NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds))

						-- increase
						count = count + 1
					end
				end
			end
		end

		-- display
		print(strformat(L["Count: %d"], count))
	else
		-- display
		print(strformat(L["%s: Not currently in an active match."], NS.CommunityFlare_Title))
	end
end

-- get current battleground status
function NS.CommunityFlare_Get_Current_Battleground_Status()
	-- get best map for player
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not NS.CommFlare.CF.MapID) then
		-- failed
		return false
	end

	--get map info
	NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
	if (not NS.CommFlare.CF.MapInfo) then
		-- failed
		return false
	end

	-- alterac valley or korrak's revenge?
	if ((NS.CommFlare.CF.MapID == 91) or (NS.CommFlare.CF.MapID == 1537)) then
		-- initialize
		NS.CommFlare.CF.AV = {}
		NS.CommFlare.CF.AV.Counts = { Bunkers = 4, Towers = 4 }
		NS.CommFlare.CF.AV.Scores = { Alliance = L["N/A"], Horde = L["N/A"] }

		-- alterac valley?
		if (NS.CommFlare.CF.MapID == 91) then
			-- initialize bunkers
			NS.CommFlare.CF.AV.Bunkers = {
				[1] = { id = 1380, name = L["IWB"], status = L["Up"] },
				[2] = { id = 1352, name = L["North"], status = L["Up"] },
				[3] = { id = 1389, name = L["SHB"], status = L["Up"] },
				[4] = { id = 1355, name = L["South"], status = L["Up"] }
			}

			-- initialize towers
			NS.CommFlare.CF.AV.Towers = {
				[1] = { id = 1362, name = L["East"], status = L["Up"] },
				[2] = { id = 1377, name = L["IBT"], status = L["Up"] },
				[3] = { id = 1405, name = L["TP"], status = L["Up"] },
				[4] = { id = 1528, name = L["West"], status = L["Up"] }
			}
		else
			-- initialize bunkers
			NS.CommFlare.CF.AV.Bunkers = {
				[1] = { id = 6445, name = L["IWB"], status = L["Up"] },
				[2] = { id = 6422, name = L["North"], status = L["Up"] },
				[3] = { id = 6453, name = L["SHB"], status = L["Up"] },
				[4] = { id = 6425, name = L["South"], status = L["Up"] }
			}

			-- initialize towers
			NS.CommFlare.CF.AV.Towers = {
				[1] = { id = 6430, name = L["East"], status = L["Up"] },
				[2] = { id = 6442, name = L["IBT"], status = L["Up"] },
				[3] = { id = 6465, name = L["TP"], status = L["Up"] },
				[4] = { id = 6469, name = L["West"], status = L["Up"] }
			}
		end

		-- process bunkers
		for i,v in ipairs(NS.CommFlare.CF.AV.Bunkers) do
			NS.CommFlare.CF.AV.Bunkers[i].status = L["Up"]
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, NS.CommFlare.CF.AV.Bunkers[i].id)
			if (NS.CommFlare.CF.POIInfo) then
				NS.CommFlare.CF.AV.Bunkers[i].status = L["Destroyed"]
				NS.CommFlare.CF.AV.Counts.Bunkers = NS.CommFlare.CF.AV.Counts.Bunkers - 1
			end
		end

		-- process towers
		for i,v in ipairs(NS.CommFlare.CF.AV.Towers) do
			NS.CommFlare.CF.AV.Towers[i].status = L["Up"]
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, NS.CommFlare.CF.AV.Towers[i].id)
			if (NS.CommFlare.CF.POIInfo) then
				NS.CommFlare.CF.AV.Towers[i].status = L["Destroyed"]
				NS.CommFlare.CF.AV.Counts.Towers = NS.CommFlare.CF.AV.Counts.Towers - 1
			end
		end

		-- 1684 = widgetID for Score Remaining
		NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1684)
		if (NS.CommFlare.CF.WidgetInfo) then
			-- set proper scores
			NS.CommFlare.CF.AV.Scores = { Alliance = NS.CommFlare.CF.WidgetInfo.leftBarValue, Horde = NS.CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	-- ashran?
	elseif (NS.CommFlare.CF.MapID == 1478) then
		-- initialize
		if (not NS.CommFlare.CF.ASH) then
			NS.CommFlare.CF.ASH = { Jeron = L["Up"], Rylal = L["Up"] }
		end
		NS.CommFlare.CF.ASH.Scores = { Alliance = L["N/A"], Horde = L["N/A"] }

		-- reloaded?
		if (NS.CommFlare.CF.Reloaded == true) then
			-- match maybe reloaded, use saved session
			NS.CommFlare.CF.ASH.Jeron = NS.charDB.profile.ASH.Jeron
			NS.CommFlare.CF.ASH.Rylai = NS.charDB.profile.ASH.Rylai
		end

		-- 1997 = widgetID for Score Remaining
		NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1997)
		if (NS.CommFlare.CF.WidgetInfo) then
			-- set proper scores
			NS.CommFlare.CF.ASH.Scores = { Alliance = NS.CommFlare.CF.WidgetInfo.leftBarValue, Horde = NS.CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	-- battle for wintergrasp?
	elseif (NS.CommFlare.CF.MapID == 1334) then
		-- initialize
		NS.CommFlare.CF.WG = {}
		NS.CommFlare.CF.WG.Counts = { Towers = 0 }
		NS.CommFlare.CF.WG.Vehicles = { Alliance = L["N/A"], Horde = L["N/A"] }
		NS.CommFlare.CF.WG.TimeRemaining = L["Just entered match. Gates not opened yet!"]

		-- get match type
		NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
		NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, 6056) -- Wintergrasp Fortress Gate
		if (NS.CommFlare.CF.POIInfo and (NS.CommFlare.CF.POIInfo.textureIndex == 77)) then
			-- mercenary?
			if (NS.CommFlare.CF.HasAura == true) then
				NS.CommFlare.CF.WG.Type = L["Offense"]
			else
				NS.CommFlare.CF.WG.Type = L["Defense"]
			end
		else
			-- mercenary?
			if (NS.CommFlare.CF.HasAura == true) then
				NS.CommFlare.CF.WG.Type = L["Defense"]
			else
				NS.CommFlare.CF.WG.Type = L["Offense"]
			end
		end

		-- initialize towers
		NS.CommFlare.CF.WG.Towers = {
			[1] = { id = 6066, name = L["East"], status = L["Up"] },
			[2] = { id = 6065, name = L["South"], status = L["Up"] },
			[3] = { id = 6067, name = L["West"], status = L["Up"] }
		}

		-- process towers
		for i,v in ipairs(NS.CommFlare.CF.WG.Towers) do
			NS.CommFlare.CF.WG.Towers[i].status = L["Up"]
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, NS.CommFlare.CF.WG.Towers[i].id)
			if (NS.CommFlare.CF.POIInfo and (NS.CommFlare.CF.POIInfo.textureIndex == 51)) then
				NS.CommFlare.CF.WG.Towers[i].status = L["Destroyed"]
				NS.CommFlare.CF.WG.Counts.Towers = NS.CommFlare.CF.WG.Counts.Towers + 1
			end
		end

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 542 = widgetID for Horde Vehicle count
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(542)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.WG.Vehicles.Horde = NS.CommFlare.CF.WidgetInfo.text
			end

			-- 543 = widgetID for Alliance Vehicle count
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(543)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.WG.Vehicles.Alliance = NS.CommFlare.CF.WidgetInfo.text
			end

			-- 1612 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(1612)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.WG.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	-- isle of conquest?
	elseif (NS.CommFlare.CF.MapID == 169) then
		-- initialize settings
		NS.CommFlare.CF.IOC = {}
		NS.CommFlare.CF.IOC.Counts = { Alliance = 0, Horde = 0 }
		NS.CommFlare.CF.IOC.Scores = { Alliance = L["N/A"], Horde = L["N/A"] }

		-- initialize alliance gates
		NS.CommFlare.CF.IOC.AllianceGates = {
			[1] = { id = 2378, name = L["East"], status = L["Up"] },
			[2] = { id = 2379, name = L["Front"], status = L["Up"] },
			[3] = { id = 2381, name = L["West"], status = L["Up"] }
		}

		-- initialize horde gates
		NS.CommFlare.CF.IOC.HordeGates = {
			[1] = { id = 2374, name = L["East"], status = L["Up"] },
			[2] = { id = 2372, name = L["Front"], status = L["Up"] },
			[3] = { id = 2376, name = L["West"], status = L["Up"] }
		}

		-- process alliance gates
		for i,v in ipairs(NS.CommFlare.CF.IOC.AllianceGates) do
			NS.CommFlare.CF.IOC.AllianceGates[i].status = L["Up"]
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, NS.CommFlare.CF.IOC.AllianceGates[i].id)
			if (NS.CommFlare.CF.POIInfo) then
				NS.CommFlare.CF.IOC.AllianceGates[i].status = L["Destroyed"]
				NS.CommFlare.CF.IOC.Counts.Alliance = NS.CommFlare.CF.IOC.Counts.Alliance + 1
			end
		end

		-- process horde gates
		for i,v in ipairs(NS.CommFlare.CF.IOC.HordeGates) do
			NS.CommFlare.CF.IOC.HordeGates[i].status = L["Up"]
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, NS.CommFlare.CF.IOC.HordeGates[i].id)
			if (NS.CommFlare.CF.POIInfo) then
				NS.CommFlare.CF.IOC.HordeGates[i].status = L["Destroyed"]
				NS.CommFlare.CF.IOC.Counts.Horde = NS.CommFlare.CF.IOC.Counts.Horde + 1
			end
		end

		-- 1685 = widgetID for Score Remaining
		NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1685)
		if (NS.CommFlare.CF.WidgetInfo) then
			-- set proper scores
			NS.CommFlare.CF.IOC.Scores = { Alliance = NS.CommFlare.CF.WidgetInfo.leftBarValue, Horde = NS.CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	-- southshore vs tarren mill?
	elseif (NS.CommFlare.CF.MapID == 623) then
		-- initialize
		NS.CommFlare.CF.SSvTM = {}
		NS.CommFlare.CF.SSvTM.HordeScore = L["N/A"]
		NS.CommFlare.CF.SSvTM.AllianceScore = L["N/A"]
		NS.CommFlare.CF.SSvTM.TimeRemaining = L["Just entered match. Gates not opened yet!"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 788 = widgetID for Alliance score
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(788)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper alliance score
				NS.CommFlare.CF.SSvTM.AllianceScore = NS.CommFlare.CF.WidgetInfo.text
			end

			-- 789 = widgetID for Horde score
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(789)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper horde score
				NS.CommFlare.CF.SSvTM.HordeScore = NS.CommFlare.CF.WidgetInfo.text
			end

			-- 790 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(790)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.SSvTM.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	-- arathi basin?
	elseif (NS.CommFlare.CF.MapID == 1366) then
		-- initialize
		NS.CommFlare.CF.AB = {}
		NS.CommFlare.CF.AB.HordeScore = L["N/A"]
		NS.CommFlare.CF.AB.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1671 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1671)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.AB.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.AB.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- battle for gilneas?
	elseif (NS.CommFlare.CF.MapID == 275) then
		-- initialize
		NS.CommFlare.CF.BFG = {}
		NS.CommFlare.CF.BFG.HordeScore = L["N/A"]
		NS.CommFlare.CF.BFG.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1671 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1671)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.BFG.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.BFG.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- deepwind gorge?
	elseif (NS.CommFlare.CF.MapID == 1576) then
		-- initialize
		NS.CommFlare.CF.DWG = {}
		NS.CommFlare.CF.DWG.HordeScore = L["N/A"]
		NS.CommFlare.CF.DWG.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 2074 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(2074)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.DWG.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.DWG.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- eye of the storm?
	elseif (NS.CommFlare.CF.MapID == 112) then
		-- initialize
		NS.CommFlare.CF.EOTS = {}
		NS.CommFlare.CF.EOTS.HordeScore = L["N/A"]
		NS.CommFlare.CF.EOTS.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1671 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1671)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.EOTS.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.EOTS.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- seething shore?
	elseif (NS.CommFlare.CF.MapID == 907) then
		-- initialize
		NS.CommFlare.CF.SSH = {}
		NS.CommFlare.CF.SSH.HordeScore = L["N/A"]
		NS.CommFlare.CF.SSH.AllianceScore = L["N/A"]
		NS.CommFlare.CF.SSH.TimeRemaining = L["Just entered match. Gates not opened yet!"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1688 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1688)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.SSH.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.SSH.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end

			-- 1705 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(1705)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.SSH.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	-- silvershard mines?
	elseif (NS.CommFlare.CF.MapID == 423) then
		-- initialize
		NS.CommFlare.CF.SSM = {}
		NS.CommFlare.CF.SSM.HordeScore = L["N/A"]
		NS.CommFlare.CF.SSM.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1687 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1687)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.SSM.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.SSM.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- temple of kotmogu?
	elseif (NS.CommFlare.CF.MapID == 417) then
		-- initialize
		NS.CommFlare.CF.TOK = {}
		NS.CommFlare.CF.TOK.HordeScore = L["N/A"]
		NS.CommFlare.CF.TOK.AllianceScore = L["N/A"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1689 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1689)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.TOK.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.TOK.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end
		end

		-- success
		return true
	-- twin peaks?
	elseif (NS.CommFlare.CF.MapID == 206) then
		-- initialize
		NS.CommFlare.CF.TWP = {}
		NS.CommFlare.CF.TWP.HordeScore = L["N/A"]
		NS.CommFlare.CF.TWP.AllianceScore = L["N/A"]
		NS.CommFlare.CF.TWP.TimeRemaining = L["Just entered match. Gates not opened yet!"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 2 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(2)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.TWP.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.TWP.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end

			-- 6 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(6)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.TWP.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	-- warsong gulch?
	elseif (NS.CommFlare.CF.MapID == 1339) then
		-- initialize
		NS.CommFlare.CF.WSG = {}
		NS.CommFlare.CF.WSG.HordeScore = L["N/A"]
		NS.CommFlare.CF.WSG.AllianceScore = L["N/A"]
		NS.CommFlare.CF.WSG.TimeRemaining = L["Just entered match. Gates not opened yet!"]

		-- match started?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 2 = widgetID for Scores
			NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(2)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper scores
				NS.CommFlare.CF.WSG.AllianceScore = NS.CommFlare.CF.WidgetInfo.leftBarValue
				NS.CommFlare.CF.WSG.HordeScore = NS.CommFlare.CF.WidgetInfo.rightBarValue
			end

			-- 6 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(790)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.WSG.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
		end

		-- success
		return true
	end

	-- not reportable yet
	return false
end

-- count stuff in battlegrounds and promote to assists
function NS.CommunityFlare_Update_Battleground_Stuff(isPrint, bPromote)
	-- initialize full roster
	NS.CommFlare.CF.FullRoster = {}

	-- initialize community stuff
	NS.CommFlare.CF.CommCount = 0
	NS.CommFlare.CF.CommCounts = {}
	NS.CommFlare.CF.CommNames = {}
	NS.CommFlare.CF.CommNamesList = {}

	-- initialize mercenary stuff
	NS.CommFlare.CF.MercCount = 0
	NS.CommFlare.CF.MercCounts = {}
	NS.CommFlare.CF.MercNames = {}
	NS.CommFlare.CF.MercNamesList = {}

	-- initialize log list stuff
	NS.CommFlare.CF.LogListCount = 0
	NS.CommFlare.CF.LogListNamesList = {}

	-- initialize horde stuff
	NS.CommFlare.CF.Horde = {
		Count = 0,
		Healers = 0,
		Tanks = 0,
	}

	-- initialize alliance stuff
	NS.CommFlare.CF.Alliance = {
		Count = 0,
		Healers = 0,
		Tanks = 0,
	}

	-- get player stuff
	NS.CommFlare.CF.PlayerFaction = UnitFactionGroup("player")
	NS.CommFlare.CF.PlayerInfo = PvPGetScoreInfoByPlayerGuid(UnitGUID("player"))
	NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))

	-- process all raid members
	NS.CommFlare.CF.TeamUnits = {}
	for i=1, MAX_RAID_MEMBERS do
		-- found player / rank?
		local player, rank = GetRaidRosterInfo(i)
		if (player and rank) then
			-- force name-realm format
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
			end

			-- save friendly unit
			local unit = "raid" .. i
			NS.CommFlare.CF.TeamUnits[player] = { ["unit"] = unit, ["rank"] = rank }
		end
	end

	-- process all scores
	for i=1, GetNumBattlefieldScores() do
		local info = PvPGetScoreInfo(i)
		if (info) then
			-- save to full roster
			tinsert(NS.CommFlare.CF.FullRoster, info)

			-- has talent specialization?
			NS.CommFlare.CF.IsTank = false
			NS.CommFlare.CF.IsHealer = false
			if (info.talentSpec and (info.talentSpec ~= "")) then
				-- is healer or tank?
				NS.CommFlare.CF.IsTank = NS.CommunityFlare_IsTank(info.talentSpec)
				NS.CommFlare.CF.IsHealer = NS.CommunityFlare_IsHealer(info.talentSpec)
			-- has tank role?
			elseif (info.roleAssigned and (info.roleAssigned == 2)) then
				-- tank found
				NS.CommFlare.CF.IsTank = true
			-- has healer role?
			elseif (info.roleAssigned and (info.roleAssigned == 4)) then
				-- healer found
				NS.CommFlare.CF.IsHealer = true
			end

			-- alliance faction?
			local mercenary = false
			if (info.faction == 1) then
				-- increase alliance counts
				NS.CommFlare.CF.Alliance.Count = NS.CommFlare.CF.Alliance.Count + 1
				if (NS.CommFlare.CF.IsHealer == true) then
					NS.CommFlare.CF.Alliance.Healers = NS.CommFlare.CF.Alliance.Healers + 1
				elseif (NS.CommFlare.CF.IsTank == true) then
					NS.CommFlare.CF.Alliance.Tanks = NS.CommFlare.CF.Alliance.Tanks + 1
				end

				-- player is horde?
				if (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
					-- mercenary
					mercenary = true
				end
			-- horde faction?
			elseif (info.faction == 0) then
				-- increase horde counts
				NS.CommFlare.CF.Horde.Count = NS.CommFlare.CF.Horde.Count + 1
				if (NS.CommFlare.CF.IsHealer == true) then
					NS.CommFlare.CF.Horde.Healers = NS.CommFlare.CF.Horde.Healers + 1
				elseif (NS.CommFlare.CF.IsTank == true) then
					NS.CommFlare.CF.Horde.Tanks = NS.CommFlare.CF.Horde.Tanks + 1
				end

				-- player is alliance?
				if (NS.CommFlare.CF.PlayerFaction == L["Alliance"]) then
					-- mercenary
					mercenary = true
				end
			end

			-- force name-realm format
			local player = info.name
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
			end

			-- get community member
			NS.CommunityFlare_Process_MemberGUID(info.guid, player)
			local member = NS.CommunityFlare_GetCommunityMember(player)
			if (member and member.name and member.clubs) then
				-- mercenary?
				if (mercenary == true) then
					-- process all clubs
					for k,v in pairs(member.clubs) do
						-- mercenary counts setup?
						if (not NS.CommFlare.CF.MercCounts[k]) then
							-- initialize
							NS.CommFlare.CF.MercCounts[k] = 0
						end

						-- increase
						NS.CommFlare.CF.MercCounts[k] = NS.CommFlare.CF.MercCounts[k] + 1

						-- mercenary names setup?
						if (not NS.CommFlare.CF.MercNames[k]) then
							-- initialize
							NS.CommFlare.CF.MercNames[k] = {}
						end

						-- insert
						tinsert(NS.CommFlare.CF.MercNames[k], member.name)
					end

					-- update stuff
					tinsert(NS.CommFlare.CF.MercNamesList, member.name)
					NS.CommFlare.CF.MercCount = NS.CommFlare.CF.MercCount + 1
				else
					-- process all clubs
					for k,v in pairs(member.clubs) do
						-- community counts setup?
						if (not NS.CommFlare.CF.CommCounts[k]) then
							-- initialize
							NS.CommFlare.CF.CommCounts[k] = 0
						end

						-- increase
						NS.CommFlare.CF.CommCounts[k] = NS.CommFlare.CF.CommCounts[k] + 1

						-- community names setup?
						if (not NS.CommFlare.CF.CommNames[k]) then
							-- initialize
							NS.CommFlare.CF.CommNames[k] = {}
						end

						-- insert
						tinsert(NS.CommFlare.CF.CommNames[k], member.name)
					end

					-- update stuff
					tinsert(NS.CommFlare.CF.CommNamesList, member.name)
					NS.CommFlare.CF.CommCount = NS.CommFlare.CF.CommCount + 1
				end

				-- should log list / i.e. has shared community?
				if (NS.CommunityFlare_Get_LogList_Status(player) == true) then
					-- update
					tinsert(NS.CommFlare.CF.LogListNamesList, player)
					NS.CommFlare.CF.LogListCount = NS.CommFlare.CF.LogListCount + 1

					-- should promote?
					if (bPromote == true) then
						-- player has raid leader?
						if (NS.CommFlare.CF.PlayerRank == 2) then
							-- only allow leaders?
							NS.CommFlare.CF.AutoPromote = false
							if (NS.charDB.profile.communityAutoAssist == 2) then
								-- player is community leader?
								if (NS.CommunityFlare_IsCommunityLeader(player) == true) then
									-- auto promote
									NS.CommFlare.CF.AutoPromote = true
								end
							-- allow all members?
							elseif (NS.charDB.profile.communityAutoAssist == 3) then
								-- auto promote
								NS.CommFlare.CF.AutoPromote = true
							end

							-- auto promote?
							if (NS.CommFlare.CF.AutoPromote == true) then
								-- found raid unit / rank?
								if (NS.CommFlare.CF.TeamUnits[player] and NS.CommFlare.CF.TeamUnits[player].unit and NS.CommFlare.CF.TeamUnits[player].rank) then
									-- already assist?
									if (NS.CommFlare.CF.TeamUnits[player].rank >= 1) then
										-- disable promote
										NS.CommFlare.CF.AutoPromote = false
									end
								end
							end

							-- auto promote?
							if (NS.CommFlare.CF.AutoPromote == true) then
								-- promote
								PromoteToAssistant(info.name)
							end
						end
					end
				end
			end
		end
	end

	-- has mercenaries?
	if (NS.CommFlare.CF.MercCount > 0) then
		-- sort mercenary names
		for k,v in pairs(NS.CommFlare.CF.MercNames) do
			-- sort club names
			tsort(NS.CommFlare.CF.MercNames[k])
		end

		-- sort mercenary names list
		tsort(NS.CommFlare.CF.MercNamesList)
	end

	-- has community players?
	if (NS.CommFlare.CF.CommCount > 0) then
		-- sort community names
		for k,v in pairs(NS.CommFlare.CF.CommNames) do
			-- sort club names
			tsort(NS.CommFlare.CF.CommNames[k])
		end

		-- sort community names
		tsort(NS.CommFlare.CF.CommNamesList)
	end

	-- has log list?
	if (NS.CommFlare.CF.LogListCount > 0) then
		-- sort log list names
		tsort(NS.CommFlare.CF.LogListNamesList)
	end

	-- get current number of scores
	NS.CommFlare.CF.NumScores = GetNumBattlefieldScores()

	-- should print?
	if (isPrint == true) then
		-- no scores yet?
		if (NS.CommFlare.CF.NumScores == 0) then
			-- not in battleground yet
			print(strformat(L["%s: Not in battleground yet."], NS.CommunityFlare_Title))
		else
			-- display results staggered
			local timer = 0.0
			TimerAfter(timer, function()
				-- display faction results
				print(strformat(L["%s: Healers = %d, Tanks = %d"], L["Horde"], NS.CommFlare.CF.Horde.Healers, NS.CommFlare.CF.Horde.Tanks))
				print(strformat(L["%s: Healers = %d, Tanks = %d"], L["Alliance"], NS.CommFlare.CF.Alliance.Healers, NS.CommFlare.CF.Alliance.Tanks))
			end)

			-- next
			timer = timer + 0.1

			-- has mercenary players?
			if (NS.CommFlare.CF.MercCount > 0) then
				-- display community names?
				if (NS.charDB.profile.communityDisplayNames == true) then
					-- build mercenary list
					local list = nil
					for k,v in pairs(NS.CommFlare.CF.MercNamesList) do
						-- list still empty? start it!
						if (list == nil) then
							list = tostring(v)
						else
							list = strformat("%s, %s", tostring(list), tostring(v))
						end
					end

					-- found merc list?
					if (list ~= nil) then
						-- display results staggered
						TimerAfter(timer, function()
							-- display community mercenaries
							print(strformat(L["Community Mercenaries: %s"], list))
						end)

						-- next
						timer = timer + 0.1
					end
				end

				-- found mercenary counts?
				if (NS.CommFlare.CF.MercCounts and next(NS.CommFlare.CF.MercCounts)) then
					-- build count list
					local list = nil
					for k,v in pairs(NS.CommFlare.CF.MercCounts) do
						-- has community?
						if (NS.globalDB.global.clubs[k] and NS.globalDB.global.clubs[k].name) then
							-- add to list
							if (list == nil) then
								list = strformat("%s = %d", NS.globalDB.global.clubs[k].name, tonumber(v))
							else
								list = strformat("%s, %s = %d", list, NS.globalDB.global.clubs[k].name, tonumber(v))
							end
						end
					end

					-- found list?
					if (list ~= nil) then
						-- display results staggered
						TimerAfter(timer, function()
							-- display community counts
							print(strformat(L["Mercenary Counts: %s"], list))
						end)

						-- next
						timer = timer + 0.1
					end
				end

				-- display results staggered
				TimerAfter(timer, function()
					-- display mercs count
					print(strformat(L["Total Mercenaries: %d"], NS.CommFlare.CF.MercCount))
				end)

				-- next
				timer = timer + 0.1
			end

			-- has community players?
			if (NS.CommFlare.CF.CommCount > 0) then
				-- display community names?
				if (NS.charDB.profile.communityDisplayNames == true) then
					-- build member list
					local list = nil
					for k,v in pairs(NS.CommFlare.CF.CommNamesList) do
						-- list still empty? start it!
						if (list == nil) then
							list = tostring(v)
						else
							list = strformat("%s, %s", tostring(list), tostring(v))
						end
					end

					-- found list?
					if (list ~= nil) then
						-- display results staggered
						TimerAfter(timer, function()
							-- display community members
							print(strformat(L["Community Members: %s"], list))
						end)

						-- next
						timer = timer + 0.1
					end
				end

				-- found community counts?
				if (NS.CommFlare.CF.CommCounts and next(NS.CommFlare.CF.CommCounts)) then
					-- build count list
					local list = nil
					for k,v in pairs(NS.CommFlare.CF.CommCounts) do
						-- has community?
						if (NS.globalDB.global.clubs[k] and NS.globalDB.global.clubs[k].name) then
							-- add to list
							if (list == nil) then
								list = strformat("%s = %d", NS.globalDB.global.clubs[k].name, tonumber(v))
							else
								list = strformat("%s, %s = %d", list, NS.globalDB.global.clubs[k].name, tonumber(v))
							end
						end
					end

					-- found list?
					if (list ~= nil) then
						-- display results staggered
						TimerAfter(timer, function()
							-- display community counts
							print(strformat(L["Community Counts: %s"], list))
						end)

						-- next
						timer = timer + 0.1
					end
				end

				-- display results staggered
				TimerAfter(timer, function()
					-- display community count
					print(strformat(L["Total Members: %d"], NS.CommFlare.CF.CommCount))
				end)

				-- next
				timer = timer + 0.1
			end
		end
	end
end

-- log match list
function NS.CommunityFlare_Log_Match_List(list)
	-- purge older
	local timestamp = time()
	for k,v in pairs(NS.globalDB.global.matchLogList) do
		-- older found?
		if (not v.timestamp or (k > 1000000)) then
			-- delete
			NS.globalDB.global.matchLogList[k] = nil
		else
			-- older than 7 days?
			local older = v.timestamp + (7 * 86400)
			if (timestamp > older) then
				-- delete
				NS.globalDB.global.matchLogList[k] = nil
			end
		end
	end

	-- get MapID
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (NS.CommFlare.CF.MapID) then
		-- get map info
		NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
	end

	-- build entry
	local player = NS.CommunityFlare_GetPlayerName("full")
	local entry = {
		["timestamp"] = timestamp,
		["message"] = strformat(L["Date: %s; MapName: %s; Player: %s; Roster: %s"], NS.CommFlare.CF.MatchStartDate, NS.CommFlare.CF.MapInfo.name, player, list),
	}

	-- insert
	tinsert(NS.globalDB.global.matchLogList, entry)
end

-- match started, log roster
function NS.CommunityFlare_Match_Started_Log_Roster()
	-- has log list?
	if (NS.CommFlare.CF.LogListCount > 0) then
		-- already logged?
		if (NS.CommFlare.CF.MatchStartLogged == true) then
			-- has match start / end times?
			if (NS.CommFlare.CF.MatchEndTime > 0) then
				-- calculate time
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.MatchEndTime - NS.CommFlare.CF.MatchStartTime
				NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

				-- save duration
				local index = #NS.globalDB.global.matchLogList
				NS.globalDB.global.matchLogList[index].duration = strformat("%d minutes, %d seconds", NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
			end

			-- finished
			NS.CommFlare.CF.MatchStartLogged = false
			return
		end

		-- build log list
		local list = nil
		for k,v in pairs(NS.CommFlare.CF.LogListNamesList) do
			-- list still empty? start it!
			if (list == nil) then
				list = v
			else
				list = list .. ", " .. v
			end
		end

		-- found log list?
		if (list ~= nil) then
			-- has proper date?
			if (NS.CommFlare.CF.MatchStartDate and (NS.CommFlare.CF.MatchStartDate ~= "")) then
				-- log match list
				NS.CommunityFlare_Log_Match_List(list)

				-- logged
				NS.CommFlare.CF.MatchStartLogged = true
			end
		end
	end
end

-- process pass leadership
function NS.CommunityFlare_Process_Pass_Leadership(sender)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender) == false) then
		-- finished
		return
	end

	-- setup player / sender
	local player = NS.CommunityFlare_GetPlayerName("full")
	if (type(sender) == "number") then
		-- get from battle net
		sender = NS.CommunityFlare_GetBNetFriendName(sender)
	-- no realm name?
	elseif (not strmatch(sender, "-")) then
		-- add realm name
		sender = sender .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- inside battleground?
	if (PvPIsBattleground() == true) then
		-- player is not community leader?
		if (NS.CommunityFlare_IsCommunityLeader(player) == false) then
			-- does player have raid leadership?
			NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
			if (NS.CommFlare.CF.PlayerRank == 2) then
				-- sender is community leader?
				if (NS.CommunityFlare_IsCommunityLeader(sender) == true) then
					-- promote
					NS.CommunityFlare_PromoteToRaidLeader(sender)
				end
			end
		end
	else
		-- not sending to yourself?
		local shouldPromote = false
		if (player ~= sender) then
			-- get player / member
			player = NS.CommunityFlare_GetCommunityMember(player)
			local member = NS.CommunityFlare_GetCommunityMember(sender)
			if (member) then
				-- player not member?
				if (not player) then
					-- should promote
					shouldPromote = true
				else
					-- no member priority?
					if (not member.priority or (member.priority == 0)) then
						member.priority = 999
					end

					-- no player priority?
					if (not player.priority or (player.priority == 0)) then
						player.priority = 999
					end

					-- higher priority?
					if (member.priority <= player.priority) then
						-- should promote
						shouldPromote = true
					end
				end
			end

			-- should promote?
			if (shouldPromote == true) then
				-- promote to party leader
				NS.CommunityFlare_PromoteToPartyLeader(sender)
			end
		end
	end
end

-- process auto invite
function NS.CommunityFlare_Process_Auto_Invite(sender)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender) == false) then
		-- finished
		return
	end

	-- number?
	if (type(sender) == "number") then
		-- battle net auto invite enabled?
		if (NS.charDB.profile.bnetAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- can not invite while in a battleground
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a battleground now."])
			-- inside brawl?
			elseif (PvPIsInBrawl() == true) then
				-- can not invite while in a brawl
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a brawl now."])
			else
				-- get bnet friend index
				local index = BNGetFriendIndex(sender)
				if (index ~= nil) then
					-- process all bnet accounts logged in
					local numGameAccounts = BattleNetGetFriendNumGameAccounts(index)
					for i=1, numGameAccounts do
						-- check if account has player guid online
						local accountInfo = BattleNetGetFriendGameAccountInfo(index, i)
						if (accountInfo.playerGuid) then
							-- party is full?
							local maxCount = NS.CommunityFlare_GetMaxPartyCount()
							if ((GetNumGroupMembers() > (maxCount - 1)) or PartyInfoIsPartyFull()) then
								-- force to max
								NS.CommFlare.CF.Count = maxCount

								-- group full
								NS.CommunityFlare_SendMessage(sender, L["Sorry, group is currently full."])
							else
								-- really has room?
								if (NS.CommFlare.CF.Count < maxCount) then
									-- increase
									NS.CommFlare.CF.Count = NS.CommFlare.CF.Count + 1

									-- get invite type
									local inviteType = GetDisplayedInviteType(accountInfo.playerGuid)
									if ((inviteType == "INVITE") or (inviteType == "SUGGEST_INVITE")) then
										BNInviteFriend(accountInfo.gameAccountID)
									elseif (inviteType == "REQUEST_INVITE") then
										BNRequestInviteFriend(accountInfo.gameAccountID)
									end
								end
							end

							-- finished
							return
						end
					end
				end
			end
		else
			-- auto invite not enabled
			NS.CommunityFlare_SendMessage(sender, L["Sorry, Battle.NET auto invite not enabled."])
		end
	else
		-- community auto invite enabled?
		if (NS.charDB.profile.communityAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- can not invite while in a battleground
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a battleground now."])
			-- inside brawl?
			elseif (PvPIsInBrawl() == true) then
				-- can not invite while in a brawl
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a brawl now."])
			else
				-- is sender a community member?
				NS.CommFlare.CF.AutoInvite = NS.CommunityFlare_IsCommunityMember(sender)
				if (NS.CommFlare.CF.AutoInvite == true) then
					-- group is full?
					local maxCount = NS.CommunityFlare_GetMaxPartyCount()
					if ((GetNumGroupMembers() > (maxCount - 1)) or PartyInfoIsPartyFull()) then
						-- force to max
						NS.CommFlare.CF.Count = maxCount

						-- group full
						NS.CommunityFlare_SendMessage(sender, L["Sorry, group is currently full."])
					else
						-- really has room?
						if (NS.CommFlare.CF.Count < maxCount) then
							-- increase
							NS.CommFlare.CF.Count = NS.CommFlare.CF.Count + 1

							-- invite the user
							PartyInfoInviteUnit(sender)
						end
					end
				end
			end
		else
			-- auto invite not enabled
			NS.CommunityFlare_SendMessage(sender, L["Sorry, community auto invite not enabled."])
		end
	end
end

-- get battleground status
function NS.CommunityFlare_Get_Battleground_Status()
	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- get current battleground status
		local text = nil
		local status = NS.CommunityFlare_Get_Current_Battleground_Status()
		if (status == true) then
			-- update battleground stuff / counts
			NS.CommunityFlare_Update_Battleground_Stuff(false, false)

			-- get MapID
			NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
			if (NS.CommFlare.CF.MapID) then
				-- get map info
				NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
			end

			-- has match started yet?
			NS.CommFlare.CF.NeedAddonData = false
			local duration = PvPGetActiveMatchDuration()
			if (duration > 0) then
				-- calculate time elapsed
				NS.CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
				NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
				NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

				-- alterac valley or korrak's revenge?
				if ((NS.CommFlare.CF.MapID == 91) or (NS.CommFlare.CF.MapID == 1537)) then
					-- set text to alterac valley status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s; %s = %d/4; %s = %d/4; %d %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.AV.Scores.Alliance,
						L["Horde"], NS.CommFlare.CF.AV.Scores.Horde,
						L["Bunkers Left"], NS.CommFlare.CF.AV.Counts.Bunkers,
						L["Towers Left"], NS.CommFlare.CF.AV.Counts.Towers,
						NS.CommFlare.CF.CommCount, L["Community Members"])
				-- ashran?
				elseif (NS.CommFlare.CF.MapID == 1478) then
					-- set text to ashran status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s; %s = %s; %s = %s; %d %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.ASH.Scores.Alliance,
						L["Horde"], NS.CommFlare.CF.ASH.Scores.Horde,
						L["Jeron"], NS.CommFlare.CF.ASH.Jeron,
						L["Rylai"], NS.CommFlare.CF.ASH.Rylai,
						NS.CommFlare.CF.CommCount, L["Community Members"])
				-- battle for wintergrasp?
				elseif (NS.CommFlare.CF.MapID == 1334) then
					-- set text to wintergrasp status
					text = strformat("%s (%s): %s; %s = %d %s, %d %s; %s %s; %s %s; %s: %d/3; %d %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.WG.Type,
						NS.CommFlare.CF.WG.TimeRemaining, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.WG.Vehicles.Alliance,
						L["Horde"], NS.CommFlare.CF.WG.Vehicles.Horde,
						L["Towers Destroyed"], NS.CommFlare.CF.WG.Counts.Towers,
						NS.CommFlare.CF.CommCount, L["Community Members"])
				-- isle of conquest?
				elseif (NS.CommFlare.CF.MapID == 169) then
					-- issue capping gate request command
					NS.CommFlare.CF.NeedAddonData = true
					NS.CommFlare:SendCommMessage("Capping", "gr", "INSTANCE_CHAT")

					-- set text to isle of conquest status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s: %d/3; %s = %s; %s: %d/3; %d %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.IOC.Scores.Alliance,
						L["Gates Destroyed"], NS.CommFlare.CF.IOC.Counts.Alliance,
						L["Horde"], NS.CommFlare.CF.IOC.Scores.Horde,
						L["Gates Destroyed"], NS.CommFlare.CF.IOC.Counts.Horde,
						NS.CommFlare.CF.CommCount, L["Community Members"])
				-- southshore vs tarren mill?
				elseif (NS.CommFlare.CF.MapID == 623) then
					-- set text to southshore vs tarren mill status
					text = strformat("%s: %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.SSvTM.TimeRemaining,
						L["Alliance"], NS.CommFlare.CF.SSvTM.AllianceScore,
						L["Horde"], NS.CommFlare.CF.SSvTM.HordeScore)
				-- arathi basin?
				elseif (NS.CommFlare.CF.MapID == 1366) then
					-- set text to arathi basin status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.AB.AllianceScore,
						L["Horde"], NS.CommFlare.CF.AB.HordeScore)
				-- battle for gilneas?
				elseif (NS.CommFlare.CF.MapID == 275) then
					-- set text to battle for gilneas status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.BFG.AllianceScore,
						L["Horde"], NS.CommFlare.CF.BFG.HordeScore)
				-- deepwind gorge?
				elseif (NS.CommFlare.CF.MapID == 1576) then
					-- set text to deepwind gorge status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.DWG.AllianceScore,
						L["Horde"], NS.CommFlare.CF.DWG.HordeScore)
				-- eye of the storm?
				elseif (NS.CommFlare.CF.MapID == 112) then
					-- set text to deepwind gorge status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.EOTS.AllianceScore,
						L["Horde"], NS.CommFlare.CF.EOTS.HordeScore)
				-- seething shore?
				elseif (NS.CommFlare.CF.MapID == 907) then
					-- set text to seething shore status
					text = strformat("%s: %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.SSH.TimeRemaining,
						L["Alliance"], NS.CommFlare.CF.SSH.AllianceScore,
						L["Horde"], NS.CommFlare.CF.SSH.HordeScore)
				-- silvershard mines?
				elseif (NS.CommFlare.CF.MapID == 423) then
					-- set text to deepwind gorge status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.SSM.AllianceScore,
						L["Horde"], NS.CommFlare.CF.SSM.HordeScore)
				-- temple of kotmogu?
				elseif (NS.CommFlare.CF.MapID == 417) then
					-- set text to temple of kotmogu status
					text = strformat("%s: %s = %d %s, %d %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Alliance"], NS.CommFlare.CF.TOK.AllianceScore,
						L["Horde"], NS.CommFlare.CF.TOK.HordeScore)
				-- twin peaks?
				elseif (NS.CommFlare.CF.MapID == 206) then
					-- set text to twin peaks status
					text = strformat("%s: %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.TWP.TimeRemaining,
						L["Alliance"], NS.CommFlare.CF.TWP.AllianceScore,
						L["Horde"], NS.CommFlare.CF.TWP.HordeScore)
				-- warsong gulch?
				elseif (NS.CommFlare.CF.MapID == 1339) then
					-- set text to warsong gulch status
					text = strformat("%s: %s; %s = %s; %s = %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.WSG.TimeRemaining,
						L["Alliance"], NS.CommFlare.CF.WSG.AllianceScore,
						L["Horde"], NS.CommFlare.CF.WSG.HordeScore)
				end
			else
				-- set text to gates not opened yet
				text = strformat("%s: %s (%d %s)",
					NS.CommFlare.CF.MapInfo.name, L["Just entered match. Gates not opened yet!"],
					NS.CommFlare.CF.CommCount, L["Community Members"])
			end
		else
			-- set text to not an epic battleground
			text = strformat(L["%s: Not an epic battleground to track."], NS.CommFlare.CF.MapInfo.name)
		end

		-- return text
		return text
	else
		-- check for queued battleground
		local text = {}
		local reported = false
		NS.CommFlare.CF.Leader = NS.CommunityFlare_GetPartyLeader()
		for i=1, GetMaxBattlefieldID() do
			-- queued and tracked?
			local status, mapName = GetBattlefieldStatus(i)
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
			if ((status == "queued") and (isTracked == true)) then
				-- reported
				reported = true

				-- set text to time in queue
				NS.CommFlare.CF.Timer.MilliSeconds = GetBattlefieldTimeWaited(i)
				NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
				NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)
				text[i] = strformat(L["%s has been queued for %d %s and %d %s for %s."],
					NS.CommFlare.CF.Leader,
					NS.CommFlare.CF.Timer.Minutes, L["minutes"],
					NS.CommFlare.CF.Timer.Seconds, L["seconds"],
					mapName)
			end
		end

		-- return text
		return text
	end
end

-- get status
function NS.CommunityFlare_Get_Status()
	-- get battleground status
	local text = NS.CommunityFlare_Get_Battleground_Status()
	if (text) then
		-- still in queue?
		if (type(text) == "table") then
			-- process all
			local status = nil
			for k,v in pairs(text) do
				-- none yet?
				if (not status) then
					-- initialize
					status = v
				else
					-- append
					status = strformat("%s@%s", status, v)
				end
			end

			-- none found?
			if (not status) then
				-- not currently in queue
				status = L["Not currently in an epic battleground or queue!"]
			end

			-- copy status
			text = status
		end
	end

	-- return text
	return text
end

-- process status check
function NS.CommunityFlare_Process_Status_Check(sender)
	-- has sender?
	if (sender) then
		-- no shared community?
		if (NS.CommunityFlare_HasSharedCommunity(sender) == false) then
			-- finished
			return
		end
	end

	-- inside battleground?
	local text = NS.CommunityFlare_Get_Battleground_Status()
	if (type(text) == "string") then
		-- has sender?
		if (sender) then
			-- add to table for later
			NS.CommFlare.CF.StatusCheck[sender] = time()
		end

		-- send text to sender
		NS.CommunityFlare_SendMessage(sender, text)
	-- still in queue?
	elseif (type(text) == "table") then
		-- has sender?
		if (sender) then
			-- process all
			local timer = 0.0
			local reported = false
			for k,v in pairs(text) do
				-- reported
				reported = true

				-- send replies staggered
				TimerAfter(timer, function()
					-- report queue time
					NS.CommunityFlare_SendMessage(sender, v)
				end)

				-- next
				timer = timer + 0.2
			end

			-- not reported?
			if (reported == false) then
				-- not currently in queue
				NS.CommunityFlare_SendMessage(sender, L["Not currently in an epic battleground or queue!"])
			end
		end
	end
end

-- report joined with estimated time
function NS.CommunityFlare_Report_Joined_With_Estimated_Time(index)
	-- clear role chosen table
	NS.CommFlare.CF.RoleChosen = {}

	-- brawl?
	NS.CommFlare.CF.PlayerFaction = UnitFactionGroup("player")
	if (index == "Brawl") then
		-- get brawl info
		local brawlInfo
		if (PvPIsInBrawl() == true) then
			brawlInfo = PvPGetActiveBrawlInfo()
		else
			brawlInfo = PvPGetAvailableBrawlInfo()
		end

		-- is tracked pvp?
		local mapName = brawlInfo.name
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- get lfg queue stats
			local hasData, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType, instanceSubType, instanceName, averageWait, tankWait, healerWait, damageWait, myWait, queuedTime = GetLFGQueueStats(LE_LFG_CATEGORY_BATTLEFIELD)
			if (hasData and averageWait) then
				-- get estimated time
				local shouldReport = false
				local text = NS.CommunityFlare_GetGroupCount()
				NS.CommFlare.CF.Timer.MilliSeconds = averageWait * 1000

				-- calculate minutes / seconds
				NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
				NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

				-- player is horde?
				if (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
					-- horde
					text = strformat("%s %s", text, L["Horde"])
				-- player is alliance?
				elseif (NS.CommFlare.CF.PlayerFaction == L["Alliance"]) then
					-- alliance
					text = strformat("%s %s", text, L["Alliance"])
				end

				-- finalize text
				local time_waited = strformat(L["%d minutes, %d seconds"], NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
				text = strformat(L["%s Joined Queue For %s! Estimated Wait: %s!"], text, mapName, time_waited)

				-- no specializations found? (probably solo Q)
				if ((NS.CommFlare.CF.LocalData.NumTanks == 0) and (NS.CommFlare.CF.LocalData.NumHealers == 0) and (NS.CommFlare.CF.LocalData.NumDPS == 0)) then
					-- get pvp roles
					local isTank, isHealer, isDamage = GetPVPRoles()

					-- tank?
					if (isTank == true) then
						-- tank spec
						NS.CommFlare.CF.LocalData.NumTanks = 1
					end
	
					-- tank?
					if (isHealer == true) then
						-- header spec
						NS.CommFlare.CF.LocalData.NumHealers = 1
					end

					-- dps?
					if (isDamage == true) then
						-- header spec
						NS.CommFlare.CF.LocalData.NumDPS = 1
					end
				end

				-- add tanks / heals / dps counts
				if ((NS.CommFlare.CF.LocalData.NumTanks > 0) or (NS.CommFlare.CF.LocalData.NumHealers > 0) or (NS.CommFlare.CF.LocalData.NumDPS > 0)) then
					-- add counts
					text = strformat(L["%s [%d Tanks, %d Healers, %d DPS]"], text, NS.CommFlare.CF.LocalData.NumTanks, NS.CommFlare.CF.LocalData.NumHealers, NS.CommFlare.CF.LocalData.NumDPS)
				end

				-- check if group has room for more
				local maxCount = NS.CommunityFlare_GetMaxPartyCount()
				if (NS.CommFlare.CF.Count < maxCount) then
					-- community auto invite enabled?
					if (NS.charDB.profile.communityAutoInvite == true) then
						-- update text
						text = strformat("%s (%s)", text, L["For auto invite, whisper me INV"])
					end
				end

				-- send to community
				NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
			end
		end
	else
		-- is tracked pvp?
		local status, mapName = GetBattlefieldStatus(index)
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- get estimated time
			local shouldReport = false
			local text = NS.CommunityFlare_GetGroupCount()
			NS.CommFlare.CF.Timer.MilliSeconds = GetBattlefieldEstimatedWaitTime(index)
			if (NS.CommFlare.CF.Timer.MilliSeconds > 0) then
				-- calculate minutes / seconds
				NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
				NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
				NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

				-- player is horde?
				if (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
					-- horde
					text = strformat("%s %s", text, L["Horde"])
				-- player is alliance?
				elseif (NS.CommFlare.CF.PlayerFaction == L["Alliance"]) then
					-- alliance
					text = strformat("%s %s", text, L["Alliance"])
				end

				-- mercenary queue?
				local time_waited = strformat(L["%d minutes, %d seconds"], NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
				if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
					-- finalize text
					text = strformat(L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"], text, mapName, time_waited)
				else
					-- finalize text
					text = strformat(L["%s Joined Queue For %s! Estimated Wait: %s!"], text, mapName, time_waited)
				end
			else
				-- increase
				NS.CommFlare.CF.EstimatedWaitTime = NS.CommFlare.CF.EstimatedWaitTime + 1

				-- should try again?
				if (NS.CommFlare.CF.EstimatedWaitTime < 5) then
					-- try again
					TimerAfter(0.2, function ()
						-- call again
						NS.CommunityFlare_Report_Joined_With_Estimated_Time(index)
					end)
					return
				end

				-- player is horde?
				if (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
					-- horde
					text = strformat("%s %s", text, L["Horde"])
				else
					-- alliance
					text = strformat("%s %s", text, L["Alliance"])
				end

				-- mercenary queue?
				if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
					-- finalize text
					text = strformat(L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"], text, mapName, L["N/A"])
				else
					-- finalize text
					text = strformat(L["%s Joined Queue For %s! Estimated Wait: %s!"], text, mapName, L["N/A"])
				end
			end

			-- no specializations found? (probably solo Q)
			if ((NS.CommFlare.CF.LocalData.NumTanks == 0) and (NS.CommFlare.CF.LocalData.NumHealers == 0) and (NS.CommFlare.CF.LocalData.NumDPS == 0)) then
				-- get pvp roles
				local isTank, isHealer, isDamage = GetPVPRoles()

				-- tank?
				if (isTank == true) then
					-- tank spec
					NS.CommFlare.CF.LocalData.NumTanks = 1
				end
	
				-- tank?
				if (isHealer == true) then
					-- header spec
					NS.CommFlare.CF.LocalData.NumHealers = 1
				end

				-- dps?
				if (isDamage == true) then
					-- header spec
					NS.CommFlare.CF.LocalData.NumDPS = 1
				end
			end

			-- add tanks / heals / dps counts
			if ((NS.CommFlare.CF.LocalData.NumTanks > 0) or (NS.CommFlare.CF.LocalData.NumHealers > 0) or (NS.CommFlare.CF.LocalData.NumDPS > 0)) then
				-- add counts
				text = strformat(L["%s [%d Tanks, %d Healers, %d DPS]"], text, NS.CommFlare.CF.LocalData.NumTanks, NS.CommFlare.CF.LocalData.NumHealers, NS.CommFlare.CF.LocalData.NumDPS)
			end

			-- check if group has room for more
			local maxCount = NS.CommunityFlare_GetMaxPartyCount()
			if (NS.CommFlare.CF.Count < maxCount) then
				-- community auto invite enabled?
				if (NS.charDB.profile.communityAutoInvite == true) then
					-- update text
					text = strformat("%s (%s)", text, L["For auto invite, whisper me INV"])
				end
			end

			-- send to community
			NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
		end
	end
end

-- update battlefield status
function NS.CommunityFlare_Update_Battlefield_Status(index)
	-- queue left or missed?
	local status, mapName, _, _, suspendedQueue, queueType = GetBattlefieldStatus(index)
	if ((status == "none") and NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].name and (NS.CommFlare.CF.LocalQueues[index].name ~= "")) then
		-- update map name
		mapName = NS.CommFlare.CF.LocalQueues[index].name
	end

	-- is tracked pvp?
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- has leader GUID?
		local leaderGUID = NS.CommFlare.CF.LeaderGUID
		if (not leaderGUID) then
			-- use player
			leaderGUID = UnitGUID("player")
		end

		-- queued?
		local partyGUID = NS.CommunityFlare_GetPartyGUID()
		if (status == "queued") then
			-- just entering queue?
			if (not NS.CommFlare.CF.LocalQueues[index] or not NS.CommFlare.CF.LocalQueues[index].name or (NS.CommFlare.CF.LocalQueues[index].name == "")) then
				-- does the player have the mercenary buff?
				local mercenary = false
				NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
				if (NS.CommFlare.CF.HasAura == true) then
					-- mercenary
					mercenary = true
				end

				-- add to queues
				NS.CommFlare.CF.LocalQueues[index] = {
					["name"] = mapName,
					["created"] = time(),
					["entered"] = false,
					["joined"] = true,
					["mercenary"] = mercenary,
					["popped"] = 0,
					["status"] = status,
					["suspended"] = false,
					["type"] = queueType,
				}

				-- update local group
				NS.CommunityFlare_Update_Group("local")

				-- reset stuff
				NS.CommFlare.CF.LeftTime = 0
				NS.CommFlare.CF.EnteredTime = 0
				NS.CommFlare.CF.CurrentPopped = {}

				-- push data
				local timestamp = time()
				local count = NS.CommunityFlare_GetGroupCount()
				NS.CommFlare.CF.LeaderGUID = NS.CommunityFlare_GetPartyLeaderGUID()
				local guids = strformat("%s,%s", NS.CommFlare.CF.LeaderGUID, partyGUID)
				NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Queued@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, timestamp, count, guids))

				-- delay some
				TimerAfter(0.5, function()
					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- report joined queue with estimated time
							NS.CommFlare.CF.EstimatedWaitTime = 0
							NS.CommunityFlare_Report_Joined_With_Estimated_Time(index)
						end
					end
				end)
			else
				-- has queue paused?
				if ((suspendedQueue == true) and (NS.CommFlare.CF.LocalQueues[index].suspended == false)) then
					-- queue has paused
					NS.CommFlare.CF.LocalQueues[index].suspended = true

					-- queue paused warning enabled?
					if (NS.charDB.profile.warningQueuePaused == true) then
						-- are you group leader?
						local text = strformat(L["Queue for %s has paused!"], mapName)
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- issue local raid warning (with raid warning audio sound)
							RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", text)

							-- check for offline players
							NS.CommunityFlare_Process_Party_States(false, true)
						else
							-- display warning
							print(strformat("%s: %s", NS.CommunityFlare_Title, text))
						end
					end
				-- has queue unpaused?
				elseif ((suspendedQueue == false) and (NS.CommFlare.CF.LocalQueues[index].suspended == true)) then
					-- queue has resumed
					NS.CommFlare.CF.LocalQueues[index].suspended = false

					-- queue paused warning enabled?
					if (NS.charDB.profile.warningQueuePaused == true) then
						-- are you group leader?
						local text = strformat(L["Queue for %s has resumed!"], mapName)
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- issue local raid warning (with raid warning audio sound)
							RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", text)
						else
							-- display warning
							print(strformat("%s: %s", NS.CommunityFlare_Title, text))
						end
					end
				end
			end
		-- confirm?
		elseif (status == "confirm") then
			-- queue just popped?
			if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].popped and (NS.CommFlare.CF.LocalQueues[index].popped == 0)) then
				-- update local group
				NS.CommFlare.CF.LocalQueues[index].popped = time()
				NS.CommFlare.CF.SocialQueues["local"].name = mapName
				NS.CommFlare.CF.SocialQueues["local"].popped = NS.CommFlare.CF.LocalQueues[index].popped
				NS.CommFlare.CF.SocialQueues["local"].queues[index].popped = NS.CommFlare.CF.SocialQueues["local"].popped

				-- display popped groups?
				if (NS.charDB.profile.displayPoppedGroups == true) then
					-- print popped group
					local maxCount = NS.CommunityFlare_GetMaxPartyCount()
					print(strformat("%s: %s-%s (%d/%d) [%s]", L["POPPED"], NS.CommFlare.CF.SocialQueues["local"].leader.name, NS.CommFlare.CF.SocialQueues["local"].leader.realm, #NS.CommFlare.CF.SocialQueues["local"].members, maxCount, mapName))
				end

				-- update / process popped groups
				NS.CommunityFlare_Update_Group("local")
				NS.CommunityFlare_Process_Popped("local")

				-- get count
				local count = NS.CommunityFlare_GetGroupCount()
				if (NS.CommFlare.CF.CurrentPopped["count"]) then
					-- use popped count
					count = strformat("%s,%d", count, NS.CommFlare.CF.CurrentPopped["count"])
				end

				-- push data
				local timestamp = time()
				local guids = strformat("%s,%s", leaderGUID, partyGUID)
				NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Popped@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, timestamp, count, guids))

				-- port expiration not expired?
				NS.CommFlare.CF.Expiration = GetBattlefieldPortExpiration(index)
				if (NS.CommFlare.CF.Expiration > 0) then
					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- mercenary queue?
							local text = ""
							local mercenary = ""
							local count = NS.CommunityFlare_GetGroupCount()
							if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
								-- finalize text
								text = strformat(L["%s Mercenary Queue Popped For %s!"], count, mapName)
							else
								-- finalize text
								text = strformat(L["%s Queue Popped For %s!"], count, mapName)
							end

							-- no specializations found? (probably solo Q)
							if ((NS.CommFlare.CF.LocalData.NumTanks == 0) and (NS.CommFlare.CF.LocalData.NumHealers == 0) and (NS.CommFlare.CF.LocalData.NumDPS == 0)) then
								-- get pvp roles
								local isTank, isHealer, isDamage = GetPVPRoles()

								-- tank?
								if (isTank == true) then
									-- tank spec
									NS.CommFlare.CF.LocalData.NumTanks = 1
								end
	
								-- tank?
								if (isHealer == true) then
									-- header spec
									NS.CommFlare.CF.LocalData.NumHealers = 1
								end

								-- dps?
								if (isDamage == true) then
									-- header spec
									NS.CommFlare.CF.LocalData.NumDPS = 1
								end
							end

							-- add tanks / heals / dps counts
							if ((NS.CommFlare.CF.LocalData.NumTanks > 0) or (NS.CommFlare.CF.LocalData.NumHealers > 0) or (NS.CommFlare.CF.LocalData.NumDPS > 0)) then
								-- add counts
								text = strformat(L["%s [%d Tanks, %d Healers, %d DPS]"], text, NS.CommFlare.CF.LocalData.NumTanks, NS.CommFlare.CF.LocalData.NumHealers, NS.CommFlare.CF.LocalData.NumDPS)
							end

							-- popped
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				-- port expired
				else
					-- clear queue
					print(strformat("%s: %s!", NS.CommunityFlare_Title, L["Port Expired"]))
					NS.CommFlare.CF.LocalQueues[index] = nil
				end
			end
		-- none?
		elseif (status == "none") then
			-- previously queued?
			if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].popped) then
				-- not popped?
				if (NS.CommFlare.CF.LocalQueues[index].popped == 0) then
					-- reset counts
					NS.CommFlare.CF.LocalData.NumDPS = 0
					NS.CommFlare.CF.LocalData.NumHealers = 0
					NS.CommFlare.CF.LocalData.NumTanks = 0

					-- get count
					local count = NS.CommunityFlare_GetGroupCount()
					if (NS.CommFlare.CF.CurrentPopped["count"]) then
						-- use popped count
						count = strformat("%s,%d", count, NS.CommFlare.CF.CurrentPopped["count"])
					end

					-- push data
					local timestamp = time()
					local guids = strformat("%s,%s", leaderGUID, partyGUID)
					NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Dropped@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, timestamp, count, guids))

					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- mercenary queue?
							local text = ""
							local count = NS.CommunityFlare_GetGroupCount()
							if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
								-- finalize text
								text = strformat(L["%s Dropped Mercenary Queue For %s!"], count, mapName)
							else
								-- finalize text
								text = strformat(L["%s Dropped Queue For %s!"], count, mapName)
							end

							-- dropped
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				-- popped?
				elseif (NS.CommFlare.CF.LocalQueues[index].popped > 0) then
					-- mercenary queue?
					local text = ""
					if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
						-- finalize text
						text = strformat(L["Missed Mercenary Queue For Popped %s!"], mapName)
					else
						-- finalize text
						text = strformat(L["Missed Queue For Popped %s!"], mapName)
					end

					-- get count
					local count = NS.CommunityFlare_GetGroupCount()
					if (NS.CommFlare.CF.CurrentPopped["count"]) then
						-- use popped count
						count = strformat("%s,%d", count, NS.CommFlare.CF.CurrentPopped["count"])
					end

					-- push data
					local timestamp = time()
					local guids = strformat("%s,%s", leaderGUID, partyGUID)
					NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Missed@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, timestamp, count, guids))

					-- are you in a party?
					if (IsInGroup() and not IsInRaid()) then
						-- send party message
						NS.CommunityFlare_SendMessage(nil, text)
					end

					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end
				end

				-- has social queue?
				if (NS.CommFlare.CF.SocialQueues["local"].queues and NS.CommFlare.CF.SocialQueues["local"].queues[index]) then
					-- clear queue
					NS.CommFlare.CF.SocialQueues["local"].queues[index] = nil
				end
			end

			-- update local group
			NS.CommFlare.CF.LocalQueues[index] = nil
			NS.CommFlare.CF.SocialQueues["local"] = nil
			NS.CommunityFlare_Update_Group("local")
		end
	end
end

-- update brawl status
function NS.CommunityFlare_Update_Brawl_Status()
	-- brawl queued?
	local index = "Brawl"
	local inParty, joined, queued, _, _, _, slotCount, category, leader, tank, healer, dps = GetLFGInfoServer(LE_LFG_CATEGORY_BATTLEFIELD)
	if (category == LE_LFG_CATEGORY_BATTLEFIELD) then
		-- get brawl info
		local brawlInfo
		if (PvPIsInBrawl() == true) then
			brawlInfo = PvPGetActiveBrawlInfo()
		else
			brawlInfo = PvPGetAvailableBrawlInfo()
		end

		-- found brawl name
		if (brawlInfo and brawlInfo.name and (brawlInfo.name ~= "")) then
			-- joined?
			local mapName = brawlInfo.name
			if (joined == true) then
				-- queued?
				if (queued == true) then
					-- just entering queue?
					if (not NS.CommFlare.CF.LocalQueues[index] or not NS.CommFlare.CF.LocalQueues[index].name or (NS.CommFlare.CF.LocalQueues[index].name == "")) then
						-- add to queues
						NS.CommFlare.CF.LocalQueues[index] = {
							["name"] = mapName,
							["created"] = time(),
							["entered"] = false,
							["joined"] = true,
							["popped"] = 0,
							["status"] = "queued",
							["suspended"] = false,
							["type"] = index,
						}

						-- update local group
						NS.CommunityFlare_Update_Group("local")

						-- delay some
						TimerAfter(0.5, function()
							-- community reporter enabled?
							if (NS.charDB.profile.communityReporter == true) then
								-- are you group leader?
								if (NS.CommunityFlare_IsGroupLeader() == true) then
									-- report joined queue with estimated time
									NS.CommFlare.CF.EstimatedWaitTime = 0
									NS.CommunityFlare_Report_Joined_With_Estimated_Time(index)
								end
							end
						end)
					end
				-- queue exists?
				elseif (NS.CommFlare.CF.LocalQueues[index]) then
					-- popped?
					if ((NS.CommFlare.CF.LocalQueues[index].status == "popped") and NS.CommFlare.CF.LocalQueues[index].popped and (NS.CommFlare.CF.LocalQueues[index].popped == 0)) then
						-- update popped time
						NS.CommFlare.CF.LocalQueues[index].popped = time()

						-- community reporter enabled?
						if (NS.charDB.profile.communityReporter == true) then
							-- are you group leader?
							if (NS.CommunityFlare_IsGroupLeader() == true) then
								-- finalize text
								local count = NS.CommunityFlare_GetGroupCount()
								text = strformat(L["%s Queue Popped For %s!"], count, mapName)

								-- no specializations found? (probably solo Q)
								if ((NS.CommFlare.CF.LocalData.NumTanks == 0) and (NS.CommFlare.CF.LocalData.NumHealers == 0) and (NS.CommFlare.CF.LocalData.NumDPS == 0)) then
									-- get pvp roles
									local isTank, isHealer, isDamage = GetPVPRoles()

									-- tank?
									if (isTank == true) then
										-- tank spec
										NS.CommFlare.CF.LocalData.NumTanks = 1
									end
	
									-- tank?
									if (isHealer == true) then
										-- header spec
										NS.CommFlare.CF.LocalData.NumHealers = 1
									end

									-- dps?
									if (isDamage == true) then
										-- header spec
										NS.CommFlare.CF.LocalData.NumDPS = 1
									end
								end

								-- add tanks / heals / dps counts
								if ((NS.CommFlare.CF.LocalData.NumTanks > 0) or (NS.CommFlare.CF.LocalData.NumHealers > 0) or (NS.CommFlare.CF.LocalData.NumDPS > 0)) then
									-- add counts
									text = strformat(L["%s [%d Tanks, %d Healers, %d DPS]"], text, NS.CommFlare.CF.LocalData.NumTanks, NS.CommFlare.CF.LocalData.NumHealers, NS.CommFlare.CF.LocalData.NumDPS)
								end

								-- popped
								NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
							end
						end
					end
				end
			else
				-- clear local queue
				NS.CommFlare.CF.LocalQueues[index] = nil
			end
		end
	else
		-- queue created?
		if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].created and (NS.CommFlare.CF.LocalQueues[index].created > 0)) then
			-- has name?
			if (NS.CommFlare.CF.LocalQueues[index].name and (NS.CommFlare.CF.LocalQueues[index].name ~= "")) then
				-- dropped?
				local mapName = NS.CommFlare.CF.LocalQueues[index].name
				if (NS.CommFlare.CF.LocalQueues[index].status == "queued") then
					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- dropped
							local count = NS.CommunityFlare_GetGroupCount()
							local text = strformat(L["%s Dropped Queue For %s!"], count, mapName)
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				-- failed?
				elseif (NS.CommFlare.CF.LocalQueues[index].status == "failed") then
					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- missed
							local text = strformat(L["Missed Queue For Popped %s!"], mapName)
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				-- entered?
				elseif (NS.CommFlare.CF.LocalQueues[index].status == "entered") then
					-- are you in a party?
					if (IsInGroup() and not IsInRaid()) then
						-- send party message
						local text = strformat(L["Entered Queue For Popped %s!"], mapName)
						NS.CommunityFlare_SendMessage(nil, text)
					end
				-- rejected?
				elseif (NS.CommFlare.CF.LocalQueues[index].status == "rejected") then
					-- left queue
					local text = strformat(L["Left Queue For Popped %s!"], mapName)

					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end

					-- are you in a party?
					if (IsInGroup() and not IsInRaid()) then
						-- send party message
						NS.CommunityFlare_SendMessage(nil, text)
					end

					-- has social queue?
					if (NS.CommFlare.CF.SocialQueues["local"].queues and NS.CommFlare.CF.SocialQueues["local"].queues[index]) then
						-- clear queue
						NS.CommFlare.CF.SocialQueues["local"].queues[index] = nil
					end
				end
			end
		end

		-- clear local queue
		NS.CommFlare.CF.LocalQueues[index] = nil
	end
end

-- iniialize queue session
function NS.CommunityFlare_Initialize_Queue_Session()
	-- clear role chosen table
	NS.CommFlare.CF.RoleChosen = {}

	-- not group leader?
	if (NS.CommunityFlare_IsGroupLeader() ~= true) then
		-- finished
		return
	end

	-- Blizzard_PVPUI loaded?
	local loaded, finished = IsAddOnLoaded("Blizzard_PVPUI")
	if (loaded ~= true) then
		-- load Blizzard_PVPUI
		UIParentLoadAddOn("Blizzard_PVPUI")
	end

	-- is tracked pvp?
	local mapName = GetLFGRoleUpdateBattlegroundInfo()
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- uninvite players that are afk?
		local uninviteTimer = 0
		if (NS.charDB.profile.uninvitePlayersAFK > 0) then
			uninviteTimer = NS.charDB.profile.uninvitePlayersAFK
		end

		-- uninvite enabled?
		if ((uninviteTimer >= 3) and (uninviteTimer <= 6)) then
			-- queue check role chosen (within timer)
			TimerAfter(uninviteTimer, NS.CommunityFlare_Queue_Check_Role_Chosen)
		end
	end
end

-- get current queues
function NS.CommunityFlare_Get_Current_Queues()
	-- process all
	local message = nil
	for k,v in pairs(NS.CommFlare.CF.LocalQueues) do
		-- queued and tracked?
		local status, mapName = GetBattlefieldStatus(k)
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if ((status == "queued") and (isTracked == true)) then
			-- calculate time
			NS.CommFlare.CF.Timer.Seconds = time() - v.created
			NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
			NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

			-- first?
			if (not message) then
				-- initialize
				message = strformat("%s: %02d:%02d", v.name, NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
			else
				-- initialize
				message = strformat("%s; %s: %02d:%02d", message, v.name, NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
			end
		-- not queued anymore?
		elseif (status == "none") then
			-- clear queue
			NS.CommFlare.CF.LocalQueues[k] = nil
		end
	end

	-- has message?
	if (message and (message ~= "")) then
		-- player is horde?
		local text = NS.CommunityFlare_GetGroupCount()
		NS.CommFlare.CF.PlayerFaction = UnitFactionGroup("player")
		if (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
			-- horde
			text = strformat("%s %s", text, L["Horde"])
		-- player is alliance?
		elseif (NS.CommFlare.CF.PlayerFaction == L["Alliance"]) then
			-- alliance
			text = strformat("%s %s", text, L["Alliance"])
		end

		-- finalize text
		message = strformat(L["%s Currently Queued For %s."], text, message)

		-- check if group has room for more
		local maxCount = NS.CommunityFlare_GetMaxPartyCount()
		if (NS.CommFlare.CF.Count < maxCount) then
			-- community auto invite enabled?
			if (NS.charDB.profile.communityAutoInvite == true) then
				-- update message
				message = strformat("%s (%s)", message, L["For auto invite, whisper me INV"])
			end
		end
	end

	-- return message
	return message
end
