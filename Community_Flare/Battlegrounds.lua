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
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetDisplayedInviteType                    = _G.GetDisplayedInviteType
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumBattlefieldScores                   = _G.GetNumBattlefieldScores
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetRaidRosterInfo                         = _G.GetRaidRosterInfo
local IsAddOnLoaded                             = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToAssistant                        = _G.PromoteToAssistant
local PromoteToLeader                           = _G.PromoteToLeader
local SetBattlefieldScoreFaction                = _G.SetBattlefieldScoreFaction
local UnitFactionGroup                          = _G.UnitFactionGroup
local UnitInRaid                                = _G.UnitInRaid
local UnitName                                  = _G.UnitName
local UnitRealmRelationship                     = _G.UnitRealmRelationship
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoInviteUnit                       = _G.C_PartyInfo.InviteUnit
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPGetScoreInfo                           = _G.C_PvP.GetScoreInfo
local PvPGetScoreInfoByPlayerGuid               = _G.C_PvP.GetScoreInfoByPlayerGuid
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local TimerAfter                                = _G.C_Timer.After
local GetDoubleStatusBarWidgetVisualizationInfo = _G.C_UIWidgetManager.GetDoubleStatusBarWidgetVisualizationInfo
local GetIconAndTextWidgetVisualizationInfo     = _G.C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo
local date                                      = _G.date
local ipairs                                    = _G.ipairs
local mfloor                                    = _G.math.floor
local next                                      = _G.next
local pairs                                     = _G.pairs
local print                                     = _G.print
local strformat                                 = _G.string.format
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split
local tinsert                                   = _G.table.insert
local time                                      = _G.time
local tsort                                     = _G.table.sort

