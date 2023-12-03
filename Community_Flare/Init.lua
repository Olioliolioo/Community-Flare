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
local BNGetFriendAccountInfo                    = _G.C_BattleNet.GetFriendAccountInfo
local BNGetFriendIndex                          = _G.BNGetFriendIndex
local BNSendWhisper                             = _G.BNSendWhisper
local Chat_GetCommunitiesChannel                = _G.Chat_GetCommunitiesChannel
local Chat_GetCommunitiesChannelName            = _G.Chat_GetCommunitiesChannelName
local ChatFrame_AddChannel                      = _G.ChatFrame_AddChannel
local ChatFrame_AddNewCommunitiesChannel        = _G.ChatFrame_AddNewCommunitiesChannel
local ChatFrame_RemoveChannel                   = _G.ChatFrame_RemoveChannel
local ChatFrame_RemoveCommunitiesChannel        = _G.ChatFrame_RemoveCommunitiesChannel
local FCF_UnDockFrame                           = _G.FCF_UnDockFrame
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetChannelName                            = _G.GetChannelName
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local HideUIPanel                               = _G.HideUIPanel
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PromoteToLeader                           = _G.PromoteToLeader
local SendChatMessage                           = _G.SendChatMessage
local StaticPopupDialogs                        = _G.StaticPopupDialogs
local StaticPopup_Show                          = _G.StaticPopup_Show
local UninviteUnit                              = _G.UninviteUnit
local UnitFullName                              = _G.UnitFullName
local UnitGUID                                  = _G.UnitGUID
local UnitIsConnected                           = _G.UnitIsConnected
local UnitIsDeadOrGhost                         = _G.UnitIsDeadOrGhost
local UnitInParty                               = _G.UnitInParty
local UnitIsGroupLeader                         = _G.UnitIsGroupLeader
local UnitName                                  = _G.UnitName
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local TimerAfter                                = _G.C_Timer.After
local pairs                                     = _G.pairs
local time                                      = _G.time
local tonumber                                  = _G.tonumber
local type                                      = _G.type
local mfloor                                    = _G.math.floor
local strformat                                 = _G.string.format
local strgmatch                                 = _G.string.gmatch
local strmatch                                  = _G.string.match
local tinsert                                   = _G.table.insert

-- hearth stone spells
NS.HearthStoneSpells = {
	[8690] = "Hearthstone",
	[39937] = "There's No Place Like Home",
	[75136] = "Ethereal Portal",
	[94719] = "The Innkeeper's Daughter",
	[136508] = "Dark Portal",
	[171253] = "Garrison Hearthstone",
	[222695] = "Dalaran Hearthstone",
	[231504] = "Tome of Town Portal",
	[278244] = "Greatfather Winter's Hearthstone",
	[278559] = "Headless Horseman's Hearthstone",
	[285362] = "Lunar Elder's Hearthstone",
	[285424] = "Peddlefeet's Lovely Hearthstone",
	[286031] = "Noble Gardener's Hearthstone",
	[286331] = "Fire Eater's Hearthstone",
	[286353] = "Brewfest Reveler's Hearthstone",
	[298068] = "Holographic Digitalization Hearthstone",
	[308742] = "Eternal Traveler's Hearthstone",
	[326064] = "Night Fae Hearthstone",
	[342122] = "Venthyr Sinstone",
	[345393] = "Kyrian Hearthstone",
	[346060] = "Necrolord Hearthstone",
	[363799] = "Dominated Hearthstone",
	[366945] = "Enlightened Hearthstone",
	[367013] = "Broker Translocationi Matrix",
	[375357] = "Timewalker's Hearthstone",
	[391042] = "Ohn'ir Windsage's Hearthstone",
}

