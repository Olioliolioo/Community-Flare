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
local AcceptGroup                               = _G.AcceptGroup
local AchievementFrame_LoadUI                   = _G.AchievementFrame_LoadUI
local ChatFrame_AddMessageEventFilter           = _G.ChatFrame_AddMessageEventFilter
local ClassTalentFrame_LoadUI                   = _G.ClassTalentFrame_LoadUI
local CollectionsJournal_LoadUI                 = _G.CollectionsJournal_LoadUI
local Communities_LoadUI                        = _G.Communities_LoadUI
local DeclineQuest                              = _G.DeclineQuest
local EncounterJournal_LoadUI                   = _G.EncounterJournal_LoadUI
local GetAddOnCPUUsage                          = _G.GetAddOnCPUUsage
local GetAddOnMemoryUsage                       = _G.GetAddOnMemoryUsage
local GetAutoCompletePresenceID                 = _G.GetAutoCompletePresenceID
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldWinner                      = _G.GetBattlefieldWinner
local GetHomePartyInfo                          = _G.GetHomePartyInfo
local GetInviteConfirmationInfo                 = _G.GetInviteConfirmationInfo
local GetLFGRoleUpdate                          = _G.GetLFGRoleUpdate
local GetLFGRoleUpdateBattlegroundInfo          = _G.GetLFGRoleUpdateBattlegroundInfo
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNextPendingInviteConfirmation          = _G.GetNextPendingInviteConfirmation
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetQuestID                                = _G.GetQuestID
local GetRealmName                              = _G.GetRealmName
local HideUIPanel                               = _G.HideUIPanel
local InCombatLockdown                          = _G.InCombatLockdown
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local RaidWarningFrame_OnEvent                  = _G.RaidWarningFrame_OnEvent
local RespondToInviteConfirmation               = _G.RespondToInviteConfirmation
local SocialQueueUtil_GetRelationshipInfo       = _G.SocialQueueUtil_GetRelationshipInfo
local StaticPopup_FindVisible                   = _G.StaticPopup_FindVisible
local StaticPopup_Hide                          = _G.StaticPopup_Hide
local StaticPopup1Text                          = _G.StaticPopup1Text
local UnitFactionGroup                          = _G.UnitFactionGroup
local UnitGUID                                  = _G.UnitGUID
local UnitInRaid                                = _G.UnitInRaid
local UnitName                                  = _G.UnitName
local AreaPoiInfoGetAreaPOIForMap               = _G.C_AreaPoiInfo.GetAreaPOIForMap
local AreaPoiInfoGetAreaPOIInfo                 = _G.C_AreaPoiInfo.GetAreaPOIInfo
local BattleNetGetAccountInfoByGUID             = _G.C_BattleNet.GetAccountInfoByGUID
local ClubGetClubInfo                           = _G.C_Club.GetClubInfo
local ClubGetMemberInfo                         = _G.C_Club.GetMemberInfo
local GetCVar                                   = _G.C_CVar.GetCVar
local GetCVarDefault                            = _G.C_CVar.GetCVarDefault
local SetCVar                                   = _G.C_CVar.SetCVar
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PartyInfoGetInviteReferralInfo            = _G.C_PartyInfo.GetInviteReferralInfo
local PartyInfoIsPartyFull                      = _G.C_PartyInfo.IsPartyFull
local PartyInfoLeaveParty                       = _G.C_PartyInfo.LeaveParty
local PartyInfoSetRestrictPings                 = _G.C_PartyInfo.SetRestrictPings
local PvPGetActiveMatchState                    = _G.C_PvP.GetActiveMatchState
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local PvPGetScoreInfoByPlayerGuid               = _G.C_PvP.GetScoreInfoByPlayerGuid
local PvPIsArena                                = _G.C_PvP.IsArena
local PvPIsBattleground                         = _G.C_PvP.IsBattleground
local Settings_OpenToCategory                   = _G.Settings.OpenToCategory
local SocialQueueGetGroupInfo                   = _G.C_SocialQueue.GetGroupInfo
local SocialQueueGetGroupQueues                 = _G.C_SocialQueue.GetGroupQueues
local TimerAfter                                = _G.C_Timer.After
local date                                      = _G.date
local hooksecurefunc                            = _G.hooksecurefunc
local ipairs                                    = _G.ipairs
local math                                      = _G.math
local next                                      = _G.next
local pairs                                     = _G.pairs
local print                                     = _G.print
local time                                      = _G.time
local tonumber                                  = _G.tonumber
local strfind                                   = _G.string.find
local strformat                                 = _G.string.format
local strgsub                                   = _G.string.gsub
local strlower                                  = _G.string.lower
local strmatch                                  = _G.string.match
local strsplit                                  = _G.string.split

-- list current POI's
function NS.CommunityFlare_List_POIs()
	-- get map id
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (not NS.CommFlare.CF.MapID) then
		-- not found
		print(L["Map ID: Not Found"])
		return
	end

	-- get map info
	print(strformat("MapID: %d", NS.CommFlare.CF.MapID))
	NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
	if (not NS.CommFlare.CF.MapInfo) then
		-- not found
		print(L["Map ID: Not Found"])
		return
	end

	-- process any POI's
	print(strformat("Map Name: %s", NS.CommFlare.CF.MapInfo.name))
	local pois = AreaPoiInfoGetAreaPOIForMap(NS.CommFlare.CF.MapID)
	if (pois and (#pois > 0)) then
		-- display infos
		print(strformat("Count: %d", #pois))
		for _,v in ipairs(pois) do
			NS.CommFlare.CF.POIInfo = AreaPoiInfoGetAreaPOIInfo(NS.CommFlare.CF.MapID, v)
			if (NS.CommFlare.CF.POIInfo) then
				if ((not NS.CommFlare.CF.POIInfo.description) or (NS.CommFlare.CF.POIInfo.description == "")) then
					-- display info (no description)
					print(strformat("%s: ID = %d, textureIndex = %d", NS.CommFlare.CF.POIInfo.name, NS.CommFlare.CF.POIInfo.areaPoiID, NS.CommFlare.CF.POIInfo.textureIndex))
				else
					-- display info (with description)
					print(strformat("%s: ID = %d, textureIndex = %d, Description = %s", NS.CommFlare.CF.POIInfo.name, NS.CommFlare.CF.POIInfo.areaPoiID, NS.CommFlare.CF.POIInfo.textureIndex, NS.CommFlare.CF.POIInfo.description))
				end
			end
		end
	else
		-- none found
		print(L["Count: %d"], 0)
	end
end

-- securely hook accept battlefield port
function NS.CommunityFlare_AcceptBattlefieldPort(index, acceptFlag)
	-- invalid index?
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- is tracked pvp?
	local status, mapName = GetBattlefieldStatus(index)
	local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
	if (isTracked == true) then
		-- confirm?
		if (status == "confirm") then
			-- has queue popped?
			if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].popped and (NS.CommFlare.CF.LocalQueues[index].popped > 0)) then
				-- get count
				local count = NS.CommunityFlare_GetGroupCount()
				if (NS.CommFlare.CF.CurrentPopped["count"]) then
					-- use popped count
					count = strformat("%s, %d", count, NS.CommFlare.CF.CurrentPopped["count"])
				end

				-- has leader GUID?
				local leaderGUID = NS.CommFlare.CF.LeaderGUID
				if (not leaderGUID) then
					-- use player
					leaderGUID = UnitGUID("player")
				end

				-- accepted queue?
				local text = ""
				local partyGUID = NS.CommunityFlare_GetPartyGUID()
				if (acceptFlag == true) then
					-- mercenary?
					if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
						-- finalize text
						text = strformat(L["Entered Mercenary Queue For Popped %s!"], mapName)
					else
						-- finalize text
						text = strformat(L["Entered Queue For Popped %s!"], mapName)
					end

					-- save stuff
					NS.CommFlare.CF.LeftTime = 0
					NS.CommFlare.CF.EnteredTime = time()

					-- push data
					local guids = strformat("%s,%s", leaderGUID, partyGUID)
					NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Entered@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, NS.CommFlare.CF.EnteredTime, count, guids))
				else
					-- mercenary?
					if (NS.CommFlare.CF.LocalQueues[index].mercenary == true) then
						-- finalize text
						text = strformat(L["Left Mercenary Queue For Popped %s!"], mapName)
					else
						-- finalize text
						text = strformat(L["Left Queue For Popped %s!"], mapName)
					end

					-- community reporter enabled?
					if (NS.charDB.profile.communityReporter == true) then
						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end

					-- reset stuff
					NS.CommFlare.CF.LeftTime = time()
					NS.CommFlare.CF.EnteredTime = 0

					-- push data
					local guids = strformat("%s,%s", leaderGUID, partyGUID)
					NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Left@%s@%d@%s@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, NS.CommFlare.CF.LeftTime, count, guids))

					-- clear after 30 seconds
					TimerAfter(30, function()
						-- reset stuff
						NS.CommFlare.CF.LeftTime = 0
						NS.CommFlare.CF.CurrentPopped = {}
					end)
				end

				-- are you in a party?
				if (IsInGroup() and not IsInRaid()) then
					-- send party message
					NS.CommunityFlare_SendMessage(nil, text)
				end

				-- clear queue
				NS.CommFlare.CF.LocalQueues[index] = nil
			end
		end
	end
end

-- securely hook accept proposal
function NS.CommunityFlare_AcceptProposal()
	-- has queue popped?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].popped and (NS.CommFlare.CF.LocalQueues[index].popped > 0)) then
		-- has name?
		if (NS.CommFlare.CF.LocalQueues[index].name and (NS.CommFlare.CF.LocalQueues[index].name ~= "")) then
			-- are you in a party?
			if (IsInGroup() and not IsInRaid()) then
				-- send party message
				local mapName = NS.CommFlare.CF.LocalQueues[index].name
				NS.CommunityFlare_SendMessage(nil, strformat(L["Accepted Queue For Popped %s!"], mapName))
			end
		end
	end
end

-- securely hook reject proposal
function NS.CommunityFlare_RejectProposal()
	-- has brawl queue?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index] and NS.CommFlare.CF.LocalQueues[index].popped and (NS.CommFlare.CF.LocalQueues[index].popped > 0)) then
		-- update brawl status
		NS.CommFlare.CF.LocalQueues[index].status = "rejected"
		NS.CommunityFlare_Update_Brawl_Status()
	end
end

