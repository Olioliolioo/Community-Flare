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
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local InCombatLockdown                          = _G.InCombatLockdown
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local PVEFrame_ShowFrame                        = _G.PVEFrame_ShowFrame
local UIParentLoadAddOn                         = _G.UIParentLoadAddOn
local UnitExists                                = _G.UnitExists
local UnitGUID                                  = _G.UnitGUID
local UnitName                                  = _G.UnitName
local SocialQueueGetGroupInfo                   = _G.C_SocialQueue.GetGroupInfo
local SocialQueueGetGroupMembers                = _G.C_SocialQueue.GetGroupMembers
local SocialQueueGetGroupQueues                 = _G.C_SocialQueue.GetGroupQueues
local TimerAfter                                = _G.C_Timer.After
local print                                     = _G.print
local select                                    = _G.select
local time                                      = _G.time
local strformat                                 = _G.string.format
local tinsert                                   = _G.table.insert

-- initialize group
function NS.CommunityFlare_Initialize_Group(groupGUID)
	-- initialize
	NS.CommFlare.CF.SocialQueues[groupGUID] = {
		guid = "",
		created = 0,
		popped = 0,
		numQueues = 0,
		leader = nil,
		members = {},
		queues = {},
	}
end

-- add group leader
function NS.CommunityFlare_Add_Group_Leader(groupGUID, playerGUID, playerName, playerRealm)
	-- invalid realm?
	if (not playerRealm or (playerRealm == "")) then
		playerRealm = NS.CommFlare.CF.PlayerServerName
	end

	-- set leader
	NS.CommFlare.CF.SocialQueues[groupGUID].leader = {}
	NS.CommFlare.CF.SocialQueues[groupGUID].leader.guid = playerGUID
	NS.CommFlare.CF.SocialQueues[groupGUID].leader.name = playerName
	NS.CommFlare.CF.SocialQueues[groupGUID].leader.realm = playerRealm
end

-- add group member
function NS.CommunityFlare_Add_Group_Member(groupGUID, index, playerGUID, playerName, playerRealm)
	-- invalid realm?
	if (not playerRealm or (playerRealm == "")) then
		playerRealm = NS.CommFlare.CF.PlayerServerName
	end

	-- set member
	NS.CommFlare.CF.SocialQueues[groupGUID].members[index] = {}
	NS.CommFlare.CF.SocialQueues[groupGUID].members[index].guid = playerGUID
	NS.CommFlare.CF.SocialQueues[groupGUID].members[index].name = playerName
	NS.CommFlare.CF.SocialQueues[groupGUID].members[index].realm = playerRealm
end

-- has queue popped?
function NS.CommunityFlare_HasQueuePopped(groupGUID)
	-- community queue exists?
	if (NS.CommFlare.CF.SocialQueues[groupGUID]) then
		-- popped?
		if (NS.CommFlare.CF.SocialQueues[groupGUID].popped > 0) then
			-- popped
			return true
		end
	end

	-- not popped
	return false
end

-- clean up groups
function NS.CommunityFlare_Cleanup_Groups()
	-- process all
	for k,v in pairs(NS.CommFlare.CF.SocialQueues) do
		-- local?
		if (k == "local") then
			-- update local group
			NS.CommunityFlare_Update_Group("local")
		else
			-- queue exists?
			if (NS.CommFlare.CF.SocialQueues[k]) then
				-- check for queues
				local queues = SocialQueueGetGroupQueues(k)
				if (not queues) then
					-- group has no queues
					NS.CommFlare.CF.SocialQueues[k] = nil
				end
			end
		end
	end
end

-- count all members for social queues
function NS.CommunityFlare_Social_Queues_Count_All_Members()
	-- process all
	local count = 0
	for k,v in pairs(NS.CommFlare.CF.SocialQueues) do
		-- increase
		count = count + v.numMembers
	end

	-- return count
	return count
end