-- teleport spells
NS.TeleportSpells = {
	[556] = "Astral Recall",
	[3561] = "Teleport: Stormwind",
	[3562] = "Teleport: Ironforge",
	[3563] = "Teleport: Undercity",
	[3565] = "Teleport: Darnassus",
	[3566] = "Teleport: Thunder Bluff",
	[3567] = "Teleport: Orgrimmar",
	[23442] = "Dimensional Ripper - Everlook",
	[23453] = "Ultrasafe Transporter: Gadgetzan",
	[32271] = "Teleport: Exodar",
	[32272] = "Teleport: Silvermoon",
	[33690] = "Teleport: Shattrath",
	[35715] = "Teleport: Shattrath",
	[36890] = "Dimensional Ripper - Area 52",
	[36941] = "Ultrasafe Transporter: Toshley's Station",
	[41234] = "Teleport: Black Temple",
	[49358] = "Teleport: Stonard",
	[49359] = "Teleport: Theramore",
	[53140] = "Teleport: Dalaran - Northrend",
	[54406] = "Teleport: Dalaran",
	[66238] = "Teleport: Argent Tournament",
	[71436] = "Teleport: Booty Bay",
	[88342] = "Teleport: Tol Borad",
	[88344] = "Teleport: Tol Borad",
	[89157] = "Teleport: Stormwind",
	[89158] = "Teleport: Orgrimmar",
	[89597] = "Teleport: Tol Borad",
	[89598] = "Teleport: Tol Borad",
	[126755] = "Wormhole Generator: Pandaria",
	[132621] = "Teleport: Vale of Eternal Blossoms",
	[132627] = "Teleport: Vale of Eternal Blossoms",
	[145430] = "Call of the Mists",
	[175604] = "Bladespire Relic",
	[175608] = "Relic of Karabor",
	[176242] = "Teleport: Warspear",
	[176248] = "Teleport: Stormshield",
	[189838] = "Admiral's Compass",
	[193669] = "Beginner's Guide to Dimensional Rifting",
	[193759] = "Teleport: Hall of the Guardian",
	[216138] = "Emblem of Margoss",
	[220746] = "Scroll of Teleport: Ravenholdt",
	[220989] = "Teleport: Dalaran",
	[223805] = "Adept's Guide to Dimensional Rifting",
	[224869] = "Teleport: Dalaran - Broken Isles",
	[231054] = "Violet Seal of the Grand Magus",
	[250796] = "Wormhole Generator: Argus",
	[281403] = "Teleport: Boralus",
	[281404] = "Teleport: Dazar'alor",
	[289283] = "Teleport: Dazar'alor",
	[289284] = "Teleport: Boralus",
	[299083] = "Wormhome Generator: Kul Tiras",
	[299084] = "Wormhome Generator: Zandalar",
	[300047] = "Mountebank's Colorful Cloak",
	[335671] = "Scroll of Teleport: Theater of Pain",
	[344587] = "Teleport: Oribos",
	[395277] = "Teleport: Valdrakken",
	[406714] = "Scroll of Teleport: Zskera Vaults",
}

-- global function (check if dragon riding available)
function IsDragonFlyable()
	local m = MapGetBestMapForUnit("player")
	if ((m >= 2022) and (m <= 2025) or (m == 2085) or (m == 2112)) then
		-- dragon flyable
		return true
	else
		-- not available
		return false
	end
end

-- global function (send variables to other addons)
function CommunityFlare_GetVar(name)
	-- not loaded?
	if (not NS.CommFlare or not NS.db) then
		-- failed
		return nil
	end

	-- alts list?
	if (name == "AltsList") then
		-- return other communities list
		return NS.db.profile.communityList
	-- clubs?
	elseif (name == "Clubs") then
		-- has main club?
		local clubList = {}
		if (NS.db.profile.communityMain and (NS.db.profile.communityMain > 1)) then
			-- add to clubList
			tinsert(clubList, NS.db.profile.communityMain)
		end
	
		-- has other communities?
		if (next(NS.db.profile.communityList)) then
			-- process all
			for k,v in pairs(NS.db.profile.communityList) do
				-- add to clubList
				tinsert(clubList, k)
			end
		end

		-- process clubs
		local count = 0
		local clubs = {}
		for k,v in ipairs(clubList) do
			-- has channel id?
			local channel, chatFrameID = Chat_GetCommunitiesChannel(v, 1)
			if (chatFrameID and (chatFrameID > 0)) then
				-- has club info?
				if (NS.db.global.clubs and NS.db.global.clubs[v]) then
					-- add to channels
					clubs[v] = NS.db.global.clubs[v]

					-- add more stuff
					clubs[v].streamId = 1
					clubs[v].channel = channel
					clubs[v].chatFrameId = chatFrameID

					-- increase
					count = count + 1
				end
			end
		end

		-- found some?
		if (count > 0) then
			-- return clubs
			return clubs
		end
	-- main ID?
	elseif (name == "MainID") then
		-- return main community ID
		return NS.db.profile.communityMain
	-- report ID?
	elseif (name == "ReportID") then
		-- return report ID
		return NS.db.profile.communityReportID
	-- version?
	elseif (name == "Version") then
		-- return community flare version
		return strformat("%s: %s (%s)", NS.CommunityFlare_Title, NS.CommunityFlare_Version, NS.CommunityFlare_Build)
	end

	-- nothing
	return nil
