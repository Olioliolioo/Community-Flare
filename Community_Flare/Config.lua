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
local ClubGetSubscribedClubs                    = _G.C_Club.GetSubscribedClubs
local ipairs                                    = _G.ipairs
local print                                     = _G.print
local strformat                                 = _G.string.format

-- setup main community list
function NS.CommunityFlare_Setup_Main_Community_List(info)
	-- has info?
	local list = {}
	list[1] = L["None"]
	if (info) then
		-- verify default community setup
		NS.CommunityFlare_VerifyDefaultCommunitySetup()

		-- process all
		NS.CommFlare.CF.ClubCount = 0
		NS.CommFlare.CF.Clubs = ClubGetSubscribedClubs()
		for _,v in ipairs(NS.CommFlare.CF.Clubs) do
			-- only communities
			if (v.clubType == Enum.ClubType.Character) then
				-- add club
				list[v.clubId] = v.name
				NS.CommFlare.CF.ClubCount = NS.CommFlare.CF.ClubCount + 1
			end
		end
	end

	-- return list
	return list
end

-- set main community
function NS.CommunityFlare_Set_Main_Community(info, value)
	-- has club id to add for?
	if (value and (value > 1)) then
		-- add all club members
		NS.CommunityFlare_AddAllClubMembersByClubID(value)

		-- set default report ID
		NS.db.profile.communityReportID = value

		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(NS.db.profile.communityReportID, 1)
	else

		-- find main community club
		local clubs = {}
		if (NS.db.profile.communityMain > 0) then
			-- add club id
			tinsert(clubs, NS.db.profile.communityMain)
		end

		-- has community list?
		if (NS.db.profile.communityList and (next(NS.db.profile.communityList) ~= nil)) then
			-- process all lists
			for k,_ in pairs(NS.db.profile.communityList) do
				-- add club id
				tinsert(clubs, k)
			end
		end

		-- process clubs
		for _,clubId in ipairs(clubs) do
			-- remove all club members
			NS.CommunityFlare_RemoveAllClubMembersByClubID(clubId)
		end

		-- rebuild community leaders
		NS.CommunityFlare_RebuildCommunityLeaders()

		-- clear community report id
		NS.db.profile.communityReportID = 1
	end

	-- save main community
	NS.db.profile.communityMain = value

	-- always clear community list
	NS.db.profile.communityList = {}
end