-- process main menu micro button on mouse down
function NS.CommunityFlare_MainMenuMicroButton_OnMouseDown()
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- inside pvp content?
		local isArena = PvPIsArena()
		local isBattleground = PvPIsBattleground()
		if (isArena or isBattleground) then
			-- enabled
			NS.CommFlare.CF.AllowMainMenu = true
		else
			-- disabled
			NS.CommFlare.CF.AllowMainMenu = false
		end
	end
end

-- process game menu on show
function NS.CommunityFlare_GameMenuFrame_OnShow()
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- inside pvp content?
		local isArena = PvPIsArena()
		local isBattleground = PvPIsBattleground()
		if (isArena or isBattleground) then
			-- blocked?
			if (NS.CommFlare.CF.AllowMainMenu ~= true) then
				-- not in combat?
				if (InCombatLockdown() ~= true) then
					-- hide
					HideUIPanel(GameMenuFrame)
				end
			end
		end

		-- disabled
		NS.CommFlare.CF.AllowMainMenu = false
	end
end

-- process game menu on hide
function NS.CommunityFlare_GameMenuFrame_OnHide()
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- disabled
		NS.CommFlare.CF.AllowMainMenu = false
	end
end

-- securely hook honor frame queue queue button hover
function NS.CommunityFlare_HonorFrameQueueButton_OnEnter(self)
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

	-- check for dead / offline players
	NS.CommunityFlare_Process_Party_States(true, true)
end

-- process character micro button clicked
function NS.CommFlare:CharacterMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowCharacterFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[CharacterMicroButton].OnClick(self, ...)
	else
		-- always normal
		CharacterMicroButton:SetNormal()
	end
end

-- process character toggle
function NS.CommFlare:ToggleCharacter(tab, onlyShow)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not shown?
		local isShown = CharacterFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowCharacterFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowCharacterFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleCharacter(tab, onlyShow)
	end
end

-- process spellbook micro button clicked
function NS.CommFlare:SpellbookMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowSpellBookFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[SpellbookMicroButton].OnClick(self, ...)
	else
		-- always normal
		SpellbookMicroButton:SetNormal()
	end
end

-- process spellbook toggle
function NS.CommFlare:ToggleSpellBook(bookType)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not shown?
		local isShown = SpellBookFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowSpellBookFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowSpellBookFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleSpellBook(bookType)
	end
end

-- process talent micro button clicked
function NS.CommFlare:TalentMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowTalentFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[TalentMicroButton].OnClick(self, ...)
	else
		-- always normal
		TalentMicroButton:SetNormal()
	end
end

-- process talent toggle
function NS.CommFlare:ToggleTalentFrame(suggestedTab, inspectUnit)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not loaded yet?
		if (not ClassTalentFrame) then
			-- load talent framework
			ClassTalentFrame_LoadUI()
		end

		-- not shown?
		local isShown = ClassTalentFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowTalentFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowTalentFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleTalentFrame(suggestedTab, inspectUnit)
	end
end

-- process achievement micro button clicked
function NS.CommFlare:AchievementMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowAchievementFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[AchievementMicroButton].OnClick(self, ...)
	else
		-- always normal
		AchievementMicroButton:SetNormal()
	end
end

-- process achievement toggle
function NS.CommFlare:ToggleAchievementFrame(stats)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not loaded yet?
		if (not AchievementFrame) then
			-- load achievement framework
			AchievementFrame_LoadUI()
		end

		-- not shown?
		local isShown = AchievementFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowAchievementFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowAchievementFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleAchievementFrame(stats)
	end
end

-- process guild micro button clicked
function NS.CommFlare:GuildMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowGuildFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[GuildMicroButton].OnClick(self, ...)
	else
		-- always normal
		GuildMicroButton:SetNormal()
	end
end

-- process guild toggle
function NS.CommFlare:ToggleGuildFrame()
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not loaded yet?
		if (not CommunitiesFrame) then
			-- load communities framework
			Communities_LoadUI()
		end

		-- not shown?
		local isShown = CommunitiesFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowGuildFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowGuildFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleGuildFrame()
	end
end

-- process group finder micro button clicked
function NS.CommFlare:LFDMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowGroupFinderFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[LFDMicroButton].OnClick(self, ...)
	else
		-- always normal
		LFDMicroButton:SetNormal()
	end
end

-- process group finder toggle
function NS.CommFlare:PVEFrame_ToggleFrame(sidePanelName, selection)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not shown?
		local isShown = PVEFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowGroupFinderFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowGroupFinderFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.PVEFrame_ToggleFrame(sidePanelName, selection)
	end
end

-- process adventure guide micro button clicked
function NS.CommFlare:EJMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowAdvGuideFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[EJMicroButton].OnClick(self, ...)
	else
		-- always normal
		EJMicroButton:SetNormal()
	end
end

-- process adventure guide toggle
function NS.CommFlare:ToggleEncounterJournal(tabIndex)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not loaded yet?
		if (not EncounterJournal) then
			-- load adventure guide framework
			EncounterJournal_LoadUI()
		end

		-- not shown?
		local isShown = EncounterJournal:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowAdvGuideFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowAdvGuideFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleEncounterJournal(tabIndex)
	end
end

-- process collections micro button clicked
function NS.CommFlare:CollectionsMicroButton_OnClick(self, ...)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- allowed
		NS.CommFlare.CF.AllowCollectionsFrame = true
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks[CollectionsMicroButton].OnClick(self, ...)
	else
		-- always normal
		CollectionsMicroButton:SetNormal()
	end
end

-- process collections toggle
function NS.CommFlare:ToggleCollectionsJournal(tabIndex)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not loaded yet?
		if (not CollectionsJournal) then
			-- load collections framework
			CollectionsJournal_LoadUI()
		end

		-- not shown?
		local isShown = CollectionsJournal:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowCollectionsFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowCollectionsFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleCollectionsJournal(tabIndex)
	end
end

-- process friends toggle
function NS.CommFlare:ToggleFriendsFrame(tab)
	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- not shown?
		local isShown = FriendsFrame:IsShown()
		if (isShown == false) then
			-- not allowed?
			if (NS.CommFlare.CF.AllowFriendsFrame == false) then
				-- inside pvp content?
				local isArena = PvPIsArena()
				local isBattleground = PvPIsBattleground()
				if (isArena or isBattleground) then
					-- finished
					return
				end
			end
		end	

		-- disabled
		NS.CommFlare.CF.AllowFriendsFrame = false
	end

	-- not in combat lockdown?
	if (InCombatLockdown() ~= true) then
		-- call original
		NS.CommFlare.hooks.ToggleFriendsFrame(tab)
	end
end

-- block game menu hooks
function NS.CommunityFlare_Setup_BlockGameMenuHooks()
	-- hooks to block character frame inside pvp content
	NS.CommFlare.CF.AllowCharacterFrame = false
	NS.CommFlare:RawHook("ToggleCharacter", true)
	NS.CommFlare:RawHookScript(CharacterMicroButton, "OnClick", "CharacterMicroButton_OnClick")

	-- hooks to block spellbook frame inside pvp content
	NS.CommFlare.CF.AllowSpellBookFrame = false
	NS.CommFlare:RawHook("ToggleSpellBook", true)
	NS.CommFlare:RawHookScript(SpellbookMicroButton, "OnClick", "SpellbookMicroButton_OnClick")

	-- hooks to block talent frame inside pvp content
	NS.CommFlare.CF.AllowTalentFrame = false
	NS.CommFlare:RawHook("ToggleTalentFrame", true)
	NS.CommFlare:RawHookScript(TalentMicroButton, "OnClick", "TalentMicroButton_OnClick")

	-- hooks to block achievement frame inside pvp content
	NS.CommFlare.CF.AllowAchievementFrame = false
	NS.CommFlare:RawHook("ToggleAchievementFrame", true)
	NS.CommFlare:RawHookScript(AchievementMicroButton, "OnClick", "AchievementMicroButton_OnClick")

	-- hooks to block guild frame inside pvp content
	NS.CommFlare.CF.AllowGuildFrame = false
	NS.CommFlare:RawHook("ToggleGuildFrame", true)
	NS.CommFlare:RawHookScript(GuildMicroButton, "OnClick", "GuildMicroButton_OnClick")

	-- hooks to block group finder frame inside pvp content
	NS.CommFlare.CF.AllowGroupFinderFrame = false
	NS.CommFlare:RawHook("PVEFrame_ToggleFrame", true)
	NS.CommFlare:RawHookScript(LFDMicroButton, "OnClick", "LFDMicroButton_OnClick")

	-- hooks to block adventure guide frame inside pvp content
	NS.CommFlare.CF.AllowAdvGuideFrame = false
	NS.CommFlare:RawHook("ToggleEncounterJournal", true)
	NS.CommFlare:RawHookScript(EJMicroButton, "OnClick", "EJMicroButton_OnClick")

	-- hooks to block collections frame inside pvp content
	NS.CommFlare.CF.AllowCollectionsFrame = false
	NS.CommFlare:RawHook("ToggleCollectionsJournal", true)
	NS.CommFlare:RawHookScript(CollectionsMicroButton, "OnClick", "CollectionsMicroButton_OnClick")

	-- hooks to block friends frame inside pvp content
	NS.CommFlare.CF.AllowFriendsFrame = false
	NS.CommFlare:RawHook("ToggleFriendsFrame", true)

	-- TODO: REDO BELOW WITH RAW HOOKS!
	-- hooks for blocking escape key menu inside a battleground
	NS.CommFlare.CF.AllowMainMenu = false
	MainMenuMicroButton:HookScript("OnMouseDown", NS.CommunityFlare_MainMenuMicroButton_OnMouseDown)
	GameMenuFrame:HookScript("OnShow", NS.CommunityFlare_GameMenuFrame_OnShow)
	GameMenuFrame:HookScript("OnHide", NS.CommunityFlare_GameMenuFrame_OnHide)
end

-- setup hooks
function NS.CommunityFlare_SetupHooks()
	-- hook stuff
	hooksecurefunc("AcceptBattlefieldPort", NS.CommunityFlare_AcceptBattlefieldPort)
	hooksecurefunc("AcceptProposal", NS.CommunityFlare_AcceptProposal)
	hooksecurefunc("RejectProposal", NS.CommunityFlare_RejectProposal)

	-- block game menu hot keys enabled?
	if (NS.charDB.profile.blockGameMenuHotKeys == true) then
		-- enable block game menu hooks
		NS.CommunityFlare_Setup_BlockGameMenuHooks()
	end
end