end

-- convert table to string
function NS.CommunityFlare_TableToString(table)
	-- all loaded?
	if (NS.Libs.AceSerializer and NS.Libs.LibDeflate) then
		-- serialize and compress
		local one = NS.Libs.AceSerializer:Serialize(table)
		local two = NS.Libs.LibDeflate:CompressDeflate(one, {level = 9})
		local final = NS.Libs.LibDeflate:EncodeForPrint(two)

		-- return final
		return final
	end

	-- failed
	return nil
end

-- convert string to table
function NS.CommunityFlare_StringToTable(string)
	-- all loaded?
	if (NS.Libs.AceSerializer and NS.Libs.LibDeflate) then
		-- decode, decompress, deserialize
		local one = NS.Libs.LibDeflate:DecodeForPrint(string)
		local two = NS.Libs.LibDeflate:DecompressDeflate(one)
		local status, final = NS.Libs.AceSerializer:Deserialize(two)

		-- success?
		if (status == true) then
			-- return final
			return final
		end
	end

	-- failed
	return nil
end

-- parse command
function NS.CommunityFlare_ParseCommand(text)
	local table = {}
	local params = strgmatch(text, "([^@]+)");
	for param in params do
		tinsert(table, param)
	end
	return table
end

-- promote player to party leader
function NS.CommunityFlare_PromoteToPartyLeader(player)
	-- is player full name in party?
	if (UnitInParty(player) == true) then
		PromoteToLeader(player)
		return true
	end

	-- try using short name
	local name, realm = strsplit("-", player)
	if (realm == NS.CommFlare.CF.PlayerServerName) then
		player = name
	end

	-- unit is in party?
	if (UnitInParty(player) == true) then
		PromoteToLeader(player)
		return true
	end
	return false
end

-- load session variables
function NS.CommunityFlare_LoadSession()
	-- misc stuff
	NS.CommFlare.CF.MatchStatus = NS.db.profile.MatchStatus
	NS.CommFlare.CF.Queues = NS.db.profile.Queues or {}

	-- battleground specific data
	NS.CommFlare.CF.ASH = NS.db.profile.ASH or {}
	NS.CommFlare.CF.AV = NS.db.profile.AV or {}
	NS.CommFlare.CF.IOC = NS.db.profile.IOC or {}
	NS.CommFlare.CF.WG = NS.db.profile.WG or {}
end

-- save session variables
function NS.CommunityFlare_SaveSession()
	-- global created?
	if (not NS.db.global) then
		NS.db.global = {}
	end

	-- misc stuff
	NS.db.global.members = NS.db.global.members or {}
	NS.db.profile.MatchStatus = NS.CommFlare.CF.MatchStatus
	NS.db.profile.Queues = NS.CommFlare.CF.Queues or {}
	NS.db.profile.SavedTime = time()

	-- currently in battleground?
	if (PvPIsBattleground() == true) then
		-- save any settings
		NS.db.profile.ASH = NS.CommFlare.CF.ASH or {}
		NS.db.profile.AV = NS.CommFlare.CF.AV or {}
		NS.db.profile.IOC = NS.CommFlare.CF.IOC or {}
		NS.db.profile.WG = NS.CommFlare.CF.WG or {}
	else
		-- reset settings
		NS.db.profile.ASH = {}
		NS.db.profile.AV = {}
		NS.db.profile.IOC = {}
		NS.db.profile.WG = {}
	end

	-- debug mode?
	if (NS.db.profile.debugMode == true) then
		-- save CF
		NS.db.profile.CF = NS.CommFlare.CF
	end