-- epic battlegrounds
NS.EpicBattlegrounds = {
	[1] = { id = 1, name = L["Random Epic Battleground"] },
	[2] = { id = 2, name = L["Alterac Valley"] },
	[3] = { id = 3, name = L["Isle of Conquest"] },
	[4] = { id = 4, name = L["Battle for Wintergrasp"] },
	[5] = { id = 5, name = L["Ashran"] },
	[6] = { id = 6, name = L["Korrak's Revenge"] },
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
	[21] = { id = 11, name = "Brawl: Temple of Hotmogu" },
	[22] = { id = 11, name = "Temple of Hotmogu" },
	[23] = { id = 12, name = "Brawl: Warsong Scramble" },
	[24] = { id = 12, name = "Warsong Scramble" },
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

-- get battleground map name
function NS.CommunityFlare_Battleground_Get_Map_Name()
	-- find active battleground
	NS.CommFlare.CF.MapName = L["N/A"]
	for i=1, GetMaxBattlefieldID() do
		-- active match?
		local status, mapName = GetBattlefieldStatus(i)
		if (status == "active") then
			-- save map name
			NS.CommFlare.CF.MapName = mapName
		end
	end
end

-- initialize battleground status
function NS.CommunityFlare_Initialize_Battleground_Status()
	-- reset stuff
	NS.CommFlare.CF.MapID = 0
	NS.CommFlare.CF.ASH = {}
	NS.CommFlare.CF.AV = {}
	NS.CommFlare.CF.IOC = {}
	NS.CommFlare.CF.WG = {}
	NS.CommFlare.CF.MapInfo = {}
	NS.CommFlare.CF.MatchStartTime = 0
	NS.CommFlare.CF.Reloaded = false

	-- get battleground map name
	NS.CommunityFlare_Battleground_Get_Map_Name()
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

-- look for players with 0 damage and 0 healing
function NS.CommunityFlare_Check_For_Inactive_Players()
	-- any battlefield scores?
	SetBattlefieldScoreFaction()
	NS.CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (NS.CommFlare.CF.NumScores == 0) then
		-- finished
		return
	end

	-- has match started yet?
	if (PvPGetActiveMatchDuration() > 0) then
		-- calculate time elapsed
		NS.CommFlare.CF.Timer.MilliSeconds = GetBattlefieldInstanceRunTime()
		NS.CommFlare.CF.Timer.Seconds = mfloor(NS.CommFlare.CF.Timer.MilliSeconds / 1000)
		NS.CommFlare.CF.Timer.Minutes = mfloor(NS.CommFlare.CF.Timer.Seconds / 60)
		NS.CommFlare.CF.Timer.Seconds = NS.CommFlare.CF.Timer.Seconds - (NS.CommFlare.CF.Timer.Minutes * 60)

		-- process all scores
		SetBattlefieldScoreFaction()
		for i=1, GetNumBattlefieldScores() do
			local info = PvPGetScoreInfo(i)
			if (info and info.name) then
				-- damage and healing done found?
				if ((info.damageDone ~= nil) and (info.healingDone ~= nil)) then
					-- both equal zero?
					if ((info.damageDone == 0) and (info.healingDone == 0)) then
						-- display
						print(strformat(L["%s: AFK after %d minutes, %d seconds?"], info.name, NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds))
					end
				end
			end
		end
	end
end

-- update battleground status
function NS.CommunityFlare_Update_Battleground_Status()
	-- get MapID
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not NS.CommFlare.CF.MapID) then
		-- failed
		return false
	end

	-- get map info
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
	-- battle for wintergrasp?
	elseif (NS.CommFlare.CF.MapID == 1334) then
		-- initialize
		NS.CommFlare.CF.WG = {}
		NS.CommFlare.CF.WG.Counts = { Towers = 0 }
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

		-- match not started yet?
		if (NS.CommFlare.CF.MatchStatus ~= 1) then
			-- 1612 = widgetID for Time Remaining
			NS.CommFlare.CF.WidgetInfo = GetIconAndTextWidgetVisualizationInfo(1612)
			if (NS.CommFlare.CF.WidgetInfo) then
				-- set proper time
				NS.CommFlare.CF.WG.TimeRemaining = NS.CommFlare.CF.WidgetInfo.text
			end
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
			NS.CommFlare.CF.ASH.Jeron = NS.db.profile.ASH.Jeron
			NS.CommFlare.CF.ASH.Rylai = NS.db.profile.ASH.Rylai
		end

		-- 1997 = widgetID for Score Remaining
		NS.CommFlare.CF.WidgetInfo = GetDoubleStatusBarWidgetVisualizationInfo(1997)
		if (NS.CommFlare.CF.WidgetInfo) then
			-- set proper scores
			NS.CommFlare.CF.ASH.Scores = { Alliance = NS.CommFlare.CF.WidgetInfo.leftBarValue, Horde = NS.CommFlare.CF.WidgetInfo.rightBarValue }
		end

		-- success
		return true
	end

	-- not epic battleground
	return false
end

