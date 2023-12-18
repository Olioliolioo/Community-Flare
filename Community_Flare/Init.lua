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
local GetChannelName                            = _G.GetChannelName
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
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
local UnitRealmRelationship                     = _G.UnitRealmRelationship
local AuraUtilForEachAura                       = _G.AuraUtil.ForEachAura
local BattleNetGetFriendGameAccountInfo         = _G.C_BattleNet.GetFriendGameAccountInfo
local BattleNetGetFriendNumGameAccounts         = _G.C_BattleNet.GetFriendNumGameAccounts
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
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
local strsub                                    = _G.string.sub
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

	-- version?
	if (name == "Version") then
		-- return community flare version
		return strformat("%s: %s (%s)", NS.CommunityFlare_Title, NS.CommunityFlare_Version, NS.CommunityFlare_Build)
	end

	-- nothing
	return nil
end

-- sanith check
function NS.CommunityFlare_Sanity_Checks()
	-- local data?
	if (not NS.CommFlare.CF.LocalData) then
		-- initialize
		NS.CommFlare.CF.LocalData = {
			["NumTanks"] = 0,
			["NumHealers"] = 0,
			["NumDPS"] = 0,
		}
	end

	-- num tanks?
	if (not NS.CommFlare.CF.LocalData.NumTanks) then
		-- initialize
		NS.CommFlare.CF.LocalData.NumTanks = 0
	end

	-- num healers?
	if (not NS.CommFlare.CF.LocalData.NumHealers) then
		-- initialize
		NS.CommFlare.CF.LocalData.NumHealers = 0
	end

	-- num dps?
	if (not NS.CommFlare.CF.LocalData.NumDPS) then
		-- initialize
		NS.CommFlare.CF.LocalData.NumDPS = 0
	end
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
	-- reload settings
	NS.CommFlare.CF.MatchStatus = NS.db.profile.MatchStatus
	NS.CommFlare.CF.LocalQueues = NS.db.profile.LocalQueues or {}
	NS.CommFlare.CF.SocialQueues = NS.db.global.SocialQueues or {}

	-- battleground specific data
	NS.CommFlare.CF.ASH = NS.db.profile.ASH or {}
	NS.CommFlare.CF.AV = NS.db.profile.AV or {}
	NS.CommFlare.CF.IOC = NS.db.profile.IOC or {}
	NS.CommFlare.CF.WG = NS.db.profile.WG or {}
end

-- save session variables
function NS.CommunityFlare_SaveSession()
	-- update global stuff
	NS.db.global = NS.db.global or {}
	NS.db.global.members = NS.db.global.members or {}
	NS.db.global.SocialQueues = NS.CommFlare.CF.SocialQueues or {}

	-- update profile stuff
	NS.db.profile.SavedTime = time()
	NS.db.profile.MatchStatus = NS.CommFlare.CF.MatchStatus
	NS.db.profile.LocalQueues = NS.CommFlare.CF.LocalQueues or {}

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

-- get party count
function NS.CommunityFlare_GetPartyCount()
	-- get proper count
	NS.CommFlare.CF.Count = 1
	if (IsInGroup()) then
		if (not IsInRaid()) then
			-- update count
			NS.CommFlare.CF.Count = GetNumGroupMembers()
		end
	end

	-- return count
	return NS.CommFlare.CF.Count
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

-- queue check role chosen
function NS.CommunityFlare_Queue_Check_Role_Chosen()
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
end
