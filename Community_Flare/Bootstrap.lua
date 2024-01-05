local LibStub = LibStub
local ADDON_NAME, NS = ...

-- localize stuff
local _G                                        = _G
local GetAddOnMetadata                          = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata
local GetInviteConfirmationInfo                 = _G.GetInviteConfirmationInfo
local GetNextPendingInviteConfirmation          = _G.GetNextPendingInviteConfirmation
local RespondToInviteConfirmation               = _G.RespondToInviteConfirmation
local Settings_OpenToCategory                   = _G.Settings.OpenToCategory
local SocialQueueUtil_GetRelationshipInfo       = _G.SocialQueueUtil_GetRelationshipInfo
local StaticPopup_FindVisible                   = _G.StaticPopup_FindVisible
local StaticPopup_Hide                          = _G.StaticPopup_Hide
local BattleNetGetAccountInfoByGUID             = _G.C_BattleNet.GetAccountInfoByGUID
local PartyInfoGetInviteReferralInfo            = _G.C_PartyInfo.GetInviteReferralInfo
local tonumber                                  = _G.tonumber
local type                                      = _G.type
local strformat                                 = _G.string.format

-- get current version
NS.CommunityFlare_Name = ADDON_NAME
NS.CommunityFlare_Build = GetAddOnMetadata(ADDON_NAME, "X-Build") or "unspecified"
NS.CommunityFlare_Title = GetAddOnMetadata(ADDON_NAME, "Title") or "unspecified"
NS.CommunityFlare_Version = GetAddOnMetadata(ADDON_NAME, "Version") or "unspecified"
NS.CommunityFlare_Title_Full = strformat("%s %s (%s)", NS.CommunityFlare_Title, NS.CommunityFlare_Version, NS.CommunityFlare_Build)

-- initialize libraries
NS.Libs = {
	AceAddon = LibStub("AceAddon-3.0"),
	AceGUI = LibStub("AceGUI-3.0"),
	AceConfig = LibStub("AceConfig-3.0"),
	AceConfigDialog = LibStub('AceConfigDialog-3.0'),
	AceDB = LibStub("AceDB-3.0"),
	AceDBOptions = LibStub("AceDBOptions-3.0"),
	AceLocale = LibStub("AceLocale-3.0"),
	AceSerializer = LibStub("AceSerializer-3.0"),
	LibDeflate = LibStub("LibDeflate"),
	LibDropDownExtension = LibStub("LibDropDownExtension-1.0"),
}