-- process community members
function NS.CommunityFlare_Process_Community_Members()
	-- initialize full roster
	NS.CommFlare.CF.FullRoster = {}

	-- initialize community stuff
	NS.CommFlare.CF.CommCount = 0
	NS.CommFlare.CF.CommCounts = {}
	NS.CommFlare.CF.CommNames = {}
	NS.CommFlare.CF.CommNamesList = {}

	-- initialize mercenary stuff
	NS.CommFlare.CF.MercsCount = 0
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

	-- process all scores
	local clubId
	SetBattlefieldScoreFaction()
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
			if (info.faction == 1) then
				-- increase alliance counts
				NS.CommFlare.CF.Alliance.Count = NS.CommFlare.CF.Alliance.Count + 1
				if (NS.CommFlare.CF.IsHealer == true) then
					NS.CommFlare.CF.Alliance.Healers = NS.CommFlare.CF.Alliance.Healers + 1
				elseif (NS.CommFlare.CF.IsTank == true) then
					NS.CommFlare.CF.Alliance.Tanks = NS.CommFlare.CF.Alliance.Tanks + 1
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
			end

			-- force name-realm format
			local player = info.name
			if (not strmatch(player, "-")) then
				-- add realm name
				player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
			end

			-- get community member
			local member = NS.CommunityFlare_GetCommunityMember(player)
			if (member ~= nil) then
				-- counts setup?
				clubId = next(member.clubs)
				if (not NS.CommFlare.CF.CommCounts[clubId]) then
					-- initialize
					NS.CommFlare.CF.CommCounts[clubId] = 0
				end

				-- community names setup?
				if (not NS.CommFlare.CF.CommNames[clubId]) then
					-- initialize
					NS.CommFlare.CF.CommNames[clubId] = {}
				end

				-- mercinary names setup?
				if (not NS.CommFlare.CF.MercNames[clubId]) then
					-- initialize
					NS.CommFlare.CF.MercNames[clubId] = {}
				end

				-- player is alliance?
				if (NS.CommFlare.CF.PlayerFaction == L["Alliance"]) then
					-- alliance?
					if (info.faction == 1) then
						-- update stuff
						tinsert(NS.CommFlare.CF.CommNamesList, member.name)
						tinsert(NS.CommFlare.CF.CommNames[clubId], member.name)
						NS.CommFlare.CF.CommCount = NS.CommFlare.CF.CommCount + 1
						NS.CommFlare.CF.CommCounts[clubId] = NS.CommFlare.CF.CommCounts[clubId] + 1

						-- should log list?
						if (NS.CommunityFlare_Get_LogList_Status(player) == true) then
							-- update
							tinsert(NS.CommFlare.CF.LogListNamesList, player)
							NS.CommFlare.CF.LogListCount = NS.CommFlare.CF.LogListCount + 1
						end
					else
						-- update stuff
						tinsert(NS.CommFlare.CF.MercNamesList, member.name)
						tinsert(NS.CommFlare.CF.MercNames[clubId], member.name)
						NS.CommFlare.CF.MercsCount = NS.CommFlare.CF.MercsCount + 1
					end
				-- player is horde?
				elseif (NS.CommFlare.CF.PlayerFaction == L["Horde"]) then
					-- alliance?
					if (info.faction == 1) then
						-- update stuff
						tinsert(NS.CommFlare.CF.MercNamesList, member.name)
						tinsert(NS.CommFlare.CF.MercNames[clubId], member.name)
						NS.CommFlare.CF.MercsCount = NS.CommFlare.CF.MercsCount + 1
					else
						-- update stuff
						tinsert(NS.CommFlare.CF.CommNamesList, member.name)
						tinsert(NS.CommFlare.CF.CommNames[clubId], member.name)
						NS.CommFlare.CF.CommCount = NS.CommFlare.CF.CommCount + 1
						NS.CommFlare.CF.CommCounts[clubId] = NS.CommFlare.CF.CommCounts[clubId] + 1

						-- should log list?
						if (NS.CommunityFlare_Get_LogList_Status(player) == true) then
							-- update
							tinsert(NS.CommFlare.CF.LogListNamesList, player)
							NS.CommFlare.CF.LogListCount = NS.CommFlare.CF.LogListCount + 1
						end
					end
				end

				-- player has raid leader?
				if (NS.CommFlare.CF.PlayerRank == 2) then
					-- only allow leaders?
					NS.CommFlare.CF.AutoPromote = false
					if (NS.db.profile.communityAutoAssist == 2) then
						-- player is community leader?
						if (NS.CommunityFlare_IsCommunityLeader(player) == true) then
							-- auto promote
							NS.CommFlare.CF.AutoPromote = true
						end
					-- allow all members?
					elseif (NS.db.profile.communityAutoAssist == 3) then
						-- auto promote
						NS.CommFlare.CF.AutoPromote = true
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

	-- has mercenaries?
	if (NS.CommFlare.CF.MercsCount > 0) then
		-- sort mercinary names
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
end