-- handle chat whisper filtering
function NS.CommunityFlare_Chat_Whisper_Filter(self, event, text, sender, ...)
	-- found internal message?
	if (text:find("!CF@")) then
		-- suppress
		return true
	end

	-- normal
	return false
end

-- process addon loaded
function NS.CommFlare:ADDON_LOADED(msg, ...)
	local addOnName = ...

	-- Blizzard_PVPUI?
	if (addOnName == "Blizzard_PVPUI") then
		-- enforce pvp roles
		NS.CommunityFlare_Enforce_PVP_Roles()

		-- hook queue button mouse over
		HonorFrameQueueButton:HookScript("OnEnter", NS.CommunityFlare_HonorFrameQueueButton_OnEnter)
	end
end

-- process Battle.NET chat message addon
function NS.CommFlare:BN_CHAT_MSG_ADDON(msg, ...)
	local prefix, text, channel, senderID = ...

	-- community flare?
	if (prefix == "CommFlare") then
		-- process battle net command
		NS.CommunityFlare_Process_BattleNET_Commands(senderID, text)
	end
end

-- process chat message addon
function NS.CommFlare:CHAT_MSG_ADDON(msg, ...)
	local prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID = ...

	-- does not need addon data
	if (NS.CommFlare.CF.NeedAddonData ~= true) then
		-- finished
		return
	end

	-- capping?
	if (prefix == "Capping") then
		-- isle of conquest?
		if (NS.CommFlare.CF.MapID == 169) then
			-- skip these messages
			if ((text == "gr") or (text == "rb") or (text == "rbh")) then
				-- finished
				return
			end

			-- report to anyone?
			if (NS.CommFlare.CF.StatusCheck and next(NS.CommFlare.CF.StatusCheck)) then
				-- sanity check?
				local h1, h1hp, h2, h2hp, h3, h3hp, a1, a1hp, a2, a2hp, a3, a3hp = strsplit(":", text)
				local hGate1, hGate2, hGate3, aGate1, aGate2, aGate3 = tonumber(h1hp), tonumber(h2hp), tonumber(h3hp), tonumber(a1hp), tonumber(a2hp), tonumber(a3hp)
				if (hGate1 and hGate2 and hGate3 and aGate1 and aGate2 and aGate3) then
					-- find lowest gates
					local allyLowest = math.min(aGate1, aGate2, aGate3) / 2400000 * 100
					local hordeLowest = math.min(hGate1, hGate2, hGate3) / 2400000 * 100

					-- process all
					local timer = 0.0
					local text = strformat(L["%s: Alliance Gate = %.1f, Horde Gate = %.1f"], L["Isle of Conquest"], allyLowest, hordeLowest)
					for k,v in pairs(NS.CommFlare.CF.StatusCheck) do
						-- send replies staggered
						TimerAfter(timer, function()
							-- send message
							NS.CommunityFlare_SendMessage(k, text)
						end)

						-- next
						timer = timer + 0.2
					end
				end

				-- finished
				NS.CommFlare.CF.NeedAddonData = false
			end
		end
	end
end

-- process chat battle net whisper
function NS.CommFlare:CHAT_MSG_BN_WHISPER(msg, ...)
	local text, sender, _, _, _, _, _, _, _, _, _, _, bnSenderID = ...

	-- invalid sender id?
	if (not bnSenderID) then
		-- find presense id from sender name
		bnSenderID = GetAutoCompletePresenceID(sender)
		if (not bnSenderID) then
			-- failed
			return
		end
	end

	-- version check?
	local lower = strlower(text)
	if (lower == "!cf") then
		-- process version check
		NS.CommunityFlare_Process_Version_Check(bnSenderID)
	-- pass leadership?
	elseif (lower == "!pl") then
		-- process pass leadership
		NS.CommunityFlare_Process_Pass_Leadership(bnSenderID)
	-- status check?
	elseif (lower == "!status") then
		-- process status check
		NS.CommunityFlare_Process_Status_Check(bnSenderID)
	-- asking for invite?
	elseif ((lower == "inv") or (lower == "invite")) then
		-- process auto invite
		NS.CommunityFlare_Process_Auto_Invite(bnSenderID)
	else
		-- split words
		local args = {strsplit(" ", text)}
		local command = strlower(args[1])
		if (command == "!debug") then
			-- process debug command
			NS.CommunityFlare_Process_Debug_Command(bnSenderID, args)
		end
	end
end

-- handle chat party message events
function NS.CommunityFlare_Event_Chat_Message_Party(...)
	local text, sender = ...

	-- skip messages from yourself
	text = strlower(text)
	if (NS.CommunityFlare_GetPlayerName("full") ~= sender) then
		if (text == "!cf") then
			-- send community flare version number
			NS.CommunityFlare_SendMessage(nil, strformat("%s: %s (%s)", NS.CommunityFlare_Title, NS.CommunityFlare_Version, NS.CommunityFlare_Build))
		end
	end
end

-- process chat party message
function NS.CommFlare:CHAT_MSG_PARTY(msg, ...)
	-- process chat message party event
	NS.CommunityFlare_Event_Chat_Message_Party(...)
end

-- process chat party leader message
function NS.CommFlare:CHAT_MSG_PARTY_LEADER(msg, ...)
	-- process chat message party event
	NS.CommunityFlare_Event_Chat_Message_Party(...)
end

-- process system message
function NS.CommFlare:CHAT_MSG_SYSTEM(msg, ...)
	local text, sender = ...

	-- joined the queue for?
	local lower = strlower(text)
	if (lower:find(L["joined the queue for"])) then
		-- update local group
		NS.CommunityFlare_Update_Group("local")
	-- notify system has been enabled?
	elseif (text == PVP_REPORT_AFK_SYSTEM_ENABLED) then
		-- restrict pings?
		if (NS.charDB.profile.restrictPings == true) then
			-- does player have raid leadership or assistant?
			NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
			if (NS.CommFlare.CF.PlayerRank > 0) then
				-- enable restrict pings
				PartyInfoSetRestrictPings(true)
			end
		end

		-- display battleground setup
		NS.CommFlare.CF.MatchStatus = 2
		NS.CommFlare.CF.MatchEndTime = 0
		NS.CommFlare.CF.MatchEndDate = ""
		NS.CommFlare.CF.MatchStartDate = date()
		NS.CommFlare.CF.MatchStartTime = time()
		NS.CommFlare.CF.MatchStartLogged = false
		NS.CommunityFlare_Update_Battleground_Stuff(true)
		NS.CommunityFlare_Update_Member_Statistics("started")
		NS.CommunityFlare_Match_Started_Log_Roster()
	end
end

-- process chat whisper message
function NS.CommFlare:CHAT_MSG_WHISPER(msg, ...)
	local text, sender = ...

	-- version check?
	local lower = strlower(text)
	if (lower == "!cf") then
		-- process version check
		NS.CommunityFlare_Process_Version_Check(sender)
	-- pass leadership?
	elseif (lower == "!pl") then
		-- process pass leadership
		NS.CommunityFlare_Process_Pass_Leadership(sender)
	-- status check?
	elseif (lower == "!status") then
		-- process status check
		NS.CommunityFlare_Process_Status_Check(sender)
	-- asking for invite?
	elseif ((lower == "inv") or (lower == "invite")) then
		-- process auto invite
		NS.CommunityFlare_Process_Auto_Invite(sender)
	else
		-- split words
		local args = {strsplit(" ", text)}
		local command = strlower(args[1])
		if (command == "!debug") then
			-- process debug command
			NS.CommunityFlare_Process_Debug_Command(sender, args)
		end
	end
end

-- process chat monster yell message
function NS.CommFlare:CHAT_MSG_MONSTER_YELL(msg, ...)
	local text, sender = ...

	-- Ashran, jeron killed?
	local lower = strlower(text)
	if (lower:find(L["jeron emberfall has been slain"])) then
		-- jeron emberfall killed
		NS.CommFlare.CF.ASH.Jeron = L["Killed"]
	-- Ashran, rylai killed?
	elseif (lower:find(L["rylai crestfall has been slain"])) then
		-- rylai crestfall killed
		NS.CommFlare.CF.ASH.Rylai = L["Killed"]
	end

	-- use player guid
	local faction = nil
	local guid = UnitGUID("player")
	if (guid) then
		-- get player score info by guid
		local info = PvPGetScoreInfoByPlayerGuid(guid)
		if (info and info.faction) then
			-- alliance faction?
			if (info.faction == 1) then
				-- set alliance
				faction = L["Alliance"]
			else
				-- set horde
				faction = L["Horde"]
			end
		end
	end

	-- faction not found?
	if (not faction) then
		-- use player faction
		faction = UnitFactionGroup("player")
	end

	-- alliance faction?
	if (faction == L["Alliance"]) then
		-- captain balinda stonehearth?
		if (sender == L["Captain Balinda Stonehearth"]) then
			-- engaged?
			if (lower:find(L["begone, uncouth scum!"])) then
				-- do you have lead?
				local player = NS.CommunityFlare_GetPlayerName("full")
				NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
				if (NS.CommFlare.CF.PlayerRank == 2) then
					-- issue global raid warning
					NS.CommunityFlare_SendMessage("RAID_WARNING", strformat(L["%s is under attack!"], L["Captain Balinda Stonehearth"]))
				else
					-- issue local raid warning (with raid warning audio sound)
					RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", strformat(L["%s is under attack!"], L["Captain Balinda Stonehearth"]))
				end
			end
		end
	-- horde faction?
	elseif (faction == L["Horde"]) then
		-- captain galvangar?
		if (sender == L["Captain Galvangar"]) then
			-- engaged?
			if (lower:find(L["your kind has no place in alterac valley"])) then
				-- do you have lead?
				local player = NS.CommunityFlare_GetPlayerName("full")
				NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
				if (NS.CommFlare.CF.PlayerRank == 2) then
					-- issue global raid warning
					NS.CommunityFlare_SendMessage("RAID_WARNING", strformat(L["%s is under attack!"], L["Captain Galvangar"]))
				else
					-- issue local raid warning (with raid warning audio sound)
					RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", strformat(L["%s is under attack!"], L["Captain Galvangar"]))
				end
			end
		end
	end
end