-- initialize
NS.CommFlare = NS.Libs.AceAddon:NewAddon(ADDON_NAME, "AceComm-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
NS.CommFlare.CF = {
	-- strings
	MapName = "N/A",
	MatchStartDate = "",
	PlayerServerName = "",
	TurnSpeed = "",

	-- booleans
	AutoInvite = false,
	AutoPromote = false,
	AutoQueue = false,
	AutoQueueable = false,
	DefaultVerified = false,
	Disabled = false,
	InitialLogin = false,
	Invisible = false,
	HasAura = false,
	NeedAddonData = false,
	Popped = false,
	Reloaded = false,

	-- numbers
	ClubCount = 0,
	Count = 0,
	CountDown = 0,
	CommCount = 0,
	EnteredTime = 0,
	EstimatedWaitTime = 0,
	Expiration = 0,
	HideIndex = 0,
	IsHealer = 0,
	IsTank = 0,
	LeftTime = 0,
	LogListCount = 0,
	MapID = 0,
	MatchStartTime = 0,
	MatchStatus = 0,
	MaxPriority = 999,
	MercCount = 0,
	NumScores = 0,
	PlayerRank = 0,
	Position = 0,
	PreviousCount = 0,
	QuestID = 0,
	SavedTime = 0,

	-- misc
	Category = nil,
	Field = nil,
	Header = nil,
	Leader = nil,
	Options = nil,
	PartyGUID = nil,
	PopupMessage = nil,
	Winner = nil,

	-- tables
	Clubs = {},
	ClubList = {},
	ClubMembers = {},
	CommCounts = {},
	CommNames = {},
	CommNamesList = {},
	CommunityLeaders = {},
	CurrentPopped = {},
	InternalCommands = {},
	LocalData = {},
	LocalQueues = {},
	LogListNamesList = {},
	MapInfo = {},
	MemberInfo = {},
	MercCounts = {},
	MercNames = {},
	MercNamesList = {},
	PartyVersions = {},
	PlayerInfo = {},
	POIInfo = {},
	PoppedGroups = {},
	ReadyCheck = {},
	RoleChosen = {},
	RoleCounts = {},
	SocialQueues = {},
	StatusCheck = {},
	WidgetInfo = {},

	-- misc stuff
	Alliance = { Count = 0, Healers = 0, Tanks = 0 },
	Horde = { Count = 0, Healers = 0, Tanks = 0 },
	Timer = { Minutes = 0, MilliSeconds = 0, Seconds = 0 },

	-- battleground specific data
	ASH = {},
	AV = {},
	IOC = {},
	WG = {}
}

-- refresh config
function NS.CommFlare:RefreshConfig()
	-- setup community lists
	NS.CommunityFlare_Setup_Main_Community_List(nil)
	NS.CommunityFlare_Setup_Other_Community_List(nil)
end

-- handle pending invite confirmations
function NS.CommFlare:HandlePendingInviteConfirmation(invite)
	-- mercenary queued?
	if (NS.CommunityFlare_Battleground_IsMercenaryQueued() == true) then
		-- get next pending invite
		local invite = GetNextPendingInviteConfirmation()
		if (invite) then
			-- get invite confirmation info
			local confirmationType, sender, guid, rolesInvalid, willConvertToRaid, level, spec, itemLevel = GetInviteConfirmationInfo(invite)
			local referredByGuid, referredByName, relationType, isQuickJoin, clubId = PartyInfoGetInviteReferralInfo(invite)
			local playerName, color, selfRelationship = SocialQueueUtil_GetRelationshipInfo(guid, name, clubId)

			-- cancel invite
			RespondToInviteConfirmation(invite, false)

			-- hide popup
			if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
				-- hide
				StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
			end

			-- battle net friend?
			if (selfRelationship == "bnfriend") then
				local accountInfo = BattleNetGetAccountInfoByGUID(guid)
				if (accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.playerGuid) then
					-- send battle net message
					NS.CommunityFlare_SendMessage(accountInfo.bnetAccountID, L["Sorry, can not accept invites while currently queued as a mercenary."])
				end
			else
				-- send message
				NS.CommunityFlare_SendMessage(sender, L["Sorry, can not accept invites while currently queued as a mercenary."])
			end
		end
	else
		-- call original
		NS.CommFlare.hooks.HandlePendingInviteConfirmation(invite)
	end
end

-- handle incoming commands
function NS.CommFlare:FloatingChatFrameManager_OnEvent(self, event, ...)
	-- internal command?
	local text, sender, _, _, _, _, _, _, _, _, _, _, bnSenderID = ...
	if (text:find("!CF@")) then
		-- normal whisper?
		if (event == "CHAT_MSG_WHISPER") then
			-- handle commands
			NS.CommunityFlare_Handle_Internal_Commands(event, sender, text, ...)
		-- Battle.NET whisper?
		elseif (event == "CHAT_MSG_BN_WHISPER") then
			-- handle commands
			NS.CommunityFlare_Handle_Internal_Commands(event, bnSenderID, text, ...)
		end
	-- afk?
	elseif (event == "CHAT_MSG_AFK") then
		-- nothing
	else
		-- call original
		NS.CommFlare.hooks[FloatingChatFrameManager].OnEvent(self, event, ...)
	end
end

-- on initialize
function NS.CommFlare:OnInitialize()
	-- setup stuff
	NS.db = NS.Libs.AceDB:New("CommunityFlareDB", NS.defaults)
	NS.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	NS.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	NS.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	NS.Libs.AceConfig:RegisterOptionsTable("CommFlare_Options", NS.options)
	self.optionsFrame = NS.Libs.AceConfigDialog:AddToBlizOptions("CommFlare_Options", NS.CommunityFlare_Title)
	NS.profiles = NS.Libs.AceDBOptions:GetOptionsTable(NS.db)
	NS.Libs.AceConfig:RegisterOptionsTable("CommFlare_Profiles", NS.profiles)
	self.profilesFrame = NS.Libs.AceConfigDialog:AddToBlizOptions("CommFlare_Profiles", "Profiles", NS.CommunityFlare_Title)
	NS.CommFlare:RawHook("HandlePendingInviteConfirmation", true)
	NS.CommFlare:RawHookScript(FloatingChatFrameManager, "OnEvent", "FloatingChatFrameManager_OnEvent")

	-- check for old string values?
	if (type(NS.db.profile.blockSharedQuests) == "string") then
		-- convert to number
		NS.db.profile.blockSharedQuests = tonumber(NS.db.profile.blockSharedQuests)
	end
	if (type(NS.db.profile.communityAutoAssist) == "string") then
		-- convert to number
		NS.db.profile.communityAutoAssist = tonumber(NS.db.profile.communityAutoAssist)
	end
	if (type(NS.db.profile.uninvitePlayersAFK) == "string") then
		-- convert to number
		NS.db.profile.uninvitePlayersAFK = tonumber(NS.db.profile.uninvitePlayersAFK)
	end
end

-- addon compartment on click
function CommunityFlare_AddonCompartmentOnClick(addonName, buttonName)
	-- already opened?
	if (SettingsPanel:IsShown()) then
		-- hide
		SettingsPanel:Hide()
	else
		-- open options to Community Flare
		Settings_OpenToCategory(NS.CommunityFlare_Title)
		Settings_OpenToCategory(NS.CommunityFlare_Title) -- open options again (wow bug workaround)
	end
end