-- count stuff in battlegrounds and promote to assists
function NS.CommunityFlare_Update_Battleground_Stuff(isPrint)
	-- any battlefield scores?
	SetBattlefieldScoreFaction()
	NS.CommFlare.CF.NumScores = GetNumBattlefieldScores()
	if (NS.CommFlare.CF.NumScores == 0) then
		-- should print?
		if (isPrint == true) then
			-- not in battleground yet
			print(strformat(L["%s: Not in battleground yet."], NS.CommunityFlare_Title))
		end
		return
	end

	-- process community members
	NS.CommunityFlare_Process_Community_Members()

	-- should print?
	local timer = 0.0
	if (isPrint == true) then
		-- display results staggered
		TimerAfter(timer, function()
			-- display faction results
			print(strformat(L["%s: Healers = %d, Tanks = %d"], L["Horde"], NS.CommFlare.CF.Horde.Healers, NS.CommFlare.CF.Horde.Tanks))
			print(strformat(L["%s: Healers = %d, Tanks = %d"], L["Alliance"], NS.CommFlare.CF.Alliance.Healers, NS.CommFlare.CF.Alliance.Tanks))
		end)

		-- next
		timer = timer + 0.1
	end

	-- has mercenaries?
	if (NS.CommFlare.CF.MercsCount > 0) then
		-- display community names?
		if (NS.db.profile.communityDisplayNames == true) then
			-- build mercenary list
			local list = nil
			for k,v in pairs(NS.CommFlare.CF.MercNamesList) do
				-- list still empty? start it!
				if (list == nil) then
					list = v
				else
					list = list .. ", " .. v
				end
			end

			-- found merc list?
			if (list ~= nil) then
				-- should print?
				if (isPrint == true) then
					-- display results staggered
					TimerAfter(timer, function()
						-- display community mercenaries
						print(strformat(L["Community Mercenaries: %s"], list))
					end)

					-- next
					timer = timer + 0.1
				end
			end
		end

		-- display results staggered
		TimerAfter(timer, function()
			-- display mercs count
			print(strformat(L["Total Mercenaries: %d"], NS.CommFlare.CF.MercsCount))
		end)

		-- next
		timer = timer + 0.1
	end

	-- has community players?
	if (NS.CommFlare.CF.CommCount > 0) then
		-- display community names?
		if (NS.db.profile.communityDisplayNames == true) then
			-- build member list
			local list = nil
			for k,v in pairs(NS.CommFlare.CF.CommNamesList) do
				-- list still empty? start it!
				if (list == nil) then
					list = v
				else
					list = list .. ", " .. v
				end
			end

			-- found list?
			if (list ~= nil) then
				-- should print?
				if (isPrint == true) then
					-- display results staggered
					TimerAfter(timer, function()
						-- display community members
						print(strformat("%s: %s", L["Community Members"], list))
					end)

					-- next
					timer = timer + 0.1
				end
			end
		end
	end

	-- found community counts?
	if (NS.CommFlare.CF.CommCounts and next(NS.CommFlare.CF.CommCounts)) then
		-- build count list
		local list = nil
		for k,v in pairs(NS.CommFlare.CF.CommCounts) do
			-- has community?
			if (NS.db.global.clubs[k] and NS.db.global.clubs[k].name) then
				-- add to list
				if (list == nil) then
					list = NS.db.global.clubs[k].name .. " = " .. v
				else
					list = list .. ", " .. NS.db.global.clubs[k].name .. " = " .. v
				end
			end
		end

		-- found list?
		if (list ~= nil) then
			-- should print?
			if (isPrint == true) then
				-- display results staggered
				TimerAfter(timer, function()
					-- display community counts
					print(strformat(L["Community Counts: %s"], list))
				end)

				-- next
				timer = timer + 0.1
			end
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