end

-- send to party, whisper, or bnet message
function NS.CommunityFlare_SendMessage(sender, msg)
	-- party?
	if (not sender) then
		-- send to party chat
		SendChatMessage(msg, "PARTY")
	-- string?
	elseif (type(sender) == "string") then
		-- raid warning?
		if (sender == "RAID_WARNING") then
			-- send to raid warning
			SendChatMessage(msg, "RAID_WARNING")
		else
			-- send to target whisper
			SendChatMessage(msg, "WHISPER", nil, sender)
		end
	elseif (type(sender) == "number") then
		-- send to battle net whisper
		BNSendWhisper(sender, msg)
	end
end

-- get battle net character
function NS.CommunityFlare_GetBNetFriendName(bnSenderID)
	-- not number?
	if (type(bnSenderID) ~= "number") then
		-- failed
		return nil
	end

	-- get bnet friend index
	local index = BNGetFriendIndex(bnSenderID)
	if (index ~= nil) then
		-- process all bnet accounts logged in
		local numGameAccounts = BattleNetGetFriendNumGameAccounts(index)
		for i=1, numGameAccounts do
			-- check if account has player guid online
			local accountInfo = BattleNetGetFriendGameAccountInfo(index, i)
			if (accountInfo.playerGuid) then
				-- build full player-realm
				return strformat("%s-%s", accountInfo.characterName, accountInfo.realmName)
			end
		end
	end

	-- failed
	return nil
end

-- readd community chat window
function NS.CommunityFlare_ReaddCommunityChatWindow(clubId, streamId)
	-- remove channel
	local channel, chatFrameID = Chat_GetCommunitiesChannel(clubId, streamId)
	if (not channel and not chatFrameID) then
		-- failed
		return
	elseif (not channel) then
		-- add channel
		ChatFrame_AddNewCommunitiesChannel(1, clubId, streamId, nil)
	elseif (not chatFrameID or (chatFrameID == 0)) then
		-- remove channel
		ChatFrame_RemoveCommunitiesChannel(ChatFrame1, clubId, streamId, false)

		-- add channel
		ChatFrame_AddNewCommunitiesChannel(1, clubId, streamId, nil)
	else
		-- remove channel
		local channelName = Chat_GetCommunitiesChannelName(clubId, streamId)
		ChatFrame_RemoveChannel(ChatFrame1, channelName)

		-- add channel
		ChatFrame_AddChannel(ChatFrame1, channelName)
	end
end

-- re-add community channels on initial load
function NS.CommunityFlare_ReaddChannelsInitialLoad()
	-- has main community?
	if (NS.db.profile.communityMain > 1) then
		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(NS.db.profile.communityMain, 1)
	end

	-- has other communities?
	if (next(NS.db.profile.communityList)) then
		-- process all
		local timer = 0.2
		for k,v in pairs(NS.db.profile.communityList) do
			-- only process true
			if (v == true) then
				-- stagger readding
				TimerAfter(timer, function ()
					-- readd community chat window
					NS.CommunityFlare_ReaddCommunityChatWindow(k, 1)
				end)

				-- next
				timer = timer + 0.2
			end
		end
	end
end

-- is specialization healer?
function NS.CommunityFlare_IsHealer(spec)
	if (spec == L["Discipline"]) then
		return true
	elseif (spec == L["Holy"]) then
		return true
	elseif (spec == L["Mistweaver"]) then
		return true
	elseif (spec == L["Preservation"]) then
		return true
	elseif (spec == L["Restoration"]) then
		return true
	end
	return false
end

-- is specialization tank?
function NS.CommunityFlare_IsTank(spec)
	if (spec == L["Blood"]) then
		return true
	elseif (spec == L["Brewmaster"]) then
		return true
	elseif (spec == L["Guardian"]) then
		return true
	elseif (spec == L["Protection"]) then
		return true
	elseif (spec == L["Vengeance"]) then
		return true
	end
	return false
end

-- get full player name
function NS.CommunityFlare_GetFullName(player)
	-- force name-realm format
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end
	return player
end

-- get proper player name by type
function NS.CommunityFlare_GetPlayerName(type)
	local name, realm = UnitFullName("player")
	if (type == "full") then
		-- no realm name?
		if (not realm or (realm == "")) then
			realm = NS.CommFlare.CF.PlayerServerName
		end
		return strformat("%s-%s", name, realm)
	end
	return name