-- process club member added
function NS.CommFlare:CLUB_MEMBER_ADDED(msg, ...)
	local clubId, memberId = ...

	-- find player in database
	local player = NS.CommunityFlare_GetPlayerName("full")
	local member = NS.CommunityFlare_GetCommunityMember(player)
	if (member and member.clubs and member.clubs[clubId]) then
		-- add club member
		NS.CommunityFlare_ClubMemberAdded(clubId, memberId)
	-- main community?
	elseif (NS.charDB.profile.communityMain == clubId) then
		-- add club member
		NS.CommunityFlare_ClubMemberAdded(clubId, memberId)
	-- has community list?
	elseif (NS.charDB.profile.communityList and (next(NS.charDB.profile.communityList) ~= nil)) then
		-- process all lists
		local count = 0
		for k,_ in pairs(NS.charDB.profile.communityList) do
			-- matches?
			if (clubId == k) then
				-- increase
				count = count + 1
			end
		end

		-- found?
		if (count > 0) then
			-- add club member
			NS.CommunityFlare_ClubMemberAdded(clubId, memberId)
		end
	end
end

-- process club member presense updated
function NS.CommFlare:CLUB_MEMBER_PRESENCE_UPDATED(msg, ...)
	local clubId, memberId, presence = ...

	-- always update, except on mobile
	if ((presence > 0) and (presense ~= Enum.ClubMemberPresence.OnlineMobile)) then
		-- only communities
		local club = ClubGetClubInfo(clubId)
		if (club.clubType == Enum.ClubType.Character) then
			-- get member info
			local mi = ClubGetMemberInfo(clubId, memberId)
			if (mi and mi.name and (mi.name ~= "")) then
				-- build proper name
				local player = mi.name
				if (not strmatch(player, "-")) then
					-- add realm name
					player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
				end

				-- get community member
				local member = NS.CommunityFlare_GetCommunityMember(player)
				if (member ~= nil) then
					-- update last seen
					NS.CommunityFlare_History_Update_Last_Seen(member.name)
				end
			end
		end
	end
end

-- process club member removed
function NS.CommFlare:CLUB_MEMBER_REMOVED(msg, ...)
	local clubId, memberId = ...

	-- main community?
	if (NS.charDB.profile.communityMain == clubId) then
		-- remove club member
		NS.CommunityFlare_ClubMemberRemoved(clubId, memberId)
	end
end

-- process club member role updated
function NS.CommFlare:CLUB_MEMBER_ROLE_UPDATED(msg, ...)
	local clubId, memberId, roleId = ...

	-- update club member
	NS.CommunityFlare_ClubMemberUpdated(clubId, memberId)
end

-- process club member updated
function NS.CommFlare:CLUB_MEMBER_UPDATED(msg, ...)
	local clubId, memberId = ...

	-- update club member
	NS.CommunityFlare_ClubMemberUpdated(clubId, memberId)
end

-- process group formed
function NS.CommFlare:GROUP_FORMED(msg, ...)
	local category, partyGUID = ...

	-- save partyGUID
	NS.CommFlare.CF.PartyGUID = partyGUID
end

-- process group invite confirmation
function NS.CommFlare:GROUP_INVITE_CONFIRMATION(msg)
	-- check for auto invites?
	local autoInvite = false
	if (not IsInGroup()) then
		-- yes
		autoInvite = true
	elseif (not IsInRaid() and IsInGroup()) then
		-- yes
		autoInvite = true
	end

	-- mercenary queued?
	if (NS.CommunityFlare_Battleground_IsMercenaryQueued() == true) then
		-- get next pending invite
		local invite = GetNextPendingInviteConfirmation()
		if (invite) then
			-- cancel invite
			RespondToInviteConfirmation(invite, false)

			-- hide popup
			if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
				-- hide
				StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
			end
		end
	end

	-- check for auto invites?
	if (autoInvite == true) then
		-- read the text
		local text = StaticPopup1Text["text_arg1"]
		if (text and (text ~= "")) then
			-- you will be removed from?
			text = strlower(text)
			if (strfind(text, L["you will be removed from"])) then
				local invite = GetNextPendingInviteConfirmation()
				if (invite) then
					-- cancel invite
					RespondToInviteConfirmation(invite, false)

					-- hide popup
					if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
						-- hide
						StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
					end
				end
			-- has requested to join your group?
			elseif (strfind(text, L["has requested to join your group"])) then
				-- get next pending invite
				local invite = GetNextPendingInviteConfirmation()
				if (invite) then
					-- get invite confirmation info
					local confirmationType, name, guid, rolesInvalid, willConvertToRaid, level, spec, itemLevel = GetInviteConfirmationInfo(invite)
					local referredByGuid, referredByName, relationType, isQuickJoin, clubId = PartyInfoGetInviteReferralInfo(invite)
					local playerName, color, selfRelationship = SocialQueueUtil_GetRelationshipInfo(guid, name, clubId)

					-- will invite cause conversion to raid?
					if (willConvertToRaid or (GetNumGroupMembers() > 4) or PartyInfoIsPartyFull()) then
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
								NS.CommunityFlare_SendMessage(accountInfo.bnetAccountID, L["Sorry, group is currently full."])
							end
						else
							-- send message
							NS.CommunityFlare_SendMessage(name, L["Sorry, group is currently full."])
						end
					else
						-- has proper name?
						local player = ""
						if (name and (name ~= "")) then
							-- force name-realm format
							player = name
							if (not strmatch(player, "-")) then
								-- add realm name
								player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
							end
						end

						-- battle net friend?
						NS.CommFlare.CF.AutoInvite = false
						if (selfRelationship == "bnfriend") then
							-- battle net auto invite enabled?
							if (NS.charDB.profile.bnetAutoInvite == true) then
								-- auto invite enabled
								NS.CommFlare.CF.AutoInvite = true
							end
						end

						-- community auto invite enabled?
						if ((NS.CommFlare.CF.AutoInvite == false) and (NS.charDB.profile.communityAutoInvite == true)) then
							-- is sender a community member?
							NS.CommFlare.CF.AutoInvite = NS.CommunityFlare_IsCommunityMember(player)
						end

						-- auto invite?
						if (NS.CommFlare.CF.AutoInvite == true) then
							-- accept invite
							RespondToInviteConfirmation(invite, true)

							-- hide popup
							if (StaticPopup_FindVisible("GROUP_INVITE_CONFIRMATION")) then
								-- hide
								StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
							end
						end
					end
				end
			end
		end
	end
end

-- process group joined
function NS.CommFlare:GROUP_JOINED(msg, ...)
	local category, partyGUID = ...

	-- save partyGUID
	NS.CommFlare.CF.PartyGUID = partyGUID

	-- not in raid?
	if (not IsInRaid()) then
		-- queue exists?
		if (NS.CommFlare.CF.SocialQueues[partyGUID] and NS.CommFlare.CF.SocialQueues[partyGUID].guid and NS.CommFlare.CF.SocialQueues[partyGUID].created and (NS.CommFlare.CF.SocialQueues[partyGUID].created > 0)) then
			-- copy party queue to local
			NS.CommFlare.CF.SocialQueues["local"] = NS.CommFlare.CF.SocialQueues[partyGUID]
			NS.CommFlare.CF.SocialQueues[partyGUID] = nil

			-- update local group
			NS.CommunityFlare_Update_Group("local")
		end
	end
end

-- process group left
function NS.CommFlare:GROUP_LEFT(msg, ...)
	local category, partyGUID = ...

	-- disable community party leader
	NS.charDB.profile.communityPartyLeader = false

	-- delete partyGUID
	NS.CommFlare.CF.PartyGUID = nil

	-- not in raid?
	if (not IsInRaid()) then
		-- queue exists?
		if (NS.CommFlare.CF.SocialQueues["local"] and NS.CommFlare.CF.SocialQueues["local"].guid and NS.CommFlare.CF.SocialQueues["local"].created and (NS.CommFlare.CF.SocialQueues["local"].created > 0)) then
			-- copy local to party queues
			NS.CommFlare.CF.SocialQueues[partyGUID] = NS.CommFlare.CF.SocialQueues["local"]
			NS.CommunityFlare_Initialize_Group("local")

			-- update party group
			NS.CommunityFlare_Update_Group(partyGUID)
		end
	end
end

-- process group roster update
function NS.CommFlare:GROUP_ROSTER_UPDATE(msg)
	-- skip for arena
	local isArena = PvPIsArena()
	if (isArena == true) then
		-- finished
		return
	end

	-- is battleground?
	local isBattleground = PvPIsBattleground()
	if (isBattleground == true) then
		-- prematch gate open
		if (NS.CommFlare.CF.MatchStatus == 1) then
			-- do you have lead?
			local player = NS.CommunityFlare_GetPlayerName("full")
			NS.CommFlare.CF.PlayerRank = NS.CommunityFlare_GetRaidRank(UnitName("player"))
			if (NS.CommFlare.CF.PlayerRank == 2) then
				-- process all community leaders
				for _,v in ipairs(NS.CommFlare.CF.CommunityLeaders) do
					-- already leader?
					if (player == v) then
						-- success
						break
					end

					-- promote this leader
					if (NS.CommunityFlare_PromoteToRaidLeader(v) == true) then
						-- success
						break
					end
				end
			end
		end
	-- not battleground
	else
		-- are you in a party?
		if (IsInGroup() and not IsInRaid()) then
			-- are you group leader?
			if (NS.CommunityFlare_IsGroupLeader() == true) then
				-- community member?
				local message = "GROUP_ROSTER_UPDATE"
				if (NS.charDB.profile.communityMain > 1) then
					-- append YES
					message = message .. ":YES"
				else
					-- append NO
					message = message .. ":NO"
				end

				-- send party that leader has community flare
				NS.CommFlare:SendCommMessage(ADDON_NAME, message, "PARTY")

				-- check current players in home party
				local count = 1
				local players = GetHomePartyInfo()
				if (players ~= nil) then
					-- has group size changed?
					local text = NS.CommunityFlare_GetGroupCount()
					count = #players + count
					if ((NS.CommFlare.CF.PreviousCount > 0) and (NS.CommFlare.CF.PreviousCount < 5) and (count == 5)) then
						-- community reporter enabled?
						if (NS.charDB.profile.communityReporter == true) then
							-- send to community?
							text = strformat("%s %s!", text, L["Full Now"])
							NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
						end
					end
				end

				-- save previous count
				NS.CommFlare.CF.PreviousCount = count
			else
				-- clear previous count
				NS.CommFlare.CF.PreviousCount = 0
			end
		else
			-- clear previous count
			NS.CommFlare.CF.PreviousCount = 0
		end

		-- not in raid?
		if (not IsInRaid()) then
			-- update local group
			NS.CommunityFlare_Update_Group("local")
		end
	end