-- count all members for social queues not popped
function NS.CommunityFlare_Social_Queues_Count_All_Members_Not_Popped()
	-- process all
	local count = 0
	for k,v in pairs(NS.CommFlare.CF.SocialQueues) do
		-- not popped?
		if (v.popped == 0) then
			-- increase
			count = count + v.numMembers
		end
	end

	-- return count
	return count
end

-- process popped
function NS.CommunityFlare_Process_Popped(groupGUID)
	-- setup stuff
	local popped = NS.CommFlare.CF.SocialQueues[groupGUID].popped
	local members = NS.CommFlare.CF.SocialQueues[groupGUID].members

	-- add popped grouped members
	local index = popped - (popped % 3)
	if (not NS.CommFlare.CF.PoppedGroups[index]) then
		-- initialize
		NS.CommFlare.CF.PoppedGroups[index] = 0
	end

	-- add member count
	NS.CommFlare.CF.PoppedGroups[index] = NS.CommFlare.CF.PoppedGroups[index] + #members

	-- timer activated?
	if (NS.CommFlare.CF.Popped ~= true) then
		-- set popped
		NS.CommFlare.CF.Popped = true

		-- display results in 2.5 seconds
		local mapName = NS.CommFlare.CF.SocialQueues[groupGUID].name
		TimerAfter(2.5, function()
			-- process all
			local count = 0
			local index = 1
			for k,v in pairs(NS.CommFlare.CF.PoppedGroups) do
				-- display popped groups?
				if (NS.db.profile.displayPoppedGroups == true) then
					-- print group / member totals
					print(strformat(L["%s: Group%d = %d Members"], NS.CommunityFlare_Title, index, v))
				end

				-- next
				count = count + v
				index = index + 1
			end

			-- not popped
			NS.CommFlare.CF.PoppedGroups = {}
			NS.CommFlare.CF.Popped = false

			-- large enough pop to save?
			if (count > 9) then
				-- save into current popped
				NS.CommFlare.CF.CurrentPopped = {
					["popped"] = time(),
					["count"] = count,
					["mapName"] = mapName,
				}
			end

			-- clean up groups
			NS.CommunityFlare_Cleanup_Groups()
		end)
	end
end