-- setup other community list
function NS.CommunityFlare_Setup_Other_Community_List(info)
	-- process all
	local list = {}
	NS.CommFlare.CF.ClubCount = 0
	NS.CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(NS.CommFlare.CF.Clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- has main community?
			local add = true
			if (NS.db.profile.communityMain and (NS.db.profile.communityMain > 1)) then
				-- skip if matching
				if (v.clubId == NS.db.profile.communityMain) then
					-- do not add
					add = false
				end
			end

			-- add to list?
			if (add == true) then
				-- add club
				list[v.clubId] = v.name
				NS.CommFlare.CF.ClubCount = NS.CommFlare.CF.ClubCount + 1
			end
		end
	end

	-- no list found?
	if (next(list) == nil) then
		-- none
		list[1] = L["None"]
	end

	-- return list
	return list
end

-- other community disabled?
function NS.CommunityFlare_Other_Community_List_Disabled()
	-- main community set?
	if (NS.db.profile.communityMain > 1) then
		-- process all
		NS.CommFlare.CF.ClubCount = 0
		NS.CommFlare.CF.Clubs = ClubGetSubscribedClubs()
		for _,v in ipairs(NS.CommFlare.CF.Clubs) do
			-- only communities
			if (v.clubType == Enum.ClubType.Character) then
				-- not main?
				if (v.clubId ~= NS.db.profile.communityMain) then
					-- increase
					NS.CommFlare.CF.ClubCount = NS.CommFlare.CF.ClubCount + 1
				end
			end
		end

		-- none found?
		if (NS.CommFlare.CF.ClubCount == 0) then
			-- disabled
			return true
		end

		-- enabled
		return false
	else
		-- disabled
		NS.db.profile.communityReportID = 1
		return true
	end
end

-- other community get item
function NS.CommunityFlare_Other_Community_Get_Item(info, key)
	-- community list?
	if (info[#info] == "communityList") then
		-- not initialized?
		if (not NS.db.profile.communityList) then
			NS.db.profile.communityList = {}
		end

		-- valid?
		if (NS.db.profile.communityList[key]) then
			-- return value
			return NS.db.profile.communityList[key]
		end
	end

	-- false
	return false
end

-- other community set item
function NS.CommunityFlare_Other_Community_Set_Item(info, key, value)
	-- community list?
	if (info[#info] == "communityList") then
		-- not initialized?
		if (not NS.db.profile.communityList) then
			NS.db.profile.communityList = {}
		end

		-- true value?
		if (value == true) then
			-- set the value
			NS.db.profile.communityList[key] = value

			-- update members
			NS.CommunityFlare_UpdateMembers(key, true)

			-- readd community chat window
			NS.CommunityFlare_ReaddCommunityChatWindow(key, 1)
		else
			-- clear the value
			NS.db.profile.communityList[key] = nil

			-- update members
			NS.CommunityFlare_UpdateMembers(key, false)
		end
	end
end

-- setup community lists
function NS.CommunityFlare_Setup_Community_List(info)
	-- process all
	local list = {}
	local count = 0
	local clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- add club
			list[v.clubId] = v.name
			count = count + 1
		end
	end

	-- no list found?
	if (next(list) == nil) then
		-- none
		list[1] = L["None"]
	end

	-- return list
	return list
end

-- community list get item
function NS.CommunityFlare_Community_List_Get_Item(info, key)
	-- community log list?
	if (info[#info] == "communityLogList") then
		-- not initialized?
		if (not NS.db.profile.communityLogList) then
			NS.db.profile.communityLogList = {}
		end

		-- valid?
		if (NS.db.profile.communityLogList[key]) then
			-- return value
			return NS.db.profile.communityLogList[key]
		end
	end

	-- false
	return false
end

-- community list set item
function NS.CommunityFlare_Community_List_Set_Item(info, key, value)
	-- community monitor list?
	if (info[#info] == "communityLogList") then
		-- not initialized?
		if (not NS.db.profile.communityLogList) then
			NS.db.profile.communityLogList = {}
		end

		-- true value?
		if (value == true) then
			-- set the value
			NS.db.profile.communityLogList[key] = value
		else
			-- clear the value
			NS.db.profile.communityLogList[key] = nil
		end
	end
end

-- is disabled?
function NS.CommunityFlare_Check_ReportID_Disabled()
	-- main community set?
	if (NS.db.profile.communityMain > 1) then
		-- enabled
		return false
	else
		-- disabled
		NS.db.profile.communityReportID = 1
		return true
	end
end

-- set report id / setup channel
function NS.CommunityFlare_Set_ReportID(info, value)
	-- save new value
	NS.db.profile.communityReportID = value

	-- has report ID?
	if (NS.db.profile.communityReportID > 1) then
		-- readd community chat window
		NS.CommunityFlare_ReaddCommunityChatWindow(NS.db.profile.communityReportID, 1)
	end
end

-- setup total database members
function NS.CommunityFlare_Total_Database_Members(info)
	-- sanity checks?
	if (not NS.db.global) then
		-- initialize
		NS.db.global = {}
	end
	if (not NS.db.global.members) then
		-- initialize
		NS.db.global.members = {}
	end

	-- process all members
	local count = 0
	for k,v in pairs(NS.db.global.members) do
		-- increase
		count = count + 1
	end

	-- return count
	return strformat(L["Database members found: %s"], count)
end

-- refresh database members
function NS.CommunityFlare_Refresh_Database_Members()
	-- sanity checks?
	if (not NS.db.global) then
		-- initialize
		NS.db.global = {}
	end
	if (not NS.db.global.members) then
		-- initialize
		NS.db.global.members = {}
	end

	-- refresh database
	NS.CommunityFlare_Refresh_Database()
end

-- rebuild database members
function NS.CommunityFlare_Rebuild_Database_Members()
	-- sanity checks?
	if (not NS.db.global) then
		-- initialize
		NS.db.global = {}
	end

	-- clear lists
	NS.db.global.members = {}
	NS.CommFlare.CF.CommunityLeaders = {}

	-- process club members again
	print(L["Rebuilding community database member list."])
	local status = NS.CommunityFlare_Process_Club_Members()
	if (status == true) then
		-- display members found
		print(NS.CommunityFlare_Total_Database_Members(nil))

		-- display leaders count
		local count = 0
		for _,v in ipairs(NS.CommFlare.CF.CommunityLeaders) do
			-- next
			count = count + 1
		end
		print(strformat(L["%d community leaders found."], count))
	else
		-- no subscribed clubs found
		print(strformat(L["%s: No subscribed clubs found."], NS.CommunityFlare_Title))
	end
end

-- rebuild database members confirmation
function NS.CommunityFlare_Rebuild_Database_Members_Confirmation()
	-- ask first
	NS.CommunityFlare_PopupBox("CommunityFlare_Rebuild_Members_Dialog")
end

-- setup report community to list
function NS.CommunityFlare_Setup_Report_Community_List(info)
	-- process all
	local list = {}
	list[1] = L["None"]
	NS.CommFlare.CF.ClubCount = 0
	NS.CommFlare.CF.Clubs = ClubGetSubscribedClubs()
	for _,v in ipairs(NS.CommFlare.CF.Clubs) do
		-- only communities
		if (v.clubType == Enum.ClubType.Character) then
			-- add club
			list[v.clubId] = v.name
		end
	end

	-- return list
	return list
end

-- defaults
NS.defaults = {
	profile = {
		-- variables
		MatchStatus = 0,
		SavedTime = 0,

		-- profile only options
		adjustVehicleTurnSpeed = 0,
		alwaysAutoQueue = false,
		alwaysReaddChannels = false,
		blockGameMenuHotKeys = false,
		blockSharedQuests = 2,
		bnetAutoInvite = true,
		bnetAutoQueue = true,
		communityAutoAssist = 2,
		communityAutoInvite = true,
		communityAutoQueue = true,
		communityDisplayNames = true,
		communityPartyLeader = false,
		communityReporter = true,
		debugMode = false,
		displayPoppedGroups = false,
		partyLeaderNotify = 2,
		popupQueueWindow = false,
		printDebugInfo = false,
		restrictPings = true,
		uninvitePlayersAFK = 0,
		warningLeavingBG = 2,
		warningQueuePaused = true,

		-- community stuff
		communityMain = 0,
		communityList = {},
		communityReportID = 0,
		communityRefreshed = 0,
		membersCount = "",

		-- tables
		ASH = {},
		AV = {},
		IOC = {},
		WG = {},
		communityLogList = {},
		Queues = {},
	},
}

-- options
NS.options = {
	name = NS.CommunityFlare_Title_Full,
	handler = NS.CommFlare,
	type = "group",
	args = {
		community = {
			type = "group",
			order = 1,
			name = L["Community Options"],
			inline = true,
			args = {
				communityMain = {
					type = "select",
					order = 1,
					name = L["Main Community?"],
					desc = L["Choose the main community from your subscribed list."],
					values = NS.CommunityFlare_Setup_Main_Community_List,
					get = function(info) return NS.db.profile.communityMain end,
					set = NS.CommunityFlare_Set_Main_Community,
				},
				communityList = {
					type = "multiselect",
					order = 2,
					name = L["Other Communities?"],
					desc = L["Choose the other communities from your subscribed list."],
					values = NS.CommunityFlare_Setup_Other_Community_List,
					disabled = NS.CommunityFlare_Other_Community_List_Disabled,
					get = NS.CommunityFlare_Other_Community_Get_Item,
					set = NS.CommunityFlare_Other_Community_Set_Item,
				},
				membersCount = {
					type = "description",
					order = 3,
					name = NS.CommunityFlare_Total_Database_Members,
				},
				refreshMembers = {
					type = "execute",
					order = 4,
					name = L["Refresh Members?"],
					desc = L["Use this to refresh the members database from currently selected communities."],
					func = NS.CommunityFlare_Refresh_Database_Members,
				},
				rebuildMembers = {
					type = "execute",
					order = 5,
					name = L["Rebuild Members?"],
					desc = L["Use this to totally rebuild the members database from currently selected communities."],
					func = NS.CommunityFlare_Rebuild_Database_Members_Confirmation,
				},
				alwaysReaddChannels = {
					type = "toggle",
					order = 6,
					name = L["Always remove, then re-add community channels to general? *EXPERIMENTAL*"],
					desc = L["This will automatically delete communities channels from general and re-add them upon login."],
					width = "full",
					get = function(info) return NS.db.profile.alwaysReaddChannels end,
					set = function(info, value) NS.db.profile.alwaysReaddChannels = value end,
				},
			},
		},
		invite = {
			type = "group",
			order = 2,
			name = L["Invite Options"],
			inline = true,
			args = {
				bnetAutoInvite = {
					type = "toggle",
					order = 1,
					name = L["Automatically accept invites from Battle.NET friends?"],
					desc = L["This will automatically accept group/party invites from Battle.NET friends."],
					width = "full",
					get = function(info) return NS.db.profile.bnetAutoInvite end,
					set = function(info, value) NS.db.profile.bnetAutoInvite = value end,
				},
				communityAutoInvite = {
					type = "toggle",
					order = 2,
					name = L["Automatically accept invites from community members?"],
					desc = L["This will automatically accept group/party invites from community members."],
					width = "full",
					get = function(info) return NS.db.profile.communityAutoInvite end,
					set = function(info, value) NS.db.profile.communityAutoInvite = value end,
				},
			}
		},
		queue = {
			type = "group",
			order = 3,
			name = L["Queue Options"],
			inline = true,
			args = {
				alwaysAutoQueue = {
					type = "toggle",
					order = 1,
					name = L["Always automatically queue?"],
					desc = L["This will always automatically accept all queues for you."],
					width = "full",
					get = function(info) return NS.db.profile.alwaysAutoQueue end,
					set = function(info, value) NS.db.profile.alwaysAutoQueue = value end,
				},
				bnetAutoQueue = {
					type = "toggle",
					order = 2,
					name = L["Automatically queue if your group leader is your Battle.Net friend?"],
					desc = L["This will automatically queue if your group leader is your Battle.Net friend."],
					width = "full",
					get = function(info) return NS.db.profile.bnetAutoQueue end,
					set = function(info, value) NS.db.profile.bnetAutoQueue = value end,
				},
				communityAutoQueue = {
					type = "toggle",
					order = 3,
					name = L["Automatically queue if your group leader is in community?"],
					desc = L["This will automatically queue if your group leader is in community."],
					width = "full",
					get = function(info) return NS.db.profile.communityAutoQueue end,
					set = function(info, value) NS.db.profile.communityAutoQueue = value end,
				},
				displayPoppedGroups = {
					type = "toggle",
					order = 3,
					name = L["Display notification for popped groups?"],
					desc = L["This will display a notification in your General chat window when groups pop."],
					width = "full",
					get = function(info) return NS.db.profile.displayPoppedGroups end,
					set = function(info, value) NS.db.profile.displayPoppedGroups = value end,
				},
				popupQueueWindow = {
					type = "toggle",
					order = 4,
					name = L["Popup PVP queue window upon leaders queing up? (Only for group leaders.)"],
					desc = L["This will open up the PVP queue window if a leader is queing up for PVP so you can queue up too."],
					width = "full",
					get = function(info) return NS.db.profile.popupQueueWindow end,
					set = function(info, value) NS.db.profile.popupQueueWindow = value end,
				},
				communityReporter = {
					type = "toggle",
					order = 5,
					name = L["Report queues to main community? (Requires community channel to have /# assigned.)"],
					desc = L["This will provide a quick popup message for you to send your queue status to the Community chat."],
					width = "full",
					get = function(info) return NS.db.profile.communityReporter end,
					set = function(info, value) NS.db.profile.communityReporter = value end,
				},
				communityReportID = {
					type = "select",
					order = 6,
					name = L["Community to report to?"],
					desc = L["Choose the community that you want to report queues to."],
					values = NS.CommunityFlare_Setup_Report_Community_List,
					disabled = NS.CommunityFlare_Check_ReportID_Disabled,
					get = function(info) return NS.db.profile.communityReportID end,
					set = NS.CommunityFlare_Set_ReportID,
				},
				uninvitePlayersAFK = {
					type = "select",
					order = 7,
					name = L["Uninvite any players that are AFK?"],
					desc = L["Pops up a box to uninvite any users that are AFK at the time of queuing."],
					values = {
						[0] = L["Disabled"],
						[3] = L["3 Seconds"],
						[4] = L["4 Seconds"],
						[5] = L["5 Seconds"],
						[6] = L["6 Seconds"],
					},
					get = function(info) return NS.db.profile.uninvitePlayersAFK end,
					set = function(info, value) NS.db.profile.uninvitePlayersAFK = value end,
				},
				warningQueuePaused = {
					type = "toggle",
					order = 8,
					name = L["Warn if/when queues become paused?"],
					desc = L["This will provide a warning message or popup message for Group Leaders, if/when their queue becomes paused."],
					width = "full",
					get = function(info) return NS.db.profile.warningQueuePaused end,
					set = function(info, value) NS.db.profile.warningQueuePaused = value end,
				},
			},
		},
		party = {
			type = "group",
			order = 4,
			name = L["Party Options"],
			inline = true,
			args = {
				partyLeaderNotify = {
					type = "select",
					order = 1,
					name = L["Notify you upon given party leadership?"],
					desc = L["This will show a raid warning to you when you are given leadership of your party."],
					values = {
						[1] = L["None"],
						[2] = L["Raid Warning"],
					},
					get = function(info) return NS.db.profile.partyLeaderNotify end,
					set = function(info, value) NS.db.profile.partyLeaderNotify = value end,
				},
			}
		},
		battleground = {
			type = "group",
			order = 5,
			name = L["Battleground Options"],
			inline = true,
			args = {
				communityAutoAssist = {
					type = "select",
					order = 1,
					name = L["Auto assist community members?"],
					desc = L["Automatically promotes community members to raid assist in matches."],
					values = {
						[1] = L["None"],
						[2] = L["Leaders Only"],
						[3] = L["All Community Members"],
					},
					get = function(info) return NS.db.profile.communityAutoAssist end,
					set = function(info, value) NS.db.profile.communityAutoAssist = value end,
				},
				blockSharedQuests = {
					type = "select",
					order = 2,
					name = L["Block shared quests?"],
					desc = L["Automatically blocks shared quests during a battleground."],
					values = {
						[1] = L["None"],
						[2] = L["Irrelevant"],
						[3] = L["All"],
					},
					get = function(info) return NS.db.profile.blockSharedQuests end,
					set = function(info, value) NS.db.profile.blockSharedQuests = value end,
				},
				adjustVehicleTurnSpeed = {
					type = "select",
					order = 3,
					name = L["Adjust vehicle turn speed?"],
					desc = L["This will adjust your turn speed while inside of a vehicle to make them turn faster during a battleground."],
					values = {
						[0] = L["Disabled"],
						[1] = L["Default (180)"],
						[2] = L["Fast (360)"],
						[3] = L["Max (540)"],
					},
					get = function(info) return NS.db.profile.adjustVehicleTurnSpeed end,
					set = function(info, value) NS.db.profile.adjustVehicleTurnSpeed = value end,
				},
				warningLeavingBG = {
					type = "select",
					order = 4,
					name = L["Warn before hearth stoning or teleporting inside a battleground?"],
					desc = L["Performs an action if you are about to hearth stone or teleport out of an active battleground."],
					values = {
						[1] = L["None"],
						[2] = L["Raid Warning"],
					},
					get = function(info) return NS.db.profile.warningLeavingBG end,
					set = function(info, value) NS.db.profile.warningLeavingBG = value end,
				},
				communityLogList = {
					type = "multiselect",
					order = 5,
					name = L["Log roster list for matches from these communities?"],
					desc = L["Choose the communities that you want to save a roster list upon the gate opening in battlegrounds."],
					values = NS.CommunityFlare_Setup_Community_List,
					get = NS.CommunityFlare_Community_List_Get_Item,
					set = NS.CommunityFlare_Community_List_Set_Item,
				},
				communityDisplayNames = {
					type = "toggle",
					order = 6,
					name = L["Display community member names when running /comf command?"],
					desc = L["This will automatically display all community members found in the battleground when the /comf command is run."],
					width = "full",
					get = function(info) return NS.db.profile.communityDisplayNames end,
					set = function(info, value) NS.db.profile.communityDisplayNames = value end,
				},
				restrictPings = {
					type = "toggle",
					order = 7,
					name = L["Restrict players from using the /ping system?"],
					desc = L["This will block players from using the /ping system if they do not have raid assist or raid lead."],
					width = "full",
					get = function(info) return NS.db.profile.restrictPings end,
					set = function(info, value) NS.db.profile.restrictPings = value end,
				},
				blockGameMenuHotKeys = {
					type = "toggle",
					order = 8,
					name = L["Block game menu hotkeys inside PVP content?"],
					desc = L["This will block the game menus from coming up inside an arena or battleground from pressing their hot keys. (To block during recording videos for example.)"],
					width = "full",
					get = function(info) return NS.db.profile.blockGameMenuHotKeys end,
					set = function(info, value) NS.db.profile.blockGameMenuHotKeys = value end,
				},
			},
		},
		debug = {
			type = "group",
			order = 6,
			name = L["Debug Options"],
			inline = true,
			args = {
				debugMode = {
					type = "toggle",
					order = 1,
					name = L["Enable debug mode to help debug issues?"],
					desc = L["This will do various things to help with debugging bugs in the addon to help MESO fix bugs."],
					width = "full",
					get = function(info) return NS.db.profile.debugMode end,
					set = function(info, value) NS.db.profile.debugMode = value end,
				},
				printDebugInfo = {
					type = "toggle",
					order = 2,
					name = L["Enable some debug printing to general window to help debug issues?"],
					desc = L["This will print some extra data to your general window that will help MESO debug anything to help fix bugs."],
					width = "full",
					get = function(info) return NS.db.profile.printDebugInfo end,
					set = function(info, value) NS.db.profile.printDebugInfo = value end,
				},
			}
		},
	},
}

-- reset default settings
function NS.CommunityFlare_Reset_Default_Settings()
	-- process all defaults
	local count = 0
	for k,v in pairs(NS.defaults.profile) do
		-- not default?
		if (NS.db.profile[k] ~= v) then
			-- set default
			NS.db.profile[k] = v

			-- increase
			count = count + 1
		end
	end

	-- return count
	return count
end