end

-- process initial clubs loaded
function NS.CommFlare:INITIAL_CLUBS_LOADED(msg)
	-- initial login?
	if (NS.CommFlare.CF.InitialLogin == false) then
		-- should readd community channels?
		if (NS.charDB.profile.alwaysReaddChannels == true) then
			-- readd community channels
			TimerAfter(10, NS.CommunityFlare_ReaddChannelsInitialLoad)
		end

		-- refresh club members
		TimerAfter(10, NS.CommunityFlare_Refresh_Club_Members)

		-- initialized
		NS.CommFlare.CF.InitialLogin = true
	end
end

-- process lfg proposal done
function NS.CommFlare:LFG_PROPOSAL_DONE(msg)
	-- brawl queue exists?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index]) then
		-- not rejected?
		if (NS.CommFlare.CF.LocalQueues[index].status ~= "rejected") then
			-- entered queue pop
			NS.CommFlare.CF.LocalQueues[index].status = "entered"
		end

		-- update brawl status
		NS.CommunityFlare_Update_Brawl_Status()
	end
end

-- process lfg proposal failed
function NS.CommFlare:LFG_PROPOSAL_FAILED(msg)
	-- brawl queue exists?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index]) then
		-- not rejected?
		if (NS.CommFlare.CF.LocalQueues[index].status ~= "rejected") then
			-- missed queue pop
			NS.CommFlare.CF.LocalQueues[index].status = "failed"
		end

		-- update brawl status
		NS.CommunityFlare_Update_Brawl_Status()
	end
end

-- process lfg proposal show
function NS.CommFlare:LFG_PROPOSAL_SHOW(msg)
	-- brawl queue exists?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index]) then
		-- update brawl status
		NS.CommFlare.CF.LocalQueues[index].status = "popped"
		NS.CommunityFlare_Update_Brawl_Status()
	end
end

-- process lfg proposal succeeded
function NS.CommFlare:LFG_PROPOSAL_SUCCEEDED(msg)
	-- brawl queue exists?
	local index = "Brawl"
	if (NS.CommFlare.CF.LocalQueues[index]) then
		-- update brawl status
		NS.CommFlare.CF.LocalQueues[index].status = "entered"
		NS.CommunityFlare_Update_Brawl_Status()
	end
end

-- process lfg role check role chosen
function NS.CommFlare:LFG_ROLE_CHECK_ROLE_CHOSEN(msg, ...)
	local name, isTank, isHealer, isDamage = ...
	local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

	-- build proper name
	local player = name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- are you group leader?
	if (NS.CommunityFlare_IsGroupLeader() == true) then
		-- is this your role?
		if (name == UnitName("player")) then
			-- reset counts
			NS.CommFlare.CF.LocalData.NumDPS = 0
			NS.CommFlare.CF.LocalData.NumHealers = 0
			NS.CommFlare.CF.LocalData.NumTanks = 0

			-- initialize queue session
			NS.CommunityFlare_Initialize_Queue_Session()
		end
	end

	-- is battleground queue?
	if (bgQueue) then
		-- is tracked pvp?
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- first role chosen?
			if (not NS.CommFlare.CF.RoleChosen[player]) then
				-- is damage?
				if (isDamage == true) then
					-- increase
					NS.CommFlare.CF.LocalData.NumDPS = NS.CommFlare.CF.LocalData.NumDPS + 1
				end

				-- is healer?
				if (isHealer == true) then
					-- increase
					NS.CommFlare.CF.LocalData.NumHealers = NS.CommFlare.CF.LocalData.NumHealers + 1
				end

				-- is tank?
				if (isTank == true) then
					-- increase
					NS.CommFlare.CF.LocalData.NumTanks = NS.CommFlare.CF.LocalData.NumTanks + 1
				end
			end

			-- role chosen
			NS.CommFlare.CF.RoleChosen[player] = true
		end
	end
end

-- process lfg role check show
function NS.CommFlare:LFG_ROLE_CHECK_SHOW(msg, ...)
	local isRequeue = ...
	local inProgress, slots, members, category, lfgID, bgQueue = GetLFGRoleUpdate()

	-- is battleground queue?
	if (bgQueue) then
		-- is tracked pvp?
		local mapName = GetLFGRoleUpdateBattlegroundInfo()
		local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
		if (isTracked == true) then
			-- capable of auto queuing?
			NS.CommFlare.CF.AutoQueueable = false
			if (not IsInRaid()) then
				NS.CommFlare.CF.AutoQueueable = true
			else
				-- larger than rated battleground count?
				if (GetNumGroupMembers() > 10) then
					NS.CommFlare.CF.AutoQueueable = true
				end
			end

			-- auto queueable?
			NS.CommFlare.CF.AutoQueue = false
			if (NS.CommFlare.CF.AutoQueueable == true) then
				-- party leader is community?
				if (NS.charDB.profile.communityPartyLeader == true) then
					-- auto queue enabled
					NS.CommFlare.CF.AutoQueue = true
				end

				-- always auto queue?
				if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.alwaysAutoQueue == true)) then
					-- auto queue enabled
					NS.CommFlare.CF.AutoQueue = true
				end

				-- battle net auto queue enabled?
				if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.bnetAutoQueue == true)) then
					local guid = NS.CommunityFlare_GetPartyLeaderGUID()
					local info = BattleNetGetAccountInfoByGUID(guid)
					if (info and (info.isFriend == true)) then
						-- auto invite enabled
						NS.CommFlare.CF.AutoQueue = true
					end
				end

				-- community auto queue?
				if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.communityAutoQueue == true)) then
					-- is party leader a community member?
					local leader = NS.CommunityFlare_GetPartyLeader()
					NS.CommFlare.CF.AutoQueue = NS.CommunityFlare_IsCommunityMember(leader)
				end
			end

			-- auto queue enabled?
			if (NS.CommFlare.CF.AutoQueue == true) then
				-- check for deserter
				NS.CommunityFlare_CheckForAura("player", "HARMFUL", L["Deserter"])
				if (NS.CommFlare.CF.HasAura == false) then
					-- is shown?
					if (LFDRoleCheckPopupAcceptButton:IsShown()) then
						-- click accept button
						LFDRoleCheckPopupAcceptButton:Click()
					end
				else
					-- have deserter / leave party
					NS.CommunityFlare_SendMessage(nil, strformat("%s! %s!", L["Sorry, I currently have deserter"], L["Leaving party to avoid interrupting the queue"]))
					PartyInfoLeaveParty()
				end
			end
		end
	end
end

-- process lfg update
function NS.CommFlare:LFG_UPDATE(msg)
	-- update brawl status
	NS.CommunityFlare_Update_Brawl_Status()
end

-- process notify pvp afk result
function NS.CommFlare:NOTIFY_PVP_AFK_RESULT(msg, ...)
	local offender, numBlackMarksOnOffender, numPlayersIHaveReported = ...

	-- hmmm, what is this?
	print(strformat("NOTIFY_PVP_AFK_RESULT: %s = %s, %s", offender, numBlackMarksOnOffender, numPlayersIHaveReported))
end

-- process party invite request
function NS.CommFlare:PARTY_INVITE_REQUEST(msg, ...)
	local sender, _, _, _, _, _, guid, questSessionActive = ...

	-- enforce pvp roles
	NS.CommunityFlare_Enforce_PVP_Roles()

	-- verify player does not have deserter debuff
	NS.CommunityFlare_CheckForAura("player", "HARMFUL", L["Deserter"])
	if (NS.CommFlare.CF.HasAura == false) then
		-- battle net auto invite enabled?
		NS.CommFlare.CF.AutoInvite = false
		if (NS.charDB.profile.bnetAutoInvite == true) then
			local info = BattleNetGetAccountInfoByGUID(guid)
			if (info and (info.isFriend == true)) then
				-- auto invite enabled
				NS.CommFlare.CF.AutoInvite = true
			end
		end

		-- community auto invite enabled?
		if ((NS.CommFlare.CF.AutoInvite == false) and (NS.charDB.profile.communityAutoInvite == true)) then
			-- is sender a community member?
			NS.CommFlare.CF.AutoInvite = NS.CommunityFlare_IsCommunityMember(sender)
		end

		-- should auto invite?
		if (NS.CommFlare.CF.AutoInvite == true) then
			-- lfg invite popup shown?
			if (LFGInvitePopup:IsShown()) then
				-- force tank?
				if (NS.charDB.profile.forceTank == true) then
					-- click tank button
					LFGInvitePopupRoleButtonTank:Click()
				end

				-- force healer?
				if (NS.charDB.profile.forceHealer == true) then
					-- click healer button
					LFGInvitePopupRoleButtonHealer:Click()
				end

				-- force healer?
				if (NS.charDB.profile.forceDPS == true) then
					-- click dps button
					LFGInvitePopupRoleButtonDPS:Click()
				end

				-- click accept button
				LFGInvitePopupAcceptButton:Click()
			-- static popup shown?
			elseif (StaticPopup_FindVisible("PARTY_INVITE")) then
				-- accept party
				AcceptGroup()

				-- hide
				StaticPopup_Hide("PARTY_INVITE")
			end
		end
	else
		-- send whisper back that you have deserter
		NS.CommunityFlare_SendMessage(sender, strformat("%s!", L["Sorry, I currently have deserter"]))
		if (LFGInvitePopup:IsShown()) then
			-- click decline button
			LFGInvitePopupDeclineButton:Click()
		end
	end
end

-- process party leader changed
function NS.CommFlare:PARTY_LEADER_CHANGED(msg)
	-- update leader GUID
	NS.CommFlare.CF.LeaderGUID = NS.CommunityFlare_GetPartyLeaderGUID()

	-- notify enabled?
	if (NS.charDB.profile.partyLeaderNotify > 1) then
		-- are you in a party?
		if (IsInGroup() and not IsInRaid()) then
			-- has more than 1 member?
			if (GetNumSubgroupMembers() > 0) then
				-- are you group leader?
				if (NS.CommunityFlare_IsGroupLeader() == true) then
					-- you are the new party leader
					RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", L["YOU ARE CURRENTLY THE NEW GROUP LEADER"])
				end
			end
		end
	end

	-- in a group?
	if (IsInGroup()) then
		-- not in a raid?
		if (not IsInRaid()) then
			-- update local group
			NS.CommunityFlare_Update_Group("local")
		end
	end
end