-- update group
function NS.CommunityFlare_Update_Group(groupGUID)
	-- local?
	if (groupGUID == "local") then
		-- no local group?
		if (not NS.CommFlare.CF.SocialQueues[groupGUID]) then
			-- initialize
			NS.CommunityFlare_Initialize_Group(groupGUID)
		end

		-- check if currently in queue
		local seconds = 0
		local numQueues = 0
		local numTrackedQueues = 0
		for i=1, GetMaxBattlefieldID() do
			-- trackable?
			local status, mapName = GetBattlefieldStatus(i)
			local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
			if (isTracked == true) then
				-- update queue
				NS.CommFlare.CF.SocialQueues[groupGUID].queues[i] = {
					["name"] = mapName,
					["status"] = status,
				}

				-- get time in queue
				local msecs = GetBattlefieldTimeWaited(i)
				seconds = math.floor(msecs / 1000)

				-- increase
				numTrackedQueues = numTrackedQueues + 1
			end

			-- increase
			numQueues = numQueues + 1
		end

		-- no tracked queues?
		if (numTrackedQueues == 0) then
			-- initialize
			NS.CommunityFlare_Initialize_Group(groupGUID)
			return
		end

		-- update local queue
		NS.CommFlare.CF.SocialQueues[groupGUID].guid = groupGUID
		NS.CommFlare.CF.SocialQueues[groupGUID].numQueues = numQueues
		NS.CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues = numTrackedQueues
		if (NS.CommFlare.CF.SocialQueues[groupGUID].created == 0) then
			-- save created
			NS.CommFlare.CF.SocialQueues[groupGUID].created = time() - seconds
		end

		-- always at least 1
		local count = 1
		if (IsInGroup()) then
			if (not IsInRaid()) then
				-- update count
				count = GetNumGroupMembers()
			end
		end

		-- only yourself?
		if (count == 1) then
			-- add leader + member
			local playerGUID = UnitGUID("player")
			local playerName, playerRealm = UnitName("player")
			NS.CommFlare.CF.SocialQueues[groupGUID].numMembers = 1
			NS.CommunityFlare_Add_Group_Leader(groupGUID, playerGUID, playerName, playerRealm)
			NS.CommunityFlare_Add_Group_Member(groupGUID, 1, playerGUID, playerName, playerRealm)
		else
			-- process all members
			NS.CommFlare.CF.SocialQueues[groupGUID].members = {}
			NS.CommFlare.CF.SocialQueues[groupGUID].numMembers = GetNumGroupMembers()
			for i=1, GetNumGroupMembers() do
				-- unit exists?
				local unit = ""
				if (UnitExists("party" .. i)) then
					-- partyX
					unit = "party" .. i
				else
					-- player
					unit = "player"
				end

				-- party leader?
				local playerGUID = UnitGUID(unit)
				local playerName, playerRealm = UnitName(unit)
				if (UnitIsGroupLeader(unit)) then
					-- add leader
					NS.CommunityFlare_Add_Group_Leader(groupGUID, playerGUID, playerName, playerRealm)
				end

				-- add member
				NS.CommunityFlare_Add_Group_Member(groupGUID, i, playerGUID, playerName, playerRealm)
			end
		end
	else
		-- no leader detected?
		local canJoin, _, _, _, _, isSoloQueueParty, _, leaderGUID = SocialQueueGetGroupInfo(groupGUID)
		if (not leaderGUID) then
			-- clear group
			NS.CommFlare.CF.SocialQueues[groupGUID] = nil
			return
		end

		-- get leader name / realm
		local leaderName, leaderRealm = select(6, GetPlayerInfoByGUID(leaderGUID))
		if (not leaderName) then
			-- display results in 1.5 seconds
			TimerAfter(1.5, function()
				-- try again
				NS.CommunityFlare_Update_Group(groupGUID)
			end)

			-- clear group
			NS.CommFlare.CF.SocialQueues[groupGUID] = nil
			return
		end

		-- no realm detected?
		if (not leaderRealm or (leaderRealm == "")) then
			leaderRealm = NS.CommFlare.CF.PlayerServerName
		end

		-- process current queues
		local numQueues = 0
		local CurrentQueues = {}
		local mapName = L["N/A"]
		local numTrackedQueues = 0
		local queues = SocialQueueGetGroupQueues(groupGUID)
		if (queues and (#queues > 0)) then
			-- process all queues
			for i=1, #queues do
				-- tracked map?
				mapName = queues[i].queueData.mapName
				local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
				if (isTracked == true) then
					-- increase
					numTrackedQueues = numTrackedQueues + 1

					-- add to current queues
					CurrentQueues[mapName] = true
				end

				-- increase
				numQueues = numQueues + 1
			end
		end

		-- not previously in queue?
		local leader = leaderName .. "-" .. leaderRealm
		if (not NS.CommFlare.CF.SocialQueues[groupGUID]) then
			-- any trackable queues?
			if (numTrackedQueues > 0) then
				-- create
				NS.CommunityFlare_Initialize_Group(groupGUID)
				NS.CommFlare.CF.SocialQueues[groupGUID].guid = groupGUID
				NS.CommFlare.CF.SocialQueues[groupGUID].created = time()
				NS.CommFlare.CF.SocialQueues[groupGUID].numQueues = numQueues
				NS.CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues = numTrackedQueues

				-- has leader info?
				if (leaderGUID and leaderName and leaderRealm) then
					-- add leader
					NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, leaderName, leaderRealm)
				end

				-- are they community leader?
				if (NS.CommunityFlare_IsCommunityLeader(leader) == true) then
					-- only process for group leaders
					if (NS.CommunityFlare_IsGroupLeader() == true) then
						-- popup queue window enabled?
						if (NS.db.profile.popupQueueWindow == true) then
							-- not in combat?
							if (InCombatLockdown() ~= true) then
								-- Blizzard_PVPUI loaded?
								local loaded, finished = IsAddOnLoaded("Blizzard_PVPUI")
								if (loaded ~= true)then
									-- load Blizzard_PVPUI
									UIParentLoadAddOn("Blizzard_PVPUI")
								end

								-- open pvp honor frame
								PVEFrame_ShowFrame("PVPUIFrame", HonorFrame)
							end
						end

						-- display info
						print(strformat(L["Community Leader %s has queued for %s. You should probably queue up now too!"], leader, mapName))
					end
				end
			end
		-- created / not popped?
		elseif ((NS.CommFlare.CF.SocialQueues[groupGUID].created > 0) and (NS.CommFlare.CF.SocialQueues[groupGUID].popped == 0)) then
			-- update queue counts
			NS.CommFlare.CF.SocialQueues[groupGUID].numQueues = numQueues
			NS.CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues = numTrackedQueues

			-- popped?
			if ((numQueues == 0) or (numTrackedQueues < NS.CommFlare.CF.SocialQueues[groupGUID].numTrackedQueues)) then
				-- popped
				NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, leaderName, leaderRealm)
				NS.CommFlare.CF.SocialQueues[groupGUID].popped = time()

				-- process all queues
				for k,v in ipairs(NS.CommFlare.CF.SocialQueues[groupGUID].queues) do
					-- not in current queues?
					local mapName = v.queueData.mapName
					if (mapName and not CurrentQueues[mapName]) then
						-- save map name
						NS.CommFlare.CF.SocialQueues[groupGUID].name = mapName
					end
				end

				-- display popped groups?
				if (NS.db.profile.displayPoppedGroups == true) then
					-- print popped group
					print(strformat(L["POPPED: %s-%s (%d/5)"], NS.CommFlare.CF.SocialQueues[groupGUID].leader.name, NS.CommFlare.CF.SocialQueues[groupGUID].leader.realm, #NS.CommFlare.CF.SocialQueues[groupGUID].members))
				end

				-- process popped groups
				NS.CommunityFlare_Process_Popped(groupGUID)
			end
		-- popped?
		elseif (NS.CommunityFlare_HasQueuePopped(groupGUID)) then
			-- no trackable queues?
			if (numTrackedQueues == 0) then
				-- clear group
				NS.CommFlare.CF.SocialQueues[groupGUID] = nil
				return
			end
		end

		-- still has group?
		if (NS.CommFlare.CF.SocialQueues[groupGUID]) then
			-- save queues
			NS.CommFlare.CF.SocialQueues[groupGUID].queues = queues

			-- no leader yet?
			if (not NS.CommFlare.CF.SocialQueues[groupGUID].leader) then
				-- has leader info?
				if (leaderGUID and leaderName and leaderRealm) then
					-- add leader
					NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, leaderName, leaderRealm)
				end
			-- leader changed?
			elseif (NS.CommFlare.CF.SocialQueues[groupGUID].leader.guid ~= leaderGUID) then
				-- update leader
				NS.CommunityFlare_Add_Group_Leader(groupGUID, leaderGUID, leaderName, leaderRealm)
			end

			-- has group members?
			local members = SocialQueueGetGroupMembers(groupGUID)
			if (members and (#members > 0)) then
				-- process all members
				NS.CommFlare.CF.SocialQueues[groupGUID].members = {}
				NS.CommFlare.CF.SocialQueues[groupGUID].numMembers = #members
				for i=1, #members do
					-- get player info
					local playerGUID = members[i].guid
					local playerName, playerRealm = select(6, GetPlayerInfoByGUID(playerGUID))
					if (not playerRealm or (playerRealm == "")) then
						playerRealm = NS.CommFlare.CF.PlayerServerName
					end

					-- add group member
					NS.CommunityFlare_Add_Group_Member(groupGUID, i, playerGUID, playerName, playerRealm)
				end
			else
				-- group no longer exists
				NS.CommFlare.CF.SocialQueues[groupGUID] = nil
			end
		end
	end
end