end

-- is currently group leader?
function NS.CommunityFlare_IsGroupLeader()
	-- has sub group members?
	if (GetNumSubgroupMembers() == 0) then
		return true
	-- is group leader?
	elseif (UnitIsGroupLeader("player")) then
		return true
	end
	return false
end

-- get current party leader
function NS.CommunityFlare_GetPartyLeader()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then 
			local name, realm = UnitName("party" .. i)
			if (realm and (realm ~= "")) then
				-- add realm name
				name = name .. "-" .. realm
			end

			-- leader found
			return name
		end
	end

	-- solo atm
	return NS.CommunityFlare_GetPlayerName("full")
end

-- get current party guid
function NS.CommunityFlare_GetPartyLeaderGUID()
	-- process all sub group members
	for i=1, GetNumSubgroupMembers() do 
		if (UnitIsGroupLeader("party" .. i)) then
			-- return guid
			return UnitGUID("party" .. i)
		end
	end

	-- solo atm
	return UnitGUID("player")
end

-- get party unit
function NS.CommunityFlare_GetPartyUnit(player)
	-- force name-realm format
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- process all group members
	for i=1, GetNumGroupMembers() do
		local unit = "party" .. i
		local name, realm = UnitName(unit)
		if (name and (name ~= "")) then
			-- no realm name?
			if (not realm or (realm == "")) then
				-- get realm name
				realm = NS.CommFlare.CF.PlayerServerName
			end

			-- full name matches?
			name = name .. "-" .. realm
			if (player == name) then
				return unit
			end
		end
	end

	-- failed
	return nil
end

-- get total group count
function NS.CommunityFlare_GetGroupCount()
	-- get proper count
	NS.CommFlare.CF.Count = 1
	if (IsInGroup()) then
		if (not IsInRaid()) then
			-- update count
			NS.CommFlare.CF.Count = GetNumGroupMembers()
		end
	end

	-- return x/5 count
	return strformat("%d/5", NS.CommFlare.CF.Count)
end

-- get group members
function NS.CommunityFlare_GetGroupMembers()
	-- are you grouped?
	local players = {}
	if (IsInGroup()) then
		-- are you in a raid?
		if (not IsInRaid()) then
			-- process all group members
			for i=1, GetNumGroupMembers() do
				local name, realm = UnitName("party" .. i)

				-- add party member
				players[i] = {}
				players[i].guid = UnitGUID("party" .. i)
				players[i].name = name
				players[i].realm = realm
			end
		end
	else
		-- add yourself
		players[1] = {}
		players[1].guid = UnitGUID("player")
		players[1].player = NS.CommunityFlare_GetPlayerName("full")
	end
	return players
end

-- get member count
function NS.CommunityFlare_GetMemberCount()
	-- sanity check?
	if (not NS.db.global) then
		-- initialize
		NS.db.global = {}
	end
	if (not NS.db.global.members) then
		-- initialize
		NS.db.global.members = {}
	end

	-- process all
	local count = 0
	for k,v in pairs(NS.db.global.members) do
		-- increase
		count = count + 1
	end

	-- success
	return count
end

-- check if a unit has type aura active
function NS.CommunityFlare_CheckForAura(unit, type, auraName)
	-- save global variable if aura is active
	NS.CommFlare.CF.HasAura = false
	AuraUtilForEachAura(unit, type, nil, function(name, icon, ...)
		if (name == auraName) then
			NS.CommFlare.CF.HasAura = true
			return true
		end
	end)
end

-- popup box
function NS.CommunityFlare_PopupBox(dlg, message)
	-- requires community id?
	local showPopup = true
	if (dlg == "CommunityFlare_Send_Community_Dialog") then
		-- report ID set?
		local clubId = 0
		showPopup = false
		if (NS.db.profile.communityReportID and (NS.db.profile.communityReportID > 1)) then
			-- show
			showPopup = true
		end
	end

	-- show popup?
	if (showPopup == true) then
		-- popup box setup
		local popup = StaticPopupDialogs[dlg]

		-- show the popup box
		NS.CommFlare.CF.PopupMessage = message
		local dialog = StaticPopup_Show(dlg, message)
		if (dialog) then
			dialog.data = NS.CommFlare.CF.PopupMessage
		end

		-- restore popup
		StaticPopupDialogs[dlg] = popup
	end