-- process player entering world
function NS.CommFlare:PLAYER_ENTERING_WORLD(msg, ...)
	local isInitialLogin, isReloadingUi = ...

	-- has old settings?
	if (NS.globalDB.profile) then
		-- process all values
		for k,v in pairs(NS.globalDB.profile) do
			-- save per character
			NS.charDB.profile[k] = NS.globalDB.profile[k]
			NS.globalDB.profile[k] = nil
		end
	end

	-- setup stuff
	NS.CommFlare.CF.PlayerServerName = strgsub(GetRealmName(), "%s+", "")

	-- initial login or reloading?
	if ((isInitialLogin == true) or (isReloadingUi == true)) then
		-- display version
		local version, subversion = strsplit("-", NS.CommunityFlare_Version)
		local major, minor = strsplit(".", version)
		print(strformat("%s: %s", NS.CommunityFlare_Title, NS.CommunityFlare_Version))

		-- remove unused stuff
		NS.charDB.profile.communities = nil
		NS.charDB.profile.matchLogList = nil
		NS.charDB.profile.communityMainName = nil

		-- add chat whisper filtering
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", NS.CommunityFlare_Chat_Whisper_Filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", NS.CommunityFlare_Chat_Whisper_Filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", NS.CommunityFlare_Chat_Whisper_Filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", NS.CommunityFlare_Chat_Whisper_Filter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", NS.CommunityFlare_Chat_Whisper_Filter)

		-- has main community?
		if (NS.charDB.profile.communityMain > 1) then
			-- force enabled
			NS.charDB.profile.communityLeadersList[NS.charDB.profile.communityMain] = true
		end

		-- fix setting
		if (NS.charDB.profile.communityReportID == 0) then
			-- set default report ID
			NS.charDB.profile.communityReportID = NS.charDB.profile.communityMain
		end

		-- process queue stuff
		NS.CommunityFlare_SetupHooks()

		-- enforce pvp roles
		NS.CommunityFlare_Enforce_PVP_Roles()

		-- initialize login?
		if (isInitialLogin == true) then
			-- not reloaded
			NS.CommFlare.CF.Reloaded = false

			-- disable community party leader
			NS.charDB.profile.communityPartyLeader = false
		-- reloading?
		elseif (isReloadingUi == true) then
			-- reloaded
			NS.CommFlare.CF.Reloaded = true

			-- update local group
			NS.CommunityFlare_Update_Group("local")

			-- refresh club members
			TimerAfter(10, NS.CommunityFlare_Refresh_Club_Members)

			-- inside battleground?
			NS.CommFlare.CF.MatchStatus = 0
			if (PvPIsBattleground() == true) then
				-- match state is active?
				if (PvPGetActiveMatchState() == Enum.PvPMatchState.Active) then
					-- match is active state?
					NS.CommFlare.CF.MatchStatus = 1
					if (PvPGetActiveMatchDuration() > 0) then
						-- match started
						NS.CommFlare.CF.MatchStatus = 2
					end
				end
			end
		end
	end

	-- sanity checks
	NS.CommunityFlare_Sanity_Checks()
end

-- process player login
function NS.CommFlare:PLAYER_LOGIN(msg)
	-- verify default community setup
	NS.CommunityFlare_VerifyDefaultCommunitySetup()

	-- load previous session
	NS.CommunityFlare_LoadSession()
end

-- process player logout
function NS.CommFlare:PLAYER_LOGOUT(msg)
	-- enforce pvp roles
	NS.CommunityFlare_Enforce_PVP_Roles()

	-- save session variables
	NS.CommunityFlare_SaveSession()
end

-- process pvp match active
function NS.CommFlare:PVP_MATCH_ACTIVE(msg)
	-- initialize
	NS.CommunityFlare_Initialize_Battleground_Status()

	-- ASH exists?
	if (not NS.CommFlare.CF.ASH) then
		-- create base
		NS.CommFlare.CF.ASH = {}
	end

	-- always reset ashran mages
	NS.CommFlare.CF.ASH.Jeron = L["Up"]
	NS.CommFlare.CF.ASH.Rylai = L["Up"]

	-- active status
	NS.CommFlare.CF.MatchStatus = 1

	-- process club members
	NS.CommunityFlare_Process_Club_Members()
end