-- match started, log roster
function NS.CommunityFlare_Match_Started_Log_Roster()
	-- already logged?
	if (NS.CommFlare.CF.MatchStartLogged == true) then
		-- finished
		NS.CommFlare.CF.MatchStartLogged = false
		return
	end

	-- has log list?
	if (NS.CommFlare.CF.LogListCount > 0) then
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
			-- match log list not setup?
			if (not NS.db.global.matchLogList) then
				-- initialize
				NS.db.global.matchLogList = {}
			end

			-- remove profile match log li st
			if (NS.db.profile.matchLogList) then
				-- remoive
				NS.db.profile.matchLogList = nil
			end

			-- no date?
			if (NS.CommFlare.CF.MatchStartDate and (NS.CommFlare.CF.MatchStartDate ~= "")) then
				-- save match log
				local player = NS.CommunityFlare_GetPlayerName("full")
				tinsert(NS.db.global.matchLogList, strformat(L["Date: %s; MapName: %s; Player: %s; Roster: %s"], NS.CommFlare.CF.MatchStartDate, NS.CommFlare.CF.MapName, player, list))

				-- logged
				NS.CommFlare.CF.MatchStartLogged = true
			end
		end
	end
end

-- process pass leadership
function NS.CommunityFlare_Process_Pass_Leadership(sender)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender, true) == false) then
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
					if (member.priority < player.priority) then
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
	if (NS.CommunityFlare_HasSharedCommunity(sender, false) == false) then
		-- finished
		return
	end

	-- number?
	if (type(sender) == "number") then
		-- battle net auto invite enabled?
		if (NS.db.profile.bnetAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- can not invite while in a battleground
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a battleground now."])
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
							if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
								-- force to max
								NS.CommFlare.CF.Count = 5

								-- group full
								NS.CommunityFlare_SendMessage(sender, L["Sorry, group is currently full."])
							else
								-- really has room?
								if (NS.CommFlare.CF.Count < 5) then
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
		if (NS.db.profile.communityAutoInvite == true) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- can not invite while in a battleground
				NS.CommunityFlare_SendMessage(sender, L["Sorry, currently in a battleground now."])
			else
				-- is sender a community member?
				NS.CommFlare.CF.AutoInvite = NS.CommunityFlare_IsCommunityMember(sender)
				if (NS.CommFlare.CF.AutoInvite == true) then
					-- group is full?
					if ((GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
						-- force to max
						NS.CommFlare.CF.Count = 5

						-- group full
						NS.CommunityFlare_SendMessage(sender, L["Sorry, group is currently full."])
					else
						-- really has room?
						if (NS.CommFlare.CF.Count < 5) then
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

-- process status check
function NS.CommunityFlare_Process_Status_Check(sender)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender, true) == false) then
		-- finished
		return
	end

	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- update battleground status
		local text = nil
		local status = NS.CommunityFlare_Update_Battleground_Status()
		if (status == true) then
			-- update battleground stuff / counts
			NS.CommunityFlare_Update_Battleground_Stuff(false)

			-- has match started yet?
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
				-- isle of conquest?
				elseif (NS.CommFlare.CF.MapID == 169) then
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
				-- battle for wintergrasp?
				elseif (NS.CommFlare.CF.MapID == 1334) then
					-- set text to wintergrasp status
					text = strformat("%s (%s): %s; %s = %d %s, %d %s; %s: %d/3; %d %s",
						NS.CommFlare.CF.MapInfo.name, NS.CommFlare.CF.WG.Type,
						NS.CommFlare.CF.WG.TimeRemaining, L["Time Elapsed"],
						NS.CommFlare.CF.Timer.Minutes, L["minutes"],
						NS.CommFlare.CF.Timer.Seconds, L["seconds"],
						L["Towers Destroyed"], NS.CommFlare.CF.WG.Counts.Towers,
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

		-- has text to send?
		if (text and (text ~= "")) then
			-- add to table for later
			NS.CommFlare.CF.StatusCheck[sender] = time()

			-- send text to sender
			NS.CommunityFlare_SendMessage(sender, text)
		end
	else
		-- check for queued battleground
		local text = {}
		local timer = 0.0
		local reported = false
		NS.CommFlare.CF.Leader = NS.CommunityFlare_GetPartyLeader()
		for i=1, GetMaxBattlefieldID() do
			-- get battleground types by name
			local status, mapName = GetBattlefieldStatus(i)
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)

			-- queued and tracked?
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

				-- send replies staggered
				TimerAfter(timer, function()
					-- report queue time
					NS.CommunityFlare_SendMessage(sender, text[i])
				end)

				-- next
				timer = timer + 0.2
			end
		end

		-- not reported?
		if (reported == false) then
			-- not currently in queue
			NS.CommunityFlare_SendMessage(sender, L["Not currently in an epic battleground or queue!"])
		end
	end
end

-- report joined with estimated time
function NS.CommunityFlare_Report_Joined_With_Estimated_Time(index)
	-- clear role chosen table
	NS.CommFlare.CF.RoleChosen = {}

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

			-- does the player have the mercenary buff?
			local time_waited = strformat(L["%d minutes, %d seconds"], NS.CommFlare.CF.Timer.Minutes, NS.CommFlare.CF.Timer.Seconds)
			NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
			if (NS.CommFlare.CF.HasAura == true) then
				-- build text for mercenary queue
				NS.CommFlare.CF.Queues[index].mercenary = true

				-- finalize text
				text = strformat(L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"], text, mapName, time_waited)
			else
				-- build text for normal epic battleground queue
				NS.CommFlare.CF.Queues[index].mercenary = false

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

			-- does the player have the mercenary buff?
			NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
			if (NS.CommFlare.CF.HasAura == true) then
				-- build text for mercenary queue
				NS.CommFlare.CF.Queues[index].mercenary = true

				-- finalize text
				text = strformat(L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"], text, mapName, L["N/A"])
			else
				-- build text for normal epic battleground queue
				NS.CommFlare.CF.Queues[index].mercenary = false

				-- finalize text
				text = strformat(L["%s Joined Queue For %s! Estimated Wait: %s!"], text, mapName, L["N/A"])
			end
		end

		-- check if group has room for more
		if (NS.CommFlare.CF.Count < 5) then
			-- community auto invite enabled?
			if (NS.db.profile.communityAutoInvite == true) then
				-- update text
				text = strformat("%s (%s)", text, L["For auto invite, whisper me INV"])
			end
		end

		-- send to community
		NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
		return
	end
end

-- update battlefield status
function NS.CommunityFlare_Update_Battlefield_Status(index)
	-- queue left or missed?
	local status, mapName, _, _, suspendedQueue, queueType = GetBattlefieldStatus(index)
	if ((status == "none") and NS.CommFlare.CF.Queues[index] and NS.CommFlare.CF.Queues[index].name and (NS.CommFlare.CF.Queues[index].name ~= "")) then
		-- update map name
		mapName = NS.CommFlare.CF.Queues[index].name
	end

	-- is tracked pvp?
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- queued?
		if (status == "queued") then
			-- just entering queue?
			if (not NS.CommFlare.CF.Queues[index] or not NS.CommFlare.CF.Queues[index].name or (NS.CommFlare.CF.Queues[index].name == "")) then
				-- add to queues
				NS.CommFlare.CF.Queues[index] = {
					["name"] = mapName,
					["created"] = time(),
					["entered"] = false,
					["joined"] = true,
					["popped"] = 0,
					["status"] = status,
					["suspended"] = false,
					["type"] = queueType,
				}

				-- delay some
				TimerAfter(0.5, function()
					-- community reporter enabled?
					if (NS.db.profile.communityReporter == true) then
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
				if ((suspendedQueue == true) and (NS.CommFlare.CF.Queues[index].suspended == false)) then
					-- queue has paused
					NS.CommFlare.CF.Queues[index].suspended = true

					-- queue paused warning enabled?
					if (NS.db.profile.warningQueuePaused == true) then
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
				elseif ((suspendedQueue == false) and (NS.CommFlare.CF.Queues[index].suspended == true)) then
					-- queue has resumed
					NS.CommFlare.CF.Queues[index].suspended = false

					-- queue paused warning enabled?
					if (NS.db.profile.warningQueuePaused == true) then
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
			if (NS.CommFlare.CF.Queues[index] and NS.CommFlare.CF.Queues[index].popped and (NS.CommFlare.CF.Queues[index].popped == 0)) then
				-- set popped
				NS.CommFlare.CF.Queues[index].popped = time()

				-- port expiration not expired?
				NS.CommFlare.CF.MapName = mapName
				NS.CommFlare.CF.Expiration = GetBattlefieldPortExpiration(index)
				if (NS.CommFlare.CF.Expiration > 0) then
					-- community reporter enabled?
					if (NS.db.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- mercenary?
							local text = ""
							local mercenary = ""
							local count = NS.CommunityFlare_GetGroupCount()
							if (NS.CommFlare.CF.Queues[index].mercenary == true) then
								-- finalize text
								text = strformat(L["%s Mercenary Queue Popped For %s!"], count, mapName)
							else
								-- finalize text
								text = strformat(L["%s Queue Popped For %s!"], count, mapName)
							end

							-- popped
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				-- port expired
				else
					-- clear queue
					print(strformat("%s: %s!", NS.CommunityFlare_Title, L["Port Expired"]))
					NS.CommFlare.CF.Queues[index] = nil
				end
			end
		-- none?
		elseif (status == "none") then
			-- previously queued?
			if (NS.CommFlare.CF.Queues[index] and NS.CommFlare.CF.Queues[index].popped) then
				-- not popped?
				if (NS.CommFlare.CF.Queues[index].popped == 0) then
					-- community reporter enabled?
					if (NS.db.profile.communityReporter == true) then
						-- are you group leader?
						if (NS.CommunityFlare_IsGroupLeader() == true) then
							-- mercenary?
							local text = ""
							local count = NS.CommunityFlare_GetGroupCount()
							if (NS.CommFlare.CF.Queues[index].mercenary == true) then
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
				elseif (NS.CommFlare.CF.Queues[index].popped > 0) then
					-- mercenary?
					local text = ""
					if (NS.CommFlare.CF.Queues[index].mercenary == true) then
						-- finalize text
						text = strformat(L["Missed Mercenary Queue For Popped %s!"], mapName)
					else
						-- finalize text
						text = strformat(L["Missed Queue For Popped %s!"], mapName)
					end

					-- are you in a party?
					if (IsInGroup() and not IsInRaid()) then
						-- send party message
						NS.CommunityFlare_SendMessage(nil, text)
					end

					-- community reporter enabled?
					if (NS.db.profile.communityReporter == true) then
						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end
				end
			end

			-- clear queue
			NS.CommFlare.CF.Queues[index] = nil
		end
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
		if (NS.db.profile.uninvitePlayersAFK > 0) then
			uninviteTimer = NS.db.profile.uninvitePlayersAFK
		end

		-- uninvite enabled?
		if ((uninviteTimer >= 3) and (uninviteTimer <= 6)) then
			-- enable timer
			TimerAfter(uninviteTimer, function()
				local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

				-- not in progress?
				if (inProgress ~= true) then
					-- finished
					return
				end

				-- not in a group?
				if (not IsInGroup()) then
					-- finished
					return
				end

				-- in a raid?
				if (IsInRaid()) then
					-- finished
					return
				end

				-- process all
				for i=1, GetNumGroupMembers() do
					local unit = "party" .. i
					local player, realm = UnitName(unit)
					if (player and (player ~= "")) then
						-- check relationship
						local realmRelationship = UnitRealmRelationship(unit)
						if (realmRelationship == LE_REALM_RELATION_SAME) then
							-- player with same realm
							player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
						else
							-- player with different realm
							player = player .. "-" .. realm
						end

						-- role not chosen?
						if (not NS.CommFlare.CF.RoleChosen[player] or (NS.CommFlare.CF.RoleChosen[player] ~= true)) then
							-- are you leader?
							if (NS.CommunityFlare_IsGroupLeader() == true) then
								-- ask to kick?
								NS.CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
							end
						end
					end
				end
			end)
		end
	end
end