end

-- process version check
function NS.CommunityFlare_Process_Version_Check(sender)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender, false) == false) then
		-- finished
		return
	end

	-- send community flare version number
	NS.CommunityFlare_SendMessage(sender, strformat("%s: %s (%s)", NS.CommunityFlare_Title, NS.CommunityFlare_Version, NS.CommunityFlare_Build))
end

-- send community dialog box
StaticPopupDialogs["CommunityFlare_Send_Community_Dialog"] = {
	text = L["Send: %s?"],
	button1 = L["Send"],
	button2 = L["No"],
	OnAccept = function(self, message)
		-- report ID set?
		if (NS.db.profile.communityReportID and (NS.db.profile.communityReportID > 1)) then
			-- club id found?
			local clubId = NS.db.profile.communityReportID
			if (clubId > 0) then
				local streamId = 1
				local channelName = Chat_GetCommunitiesChannelName(clubId, streamId)
				local id, name = GetChannelName(channelName)
				if ((id > 0) and (name ~= nil)) then
					-- send channel messsage (hardware click acquired)
					SendChatMessage(message, "CHANNEL", nil, id)
				end
			end
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- kick dialog box
StaticPopupDialogs["CommunityFlare_Kick_Dialog"] = {
	text = L["Kick: %s?"],
	button1 = L["Yes"],
	button2 = L["No"],
	OnAccept = function(self, player)
		-- uninvite user
		print(L["Uninviting ..."])
		UninviteUnit(player, L["AFK"])

		-- community auto invite enabled?
		local text = L["You've been removed from the party for being AFK."]
		if (NS.db.profile.communityAutoInvite == true) then
			-- update text for info about being reinvited
			text = strformat("%s %s", text, L["Whisper me INV and if a spot is still available, you'll be readded to the party."])
		end

		-- send message
		NS.CommunityFlare_SendMessage(player, text)
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- rebuild members dialog box
StaticPopupDialogs["CommunityFlare_Rebuild_Members_Dialog"] = {
	text = L["Are you sure you want to wipe the members database and totally rebuild from scratch?"],
	button1 = L["Yes"],
	button2 = L["No"],
	OnAccept = function(self, player)
		-- rebuild database
		NS.CommunityFlare_Rebuild_Database_Members()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
}

-- process party states
function NS.CommunityFlare_Process_Party_States(isDead, isOffline)
	-- process all
	for i=1, GetNumGroupMembers() do
		local kickPlayer = false
		local unit = "party" .. i
		local player, realm = UnitName(unit)
		if (player and (player ~= "")) then
			-- realm name was given?
			if (realm and (realm ~= "")) then
				player = player .. "-" .. realm
			end

			-- are they dead/ghost?
			if ((isDead == true) and (UnitIsDeadOrGhost(unit) == true)) then
				-- kick them
				kickPlayer = true
			end

			-- are they offline?
			if ((isOffline == true) and (UnitIsConnected(unit) ~= true)) then
				-- kick them
				kickPlayer = true
			end

			-- should kick?
			if (kickPlayer == true) then
				-- are you leader?
				if (NS.CommunityFlare_IsGroupLeader() == true) then
					-- ask to kick?
					NS.CommunityFlare_PopupBox("CommunityFlare_Kick_Dialog", player)
				end
			end
		end
	end
end

-- hide chat frame
function NS.CommunityFlare_Hide_Chat_Frame(sender)
	-- build proper name
	local player = sender
	if (strmatch(player, "-")) then
		-- remove realm name
		player = strsplit("-", player)
	end

	-- process all chat frames
	for k,v in pairs(CHAT_FRAMES) do
		-- find frame + tab
		local chatFrame = _G[v];
		local chatTab = _G[v .. "Tab"]
		if (chatTab and chatTab.whisperName) then
			-- matches?
			if (strmatch(chatTab.whisperName, player)) then
				-- hide
				chatFrame:Hide()
				chatTab:Hide()
				FCF_UnDockFrame(chatFrame);
				HideUIPanel(chatFrame);
			end
		end
	end
end

-- handle internal commands
function NS.CommunityFlare_Handle_Internal_Commands(event, sender, text, ...)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender, true) == false) then
		-- supress
		return true
	end

	-- always hide chat frame
	NS.CommunityFlare_Hide_Chat_Frame(sender)

	-- suppress all inform
	if (event == "CHAT_MSG_WHISPER_INFORM") then
		-- supress
		return true
	end

	-- table initialized?
	if (not NS.CommFlare.CF.InternalCommands[sender]) then
		-- initialize
		NS.CommFlare.CF.InternalCommands[sender] = {}
	end

	-- split text
	local args = {strsplit("@", text)}
	if (args and args[1] and args[2]) then
		-- verify args[1]
		if (args[1] == "!CF") then
			-- battleground?
			local lower = strlower(args[2])
			if ((lower == "battleground") and args[3]) then
				-- command already sent?
				local command = strlower(args[3])
				if (NS.CommFlare.CF.InternalCommands[sender][command]) then
					-- suppress
					return true
				end

				-- sanity check
				if ((command ~= "check") and (command ~= "status")) then
					-- suppress
					return true
				end

				-- command sent
				NS.CommFlare.CF.InternalCommands[sender][command] = time()
				TimerAfter(5, function ()
					-- clear 5 seconds
					NS.CommFlare.CF.InternalCommands[sender][command] = nil
				end)

				-- check?
				if (command == "check") then
					-- find active battleground
					local text = ""
					for i=1, GetMaxBattlefieldID() do
						-- active match?
						local status, mapName = GetBattlefieldStatus(i)

						-- has status to send?
						if ((status == "active") or (status == "confirm") or (status == "queued")) then
							-- already has text?
							if (text ~= "") then
								-- add separator
								text = text .. ";"
							end
						end

						-- active?
						if (status == "active") then
							-- add bg info
							local runtime = GetBattlefieldInstanceRunTime()
							local duration = PvPGetActiveMatchDuration() * 1000
							text = text .. strformat("A,%s,%d,%d", mapName, duration, runtime)
						-- confirm?
						elseif (status == "confirm") then
							-- add pop info
							local count = NS.CommunityFlare_GetGroupCount()
							local expiration = GetBattlefieldPortExpiration(i) * 1000
							text = text .. strformat("C,%s,%d,%d", mapName, expiration, count)
						-- queued?
						elseif (status == "queued") then
							-- add queue info
							local waited = GetBattlefieldTimeWaited(i)
							local estimated = GetBattlefieldEstimatedWaitTime(i)
							text = text .. strformat("Q,%s,%d,%d", mapName, waited, estimated)
						end
					end

					-- nothing?
					if (text == "") then
						-- none
						text = "none"
					end

					-- send message
					NS.CommunityFlare_SendMessage(sender, strformat("!CF@Battleground@Status@%s", text))
				-- status?
				elseif ((command == "status") and args[4]) then
					-- none?
					if (args[4] == "none") then
						-- display sender is not in queue
						print(strformat(L["%s: %s is not in queue."], NS.CommunityFlare_Title, sender))
					else
						-- split arguments
						local queues = {strsplit(";", args[4])}
						for k,v in ipairs(queues) do
							-- display sender queue info
							local status, mapName, arg1, arg2 = strsplit(",", v)

							-- active?
							if (status == "A") then
								-- calculate times
								local msecs = { tonumber(arg1), tonumber(arg2) }
								local seconds = { mfloor(msecs[1] / 1000), mfloor(msecs[2] / 1000) }
								local minutes = { mfloor(seconds[1] / 60), mfloor(seconds[2] / 60) }
								seconds[1] = seconds[1] - (minutes[1] * 60)
								seconds[2] = seconds[2] - (minutes[2] * 60)

								-- display bg info
								print(strformat(L["%s: %s is active for %s for %d minutes, %d seconds. (Active Time: %d minutes, %d seconds.)"], NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], minutes[2], seconds[2]))
							-- confirm?
							elseif (status == "C") then
								-- calculate times
								local msecs = { tonumber(arg1) }
								local seconds = { mfloor(msecs[1] / 1000) }
								local minutes = { mfloor(seconds[1] / 60) }
								seconds[1] = seconds[1] - (minutes[1] * 60)

								-- display pop info
								print(strformat(L["%s: %s is popped for %s for %d minutes, %d seconds. (Count: %s.)"], NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], arg2))
							-- queued?
							elseif (status == "Q") then
								-- calculate times
								local msecs = { tonumber(arg1), tonumber(arg2) }
								local seconds = { mfloor(msecs[1] / 1000), mfloor(msecs[2] / 1000) }
								local minutes = { mfloor(seconds[1] / 60), mfloor(seconds[2] / 60) }
								seconds[1] = seconds[1] - (minutes[1] * 60)
								seconds[2] = seconds[2] - (minutes[2] * 60)

								-- display queue info
								print(strformat(L["%s: %s is queued for %s for %d minutes, %d seconds. (Estimated Wait: %d minutes, %d seconds.)"], NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], minutes[2], seconds[2]))
							end
						end
					end
				end
			-- mercenary?
			elseif ((lower == "mercenary") and args[3]) then
				-- command already sent?
				local command = strlower(args[3])
				if (NS.CommFlare.CF.InternalCommands[sender][command]) then
					-- suppress
					return true
				end

				-- sanity check
				if ((command ~= "check") and (command ~= "status")) then
					-- suppress
					return true
				end

				-- command sent
				NS.CommFlare.CF.InternalCommands[sender][command] = time()
				TimerAfter(5, function ()
					-- clear 5 seconds
					NS.CommFlare.CF.InternalCommands[sender][command] = nil
				end)

				-- check?
				if (command == "check") then
					-- check for mercenary buff
					NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
					if (NS.CommFlare.CF.HasAura == true) then
						-- send message
						NS.CommunityFlare_SendMessage(sender, "!CF@Mercenary@Status@true")
					else
						-- send message
						NS.CommunityFlare_SendMessage(sender, "!CF@Mercenary@Status@false")
					end
				-- status?
				elseif ((command == "status") and args[4]) then
					-- check status
					local status = strlower(args[4])
					if (status == "true") then
						-- mercenary enabled
						print(strformat(L["%s: %s has Mercenary Contract enabled."], NS.CommunityFlare_Title, sender))
					elseif (status == "false") then
						-- mercenary disabled
						print(strformat(L["%s: %s has Mercenary Contract disabled."], NS.CommunityFlare_Title, sender))
					end
				end
			-- party?
			elseif ((lower == "party") and args[3]) then
				-- command already sent?
				local command = strlower(args[3])
				if (NS.CommFlare.CF.InternalCommands[sender][command]) then
					-- suppress
					return true
				end

				-- sanity check
				if ((command ~= "check") and (command ~= "status")) then
					-- suppress
					return true
				end

				-- command sent
				NS.CommFlare.CF.InternalCommands[sender][command] = time()
				TimerAfter(5, function ()
					-- clear 5 seconds
					NS.CommFlare.CF.InternalCommands[sender][command] = nil
				end)

				-- check?
				if (command == "check") then
					-- send party info
					local isRaid = IsInRaid() and "true" or "false"
					local isGroup = IsInGroup() and "true" or "false"
					local numGroupMembers = GetNumGroupMembers()
					local numSubgroupMembers = GetNumSubgroupMembers()
					NS.CommunityFlare_SendMessage(sender, strformat("!CF@Party@Status@%s,%s,%d,%d", isRaid, isGroup, numGroupMembers, numSubgroupMembers))
				-- status?
				elseif (command == "status") then
					-- check status
					local isRaid, isGroup, numGroupMembers, numSubGroupMembers = strsplit(",", args[4])
					if (isRaid == "true") then
						-- raid group
						print(strformat(L["%s: %s is in raid with %d players."], NS.CommunityFlare_Title, sender, numGroupMembers))
					elseif (isGroup == "true") then
						-- party group
						print(strformat(L["%s: %s is in party with %d players."], NS.CommunityFlare_Title, sender, numGroupMembers))
					else
						-- party group
						print(strformat(L["%s: %s is not in any party or raid."], NS.CommunityFlare_Title, sender))
					end
				end
			end
		end
	end

	-- supress
	return true
end