-- process pvp match complete
function NS.CommFlare:PVP_MATCH_COMPLETE(msg, ...)
	local winner, duration = ...

	-- enabled vehicle turn speed?
	if (NS.charDB.profile.adjustVehicleTurnSpeed > 0) then
		-- reset default speed
		NS.CommFlare.CF.TurnSpeed = GetCVarDefault("TurnSpeed")
		SetCVar("TurnSpeed", NS.CommFlare.CF.TurnSpeed)
	end

	-- match finished
	NS.CommFlare.CF.LeftTime = 0
	NS.CommFlare.CF.EnteredTime = 0
	NS.CommFlare.CF.MatchStatus = 3
	NS.CommFlare.CF.MatchEndDate = date()
	NS.CommFlare.CF.MatchEndTime = time()
	NS.CommFlare.CF.Winner = GetBattlefieldWinner()
	NS.CommFlare.CF.PlayerFaction = UnitFactionGroup("player")
	NS.CommFlare.CF.PlayerInfo = PvPGetScoreInfoByPlayerGuid(UnitGUID("player"))

	-- update battleground status
	local status = NS.CommunityFlare_Update_Battleground_Status()
	if (status == true) then
		-- epic battleground found
		NS.CommunityFlare_Update_Battleground_Stuff(true)
		NS.CommunityFlare_Update_Member_Statistics("completed")
		NS.CommunityFlare_Match_Started_Log_Roster()
	end


	-- get MapID
	NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
	if (NS.CommFlare.CF.MapID) then
		-- get map info
		NS.CommFlare.CF.MapInfo = MapGetMapInfo(NS.CommFlare.CF.MapID)
		if (NS.CommFlare.CF.MapInfo and NS.CommFlare.CF.MapInfo.name) then
			-- tracked pvp?
			local mapName = NS.CommFlare.CF.MapInfo.name
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
			if (isTracked == true) then
				-- won the match?
				if (NS.CommFlare.CF.PlayerInfo.faction == NS.CommFlare.CF.Winner) then
					-- victory
					status = "Victory"
				else
					-- victory
					status = "Loss"
				end

				-- has leader GUID?
				local leaderGUID = NS.CommFlare.CF.LeaderGUID
				if (not leaderGUID) then
					-- use player
					leaderGUID = UnitGUID("player")
				end

				-- push data
				local timestamp = time()
				local partyGUID = NS.CommunityFlare_GetPartyGUID()
				local guids = strformat("%s,%s", leaderGUID, partyGUID)
				NS.CommunityFlare_BNPushData(strformat("!CF@%s@%s@Queue@Finished@%s,%s@%d@%d@%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build, mapName, status, timestamp, NS.CommFlare.CF.CommCount, guids))
			end
		end
	end

	-- report to anyone?
	if (NS.CommFlare.CF.StatusCheck and next(NS.CommFlare.CF.StatusCheck)) then
		-- process all
		local timer = 0.0
		for k,v in pairs(NS.CommFlare.CF.StatusCheck) do
			-- send replies staggered
			TimerAfter(timer, function()
				-- won the match?
				if (NS.CommFlare.CF.PlayerInfo.faction == NS.CommFlare.CF.Winner) then
					-- victory
					text = strformat("%s %s!", L["Epic battleground has completed with a"], L["victory"])
				else
					-- loss
					text = strformat("%s %s!", L["Epic battleground has completed with a"], L["loss"])
				end

				-- send message
				NS.CommunityFlare_SendMessage(k, strformat("%s (%d %s)", text, NS.CommFlare.CF.CommCount, L["Community Members"]))
			end)

			-- next
			timer = timer + 0.2
		end
	end

	-- clear
	NS.CommFlare.CF.StatusCheck = {}
end

-- process pvp match inactive
function NS.CommFlare:PVP_MATCH_INACTIVE(msg)
	-- reset battleground status
	NS.CommFlare.CF.MatchStatus = 0
	NS.CommunityFlare_Reset_Battleground_Status()
end

-- process quest detail
function NS.CommFlare:QUEST_DETAIL(msg, ...)
	local questStartItemID = ...

	-- verify quest giver
	local player, realm = UnitName("questnpc")
	if (player and (player ~= "")) then
		-- has realm?
		if (realm and (realm ~= "")) then
			-- add realm
			player = player .. "-" .. realm
		end

		-- unit in raid?
		if (UnitInRaid(player) ~= nil) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- block all shared quests?
				local decline = false
				if (NS.charDB.profile.blockSharedQuests == 3) then
					-- always decline
					decline = true
				-- block irrelevant quests?
				elseif (NS.charDB.profile.blockSharedQuests == 2) then
					-- get MapID
					NS.CommFlare.CF.MapID = MapGetBestMapForUnit("player")
					if (NS.CommFlare.CF.MapID and (NS.CommFlare.CF.MapID > 0)) then
						-- initialize
						decline = true
						local epicBG = false
						NS.CommFlare.CF.QuestID = GetQuestID()

						-- alterac valley or korrak's revenge?
						if ((NS.CommFlare.CF.MapID == 91) or (NS.CommFlare.CF.MapID == 1537)) then
							-- list of allowed quests
							local allowedQuests = {
								[56257] = true, -- The Battle for Alterac (Seasonal)
								[56259] = true, -- Lokholar the Ice Lord (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[NS.CommFlare.CF.QuestID] and (allowedQuests[NS.CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						-- isle of conquest?
						elseif (NS.CommFlare.CF.MapID == 169) then
							-- epic battleground
							epicBG = true
						-- battle for wintergrasp?
						elseif (NS.CommFlare.CF.MapID == 1334) then
							-- list of allowed quests
							local allowedQuests = {
								[13178] = true, -- Slay them all
								[13183] = true, -- Victory in Wintergrasp
								[13185] = true, -- Stop the Siege
								[13223] = true, -- Defend the Siege
								[13539] = true, -- Toppling the Towers
								[55509] = true, -- Victory in Wintergrasp (Seasonal)
								[55511] = true, -- Slay them all! (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[NS.CommFlare.CF.QuestID] and (allowedQuests[NS.CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						-- ashran?
						elseif (NS.CommFlare.CF.MapID == 1478) then
							-- list of allowed quests
							local allowedQuests = {
								[56337] = true, -- Uncovering the Artifact Fragments (Seasonal)
								[56339] = true, -- Tremblade Must Die (Seasonal)
							}

							-- allowed quest?
							epicBG = true
							if (allowedQuests[NS.CommFlare.CF.QuestID] and (allowedQuests[NS.CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						end

						-- epic battleground?
						if (epicBG == true) then
							-- list of allowed quests
							local allowedQuests = {
								[72167] = true,
								[72723] = true,
							}

							-- allowed quest?
							if (allowedQuests[NS.CommFlare.CF.QuestID] and (allowedQuests[NS.CommFlare.CF.QuestID] == true)) then
								-- allowed
								decline = false
							end
						end
					end
				end

				-- decline?
				if (decline == true) then
					-- decline quest
					DeclineQuest()
					print(strformat("%s %s", L["Auto declined quest from"], player))
				end
			end
		end
	end
end

-- process ready check
function NS.CommFlare:READY_CHECK(msg, ...)
	local sender, timeleft = ...

	-- initialize partyX to false if you are leader
	NS.CommFlare.CF.ReadyCheck = {}
	NS.CommFlare.CF.PartyVersions = {}
	if (NS.CommunityFlare_IsGroupLeader() == true) then
		-- are you in a party?
		if (IsInGroup() and not IsInRaid()) then
			-- send ready check message
			NS.CommFlare:SendCommMessage(ADDON_NAME, "READY_CHECK", "PARTY")
		end
	end

	-- does the player have the mercenary buff?
	NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
	if (NS.CommFlare.CF.HasAura == true) then
		-- send party message
		NS.CommunityFlare_SendMessage(nil, strformat(L["I currently have the %s buff! (Are we mercing?)"], L["Mercenary Contract"]))
	end

	-- capable of auto queuing?
	NS.CommFlare.CF.AutoQueueable = false
	if (not IsInRaid()) then
		NS.CommFlare.CF.AutoQueueable = true
	else
		-- larger than rated battleground count?
		if (GetNumGroupMembers() > 10) then
			NS.CommFlare.CF.AutoQueueable = true
		end
	end

	-- auto queueable?
	NS.CommFlare.CF.AutoQueue = false
	if (NS.CommFlare.CF.AutoQueueable == true) then
		-- party leader is community?
		if (NS.charDB.profile.communityPartyLeader == true) then
			-- auto queue enabled
			NS.CommFlare.CF.AutoQueue = true
		end

		-- always auto queue?
		if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.alwaysAutoQueue == true)) then
			-- auto queue enabled
			NS.CommFlare.CF.AutoQueue = true
		end

		-- battle net auto queue enabled?
		if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.bnetAutoQueue == true)) then
			local guid = NS.CommunityFlare_GetPartyLeaderGUID()
			local info = BattleNetGetAccountInfoByGUID(guid)
			if (info and (info.isFriend == true)) then
				-- auto queue enabled
				NS.CommFlare.CF.AutoQueue = true
			end
		end

		-- community auto queue?
		if ((NS.CommFlare.CF.AutoQueue == false) and (NS.charDB.profile.communityAutoQueue == true)) then
			-- is sender a community member?
			NS.CommFlare.CF.AutoQueue = NS.CommunityFlare_IsCommunityMember(sender)
		end
	end

	-- auto queue enabled?
	if (NS.CommFlare.CF.AutoQueue == true) then
		-- verify player does not have deserter debuff
		NS.CommunityFlare_CheckForAura("player", "HARMFUL", L["Deserter"])
		if (NS.CommFlare.CF.HasAura == false) then
			if (ReadyCheckFrame:IsShown()) then
				-- click yes button
				ReadyCheckFrameYesButton:Click()
			end

			-- ready
			NS.CommFlare.CF.ReadyCheck["player"] = true
			NS.CommFlare.CF.PartyVersions["player"] = NS.CommunityFlare_Version
		else
			-- send back to party that you have deserter
			NS.CommunityFlare_SendMessage(nil, strformat("%s!", L["Sorry, I currently have deserter"]))
			if (ReadyCheckFrame:IsShown()) then
				-- click no button
				ReadyCheckFrameNoButton:Click()
			end

			-- not ready
			NS.CommFlare.CF.ReadyCheck["player"] = false
			NS.CommFlare.CF.PartyVersions["player"] = NS.CommunityFlare_Version
		end
	end
end

-- process ready check confirm
function NS.CommFlare:READY_CHECK_CONFIRM(msg, ...)
	local unit, isReady = ...

	-- auto queueable?
	if (NS.CommFlare.CF.AutoQueueable == true) then
		-- save unit ready check status
		NS.CommFlare.CF.ReadyCheck[unit] = isReady
	end
end

-- process ready check finished
function NS.CommFlare:READY_CHECK_FINISHED(msg, ...)
	local preempted = ...
	if (preempted == true) then
		-- clear ready check
		NS.CommFlare.CF.ReadyCheck = {}
		return
	end

	-- auto queueable?
	if (NS.CommFlare.CF.AutoQueueable == true) then
		-- are you in a party?
		if (IsInGroup() and not IsInRaid()) then
			-- process all ready checks
			local isEveryoneReady = true
			for k,v in pairs(NS.CommFlare.CF.ReadyCheck) do
				-- unit not ready?
				if (v ~= true) then
					-- everyone not ready
					isEveryoneReady = false
				end
			end

			-- is everyone ready?
			if (isEveryoneReady == true) then
				-- community reporter enabled?
				if (NS.charDB.profile.communityReporter == true) then
					-- are you group leader?
					if (NS.CommunityFlare_IsGroupLeader() == true) then
						-- alliance faction?
						local text = ""
						local faction = UnitFactionGroup("player")
						if (faction == L["Alliance"]) then
							-- alliance ready
							text = strformat(L["%s Alliance Ready!"], NS.CommunityFlare_GetGroupCount())
						-- horde faction?
						elseif (faction == L["Horde"]) then
							-- horde ready
							text = strformat(L["%s Horde Ready!"], NS.CommunityFlare_GetGroupCount())
						else
							-- unknown faction?
							text = strformat("%s %s!", NS.CommunityFlare_GetGroupCount(), L["Ready"])
						end

						-- does the player have the mercenary buff?
						NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
						if (NS.CommFlare.CF.HasAura == true) then
							-- add mercenary contract
							text = strformat("%s [%s]", text, L["Mercenary Contract"])
						end

						-- check if group has room for more
						if (NS.CommFlare.CF.Count < 5) then
							-- community auto invite enabled
							if (NS.charDB.profile.communityAutoInvite == true) then
								-- update text
								text = strformat("%s (%s)", text, L["For auto invite, whisper me INV"])
							end
						end

						-- send to community?
						NS.CommunityFlare_PopupBox("CommunityFlare_Send_Community_Dialog", text)
					end
				end
			end
		end
	end

	-- clear ready check
	NS.CommFlare.CF.ReadyCheck = {}
end

-- process social queue update
function NS.CommFlare:SOCIAL_QUEUE_UPDATE(msg, ...)
	local groupGUID, numAddedItems = ...

	-- nothing added?
	local canJoin, numQueues, needTank, needHealer, needDamage, isSoloQueueParty, questSessionActive, leaderGUID = SocialQueueGetGroupInfo(groupGUID)
	if ((not groupGUID) or (not numAddedItems) or (not leaderGUID)) then
		-- finished
		return
	end

	-- update group
	NS.CommunityFlare_Update_Group(groupGUID)
end

-- process ui info message
function NS.CommFlare:UI_INFO_MESSAGE(msg, ...)
	local type, text = ...

	-- someone has deserter?
	text = strlower(text)
	if (text:find("deserter")) then
		print(strformat("%s!", L["Someone has deserter debuff"]))
	end
end

-- process unit aura
function NS.CommFlare:UNIT_AURA(msg, ...)
	local unitTarget, updateInfo = ...

	-- check for player
	if (unitTarget == "player") then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- any added auras?
			if (updateInfo.addedAuras) then
				-- process all added auras
				for k,v in ipairs(updateInfo.addedAuras) do
					-- reported for inactive?
					if (v.spellId == 94028) then
						-- issue local raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", L["WARNING: REPORTED INACTIVE!\nGet into combat quickly!"])
					-- mercenary contract?
					elseif ((v.spellId == 193472) or (v.spellId == 193475)) then
						-- are you in a party?
						if (IsInGroup() and not IsInRaid()) then
							-- send party message
							NS.CommunityFlare_SendMessage(nil, strformat(L["I currently have the %s buff! (Are we mercing?)"], L["Mercenary Contract"]))
						end
					-- shadow rift?
					elseif (v.spellId == 353293) then
						-- issue local raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", L["WARNING: SHADOW RIFT!\nCast immunity or run out of the circle!"])
					end
				end
			end
		end
	end
end

-- process unit entered vehicle
function NS.CommFlare:UNIT_ENTERED_VEHICLE(msg, ...)
	local unitTarget, showVehicleFrame, isControlSeat, vehicleUIIndicatorID, vehicleGUID, mayChooseExit, hasPitch = ...

	-- check for player
	if (unitTarget == "player") then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- sanity check
			if ((NS.charDB.profile.adjustVehicleTurnSpeed < 1) or (NS.charDB.profile.adjustVehicleTurnSpeed > 3)) then
				-- force default
				NS.charDB.profile.adjustVehicleTurnSpeed = 1
			end

			-- save old speed
			NS.CommFlare.CF.TurnSpeed = GetCVar("TurnSpeed")

			-- set new speed
			local speed = NS.charDB.profile.adjustVehicleTurnSpeed * 180
			SetCVar("TurnSpeed", speed)
		end
	end
end

-- process unit exited vehicle
function NS.CommFlare:UNIT_EXITED_VEHICLE(msg, ...)
	local unitTarget = ...

	-- check for player
	if (unitTarget == "player") then
		-- inside battleground?
		if (PvPIsBattleground() == true) then
			-- default?
			if (NS.charDB.profile.adjustVehicleTurnSpeed == 1) then
				-- reset default speed?
				NS.CommFlare.CF.TurnSpeed = GetCVarDefault("TurnSpeed")
			end

			-- set default or previous speed
			SetCVar("TurnSpeed", NS.CommFlare.CF.TurnSpeed)
		end
	end
end

-- process unit spellcast start
function NS.CommFlare:UNIT_SPELLCAST_START(msg, ...)
	local unitTarget, castGUID, spellID = ...

	-- only check player
	if (unitTarget == "player") then
		-- has warning setting enabled?
		if (NS.charDB.profile.warningLeavingBG > 1) then
			-- inside battleground?
			if (PvPIsBattleground() == true) then
				-- hearthstone?
				if (NS.HearthStoneSpells[spellID]) then
					-- raid warning?
					if (NS.charDB.profile.warningLeavingBG == 2) then
						-- issue local raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", L["Are you really sure you want to hearthstone?"])
					end
				-- teleporting?
				elseif (NS.TeleportSpells[spellID]) then
					-- raid warning?
					if (NS.charDB.profile.warningLeavingBG == 2) then
						-- issue local raid warning (with raid warning audio sound)
						RaidWarningFrame_OnEvent(RaidBossEmoteFrame, "CHAT_MSG_RAID_WARNING", L["Are you really sure you want to teleport?"])
					end
				end
			end
		end
	end
end

-- process update battlefield status
function NS.CommFlare:UPDATE_BATTLEFIELD_STATUS(msg, ...)
	-- sanity check
	local index = ...
	if (not index or (index < 1) or (index > GetMaxBattlefieldID())) then
		-- finished
		return
	end

	-- update battlefield status
	NS.CommunityFlare_Update_Battlefield_Status(index)
end

-- enabled
function NS.CommFlare:OnEnable()
	-- register events
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("BN_CHAT_MSG_ADDON")
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	self:RegisterEvent("CHAT_MSG_SYSTEM")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CLUB_MEMBER_ADDED")
	self:RegisterEvent("CLUB_MEMBER_PRESENCE_UPDATED")
	self:RegisterEvent("CLUB_MEMBER_REMOVED")
	self:RegisterEvent("CLUB_MEMBER_ROLE_UPDATED")
	self:RegisterEvent("CLUB_MEMBER_UPDATED")
	self:RegisterEvent("GROUP_FORMED")
	self:RegisterEvent("GROUP_INVITE_CONFIRMATION")
	self:RegisterEvent("GROUP_JOINED")
	self:RegisterEvent("GROUP_LEFT")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("INITIAL_CLUBS_LOADED")
	self:RegisterEvent("LFG_PROPOSAL_DONE")
	self:RegisterEvent("LFG_PROPOSAL_FAILED")
	self:RegisterEvent("LFG_PROPOSAL_SHOW")
	self:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
	self:RegisterEvent("LFG_ROLE_CHECK_ROLE_CHOSEN")
	self:RegisterEvent("LFG_ROLE_CHECK_SHOW")
	self:RegisterEvent("LFG_UPDATE")
	self:RegisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:RegisterEvent("PARTY_INVITE_REQUEST")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("PVP_MATCH_ACTIVE")
	self:RegisterEvent("PVP_MATCH_COMPLETE")
	self:RegisterEvent("PVP_MATCH_INACTIVE")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_CONFIRM")
	self:RegisterEvent("READY_CHECK_FINISHED")
	self:RegisterEvent("SOCIAL_QUEUE_UPDATE")
	self:RegisterEvent("UI_INFO_MESSAGE")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- disabled
function NS.CommFlare:OnDisable()
	-- unregister events
	self:UnregisterEvent("ADDON_LOADED")
	self:UnregisterEvent("BN_CHAT_MSG_ADDON")
	self:UnregisterEvent("CHAT_MSG_ADDON")
	self:UnregisterEvent("CHAT_MSG_BN_WHISPER")
	self:UnregisterEvent("CHAT_MSG_PARTY")
	self:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
	self:UnregisterEvent("CHAT_MSG_SYSTEM")
	self:UnregisterEvent("CHAT_MSG_WHISPER")
	self:UnregisterEvent("CHAT_MSG_MONSTER_YELL")
	self:UnregisterEvent("CLUB_MEMBER_ADDED")
	self:UnregisterEvent("CLUB_MEMBER_PRESENCE_UPDATED")
	self:UnregisterEvent("CLUB_MEMBER_REMOVED")
	self:UnregisterEvent("CLUB_MEMBER_ROLE_UPDATED")
	self:UnregisterEvent("CLUB_MEMBER_UPDATED")
	self:UnregisterEvent("GROUP_FORMED")
	self:UnregisterEvent("GROUP_INVITE_CONFIRMATION")
	self:UnregisterEvent("GROUP_JOINED")
	self:UnregisterEvent("GROUP_LEFT")
	self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	self:UnregisterEvent("INITIAL_CLUBS_LOADED")
	self:UnregisterEvent("LFG_PROPOSAL_DONE")
	self:UnregisterEvent("LFG_PROPOSAL_FAILED")
	self:UnregisterEvent("LFG_PROPOSAL_SHOW")
	self:UnregisterEvent("LFG_PROPOSAL_SUCCEEDED")
	self:UnregisterEvent("LFG_ROLE_CHECK_ROLE_CHOSEN")
	self:UnregisterEvent("LFG_ROLE_CHECK_SHOW")
	self:UnregisterEvent("LFG_UPDATE")
	self:UnregisterEvent("NOTIFY_PVP_AFK_RESULT")
	self:UnregisterEvent("PARTY_INVITE_REQUEST")
	self:UnregisterEvent("PARTY_LEADER_CHANGED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("PLAYER_LOGIN")
	self:UnregisterEvent("PLAYER_LOGOUT")
	self:UnregisterEvent("PVP_MATCH_ACTIVE")
	self:UnregisterEvent("PVP_MATCH_COMPLETE")
	self:UnregisterEvent("PVP_MATCH_INACTIVE")
	self:UnregisterEvent("QUEST_DETAIL")
	self:UnregisterEvent("READY_CHECK")
	self:UnregisterEvent("READY_CHECK_CONFIRM")
	self:UnregisterEvent("READY_CHECK_FINISHED")
	self:UnregisterEvent("SOCIAL_QUEUE_UPDATE")
	self:UnregisterEvent("UI_INFO_MESSAGE")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	self:UnregisterEvent("UNIT_EXITED_VEHICLE")
	self:UnregisterEvent("UNIT_SPELLCAST_START")
	self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
end

-- communication received
function NS.CommFlare:Community_Flare_OnCommReceived(prefix, message, distribution, sender)
	-- verify prefix
	if (prefix == ADDON_NAME) then
		-- get player name
		local player = UnitName("player")
		if (player ~= sender) then
			-- group joined?
			if (message:find("GROUP_ROSTER_UPDATE")) then
				-- are you not group leader?
				if (NS.CommunityFlare_IsGroupLeader() ~= true) then
					-- community member?
					if (message:find("YES")) then
						-- enable community party leader
						NS.charDB.profile.communityPartyLeader = true
					end
				end
			-- ready check?
			elseif (message:find("READY_CHECK")) then
				-- reply?
				if (message:find("READY_CHECK:")) then
					-- get unit for sender
					local unit = NS.CommunityFlare_GetPartyUnit(sender)
					local player = NS.CommunityFlare_GetFullName(sender)
					if (unit and player) then
						-- split message
						local title, version, build = strsplit(":", message)
						if (not build) then
							-- not available
							build = L["N/A"]
						end

						-- save version number
						NS.CommFlare.CF.PartyVersions[unit] = version

						-- display player's community flare version / build
						print(strformat(L["%s has %s %s (%s)"], player, NS.CommunityFlare_Title, version, build))
					end
				else
					-- send back community flare version
					local message = strformat("READY_CHECK:%s:%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build)
					NS.CommFlare:SendCommMessage(ADDON_NAME, message, "PARTY")
				end
			end
		end
	end
end

-- register addon communication
NS.CommFlare:RegisterComm(ADDON_NAME, "Community_Flare_OnCommReceived")

-- process slash command
function NS.CommFlare:Community_Flare_SlashCommand(input)
	-- force input to lowercase
	local lower = strlower(input)
	if (lower == "defaults") then
		-- reset default settings
		local count = NS.CommunityFlare_Reset_Default_Settings()
		print(strformat(L["%s: Reset %d profile settings to default."], NS.CommunityFlare_Title, count))
	elseif (lower == "deployed") then
		-- check for deployed players
		NS.CommunityFlare_Check_For_Deployed_Players()
	--elseif (lower == "dump") then
	--	-- copy CF to global (for debugging)
	--	CommFlare = NS.CommFlare.CF
	elseif (lower == "inactive") then
		-- check for inactive players
		print(L["Checking for inactive players"])
		NS.CommunityFlare_Check_For_Inactive_Players()
	elseif (lower == "findold") then
		-- check for older members
		print(L["Checking for older members"])
		NS.CommunityFlare_FindExCommunityMembers(NS.charDB.profile.communityMain)
	elseif (lower == "leaders") then
		-- rebuild leaders
		NS.CommunityFlare_RebuildCommunityLeaders()

		-- count community leaders
		local count = 0
		print(strformat(L["%s: Listing Community Leaders"], NS.CommunityFlare_Title))
		for _,v in ipairs(NS.CommFlare.CF.CommunityLeaders) do
			-- display
			print(v)

			-- next
			count = count + 1
		end

		-- display results
		print(strformat(L["%s: %d Community Leaders found."], NS.CommunityFlare_Title, count))
	elseif (lower == "options") then
		-- open options to Community Flare
		Settings_OpenToCategory(NS.CommunityFlare_Title)
		Settings_OpenToCategory(NS.CommunityFlare_Title) -- open options again (wow bug workaround)
	elseif (lower == "pois") then
		-- list all POI's
		NS.CommunityFlare_List_POIs()
	elseif (lower == "refresh") then
		-- process club members
		local status = NS.CommunityFlare_Process_Club_Members()
		if (status == true) then
			-- refreshed database
			print(strformat(L["%s: Refreshed members database! %d members found."], NS.CommunityFlare_Title, NS.CommunityFlare_GetMemberCount()))
		else
			-- no subscribed clubs found
			print(strformat(L["%s: No subscribed clubs found."], NS.CommunityFlare_Title))
		end
	elseif (lower == "reset") then
		-- reset members database
		NS.globalDB.global.members = {}
		print(L["Cleared members database!"])
	elseif (lower == "usage") then
		-- display usages
		print(strformat("%s: %s = %d", NS.CommunityFlare_Title, L["CPU Usage"], GetAddOnCPUUsage(ADDON_NAME)))
		print(strformat("%s: %s = %d", NS.CommunityFlare_Title, L["Memory Usage"], GetAddOnMemoryUsage(ADDON_NAME)))
	else
		-- display full battleground setup
		NS.CommunityFlare_Update_Battleground_Stuff(true)
	end
end

-- register slash command
NS.CommFlare:RegisterChatCommand("comf", "Community_Flare_SlashCommand")
