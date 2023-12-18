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
local GetBattlefieldEstimatedWaitTime           = _G.GetBattlefieldEstimatedWaitTime
local GetBattlefieldInstanceRunTime             = _G.GetBattlefieldInstanceRunTime
local GetBattlefieldPortExpiration              = _G.GetBattlefieldPortExpiration
local GetBattlefieldStatus                      = _G.GetBattlefieldStatus
local GetBattlefieldTimeWaited                  = _G.GetBattlefieldTimeWaited
local GetMaxBattlefieldID                       = _G.GetMaxBattlefieldID
local GetNumGroupMembers                        = _G.GetNumGroupMembers
local GetNumSubgroupMembers                     = _G.GetNumSubgroupMembers
local GetPlayerInfoByGUID                       = _G.GetPlayerInfoByGUID
local IsInGroup                                 = _G.IsInGroup
local IsInRaid                                  = _G.IsInRaid
local MapGetBestMapForUnit                      = _G.C_Map.GetBestMapForUnit
local MapGetMapInfo                             = _G.C_Map.GetMapInfo
local PvPGetActiveMatchDuration                 = _G.C_PvP.GetActiveMatchDuration
local SocialQueueGetGroupForPlayer              = _G.C_SocialQueue.GetGroupForPlayer
local SocialQueueGetGroupInfo                   = _G.C_SocialQueue.GetGroupInfo
local SocialQueueGetGroupMembers                = _G.C_SocialQueue.GetGroupMembers
local SocialQueueGetGroupQueues                 = _G.C_SocialQueue.GetGroupQueues
local TimerAfter                                = _G.C_Timer.After
local ipairs                                    = _G.ipairs
local pairs                                     = _G.pairs
local print                                     = _G.print
local tonumber                                  = _G.tonumber
local tostring                                  = _G.tostring
local type                                      = _G.type
local mfloor                                    = _G.math.floor
local strformat                                 = _G.string.format
local strlen                                    = _G.string.len
local strlower                                  = _G.string.lower
local strsplit                                  = _G.string.split
local tinsert                                   = _G.table.insert

-- process battleground commands
function NS.CommunityFlare_Process_Battleground_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
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
	elseif ((subcommand == "status") and result) then
		-- none?
		if (result == "none") then
			-- display sender is not in queue
			print(strformat(L["%s: %s is not in queue."], NS.CommunityFlare_Title, sender))
		else
			-- split arguments
			local queues = {strsplit(";", result)}
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
					print(strformat(L["%s: %s is in %s for %d minutes, %d seconds. (Active Time: %d minutes, %d seconds.)"],
						NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], minutes[2], seconds[2]))
				-- confirm?
				elseif (status == "C") then
					-- calculate times
					local msecs = { tonumber(arg1) }
					local seconds = { mfloor(msecs[1] / 1000) }
					local minutes = { mfloor(seconds[1] / 60) }
					seconds[1] = seconds[1] - (minutes[1] * 60)

					-- display pop info
					print(strformat(L["%s: %s is popped for %s for %d minutes, %d seconds. (Count: %s.)"],
						NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], arg2))
				-- queued?
				elseif (status == "Q") then
					-- calculate times
					local msecs = { tonumber(arg1), tonumber(arg2) }
					local seconds = { mfloor(msecs[1] / 1000), mfloor(msecs[2] / 1000) }
					local minutes = { mfloor(seconds[1] / 60), mfloor(seconds[2] / 60) }
					seconds[1] = seconds[1] - (minutes[1] * 60)
					seconds[2] = seconds[2] - (minutes[2] * 60)

					-- display queue info
					print(strformat(L["%s: %s is queued for %s for %d minutes, %d seconds. (Estimated Wait: %d minutes, %d seconds.)"],
						NS.CommunityFlare_Title, sender, mapName, minutes[1], seconds[1], minutes[2], seconds[2]))
				end
			end
		end
	end

	-- finished
	return true
end

-- process map commands
function NS.CommunityFlare_Process_Map_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- send map info
		local mapID = MapGetBestMapForUnit("player")
		local info = MapGetMapInfo(mapID)
		NS.CommunityFlare_SendMessage(sender, strformat("!CF@Map@Status@%d,%s", mapID, info.name))
	-- status?
	elseif ((subcommand == "status") and result) then
		-- display map info
		local mapID, mapName = strsplit(",", result)
		print(strformat(L["%s: %s is in %s. (Map ID = %s)"], NS.CommunityFlare_Title, sender, mapName, mapID))
	end

	-- finished
	return true
end

-- process mercenary commands
function NS.CommunityFlare_Process_Mercenary_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- check for mercenary buff
		NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
		if (NS.CommFlare.CF.HasAura == true) then
			-- send message
			NS.CommunityFlare_SendMessage(sender, strformat("!CF@Mercenary@Status@%s", "true"))
		else
			-- send message
			NS.CommunityFlare_SendMessage(sender, strformat("!CF@Mercenary@Status@%s", "false"))
		end
	-- status?
	elseif ((subcommand == "status") and result) then
		-- is mercenary?
		if (result == "true") then
			-- mercenary enabled
			print(strformat(L["%s: %s has Mercenary Contract enabled."], NS.CommunityFlare_Title, sender))
		elseif (result == "false") then
			-- mercenary disabled
			print(strformat(L["%s: %s has Mercenary Contract disabled."], NS.CommunityFlare_Title, sender))
		end
	end

	-- finished
	return true
end

-- process party commands
function NS.CommunityFlare_Process_Party_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- send party info
		local isRaid = IsInRaid() and "true" or "false"
		local isGroup = IsInGroup() and "true" or "false"
		local numGroupMembers = GetNumGroupMembers()
		local numSubgroupMembers = GetNumSubgroupMembers()
		NS.CommunityFlare_SendMessage(sender, strformat("!CF@Party@Status@%s,%s,%d,%d", isRaid, isGroup, numGroupMembers, numSubgroupMembers))
	-- status?
	elseif ((subcommand == "status") and result) then
		-- check status
		local isRaid, isGroup, numGroupMembers, numSubGroupMembers = strsplit(",", result)
		if (isRaid == "true") then
			-- raid group
			print(strformat(L["%s: %s is in raid with %d players."], NS.CommunityFlare_Title, sender, numGroupMembers))
		elseif (isGroup == "true") then
			-- party group
			print(strformat(L["%s: %s is in party with %d players."], NS.CommunityFlare_Title, sender, numGroupMembers))
		else
			-- no group
			print(strformat(L["%s: %s is not in any party or raid."], NS.CommunityFlare_Title, sender))
		end
 	end

	-- finished
	return true
end

-- process pop commands
function NS.CommunityFlare_Process_Pop_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- entered queue?
		local numMembers = 0
		local action = "none"
		local queueMapName = "none"
		if (NS.CommFlare.CF.EnteredTime > 0) then
			-- entered
			action = "entered"
		-- left queue?
		elseif (NS.CommFlare.CF.LeftTime > 0) then
			-- left
			action = "left"
		else
			-- search battlefield queues
			for i=1, GetMaxBattlefieldID() do
				-- get battleground types by name
				local status, mapName = GetBattlefieldStatus(i)
				if (status ~= "none") then
					-- tracked pvp?
					local isTracked, isEpicBattleground, isRandomBattleground, isBrawl = NS.CommunityFlare_IsTrackedPVP(mapName)
					if (isTracked == true) then
						-- entered?
						if (status == "active") then
							-- entered
							queueMapName = mapName
							action = "entered"
							break
						-- popped?
						elseif (status == "confirm") then
							-- popped
							queueMapName = mapName
							action = "popped"
							break
						-- queued?
						elseif (status == "queued") then
							-- queued
							queueMapName = mapName
							action = "queued"

							-- get number of members in queue not popped
							numMembers = NS.CommunityFlare_Social_Queues_Count_All_Members_Not_Popped()
						end
					end
				end
			end
		end

		-- is player mercenary?
		local mercenary = "false"
		NS.CommunityFlare_CheckForAura("player", "HELPFUL", L["Mercenary Contract"])
		if (NS.CommFlare.CF.HasAura == true) then
			-- mercenary
			mercenary = "true"
		end

		-- has popped?
		local popped = "none"
		if (NS.CommFlare.CF.CurrentPopped["popped"]) then
			-- convert to string
			popped = tostring(NS.CommFlare.CF.CurrentPopped["popped"])
		end

		-- still in queue?
		local count = tostring(NS.CommunityFlare_GetPartyCount())
		if (action == "queued") then
			-- update count
			count = tostring(NS.CommunityFlare_Social_Queues_Count_All_Members_Not_Popped())
		-- has count?
		elseif (NS.CommFlare.CF.CurrentPopped["count"]) then
			-- convert to string
			count = tostring(NS.CommFlare.CF.CurrentPopped["count"])
		end

		-- no map name yet?
		if (queueMapName == "none") then
			-- has map name?
			if (NS.CommFlare.CF.CurrentPopped["mapName"]) then
				-- use this map name
				queueMapName = NS.CommFlare.CF.CurrentPopped["mapName"]
			end
		end

		-- send pop info
		NS.CommunityFlare_SendMessage(sender, strformat("!CF@Pop@Status@%s,%s,%s,%s,%s", action, popped, count, queueMapName, mercenary))
	-- status?
	elseif ((subcommand == "status") and result) then
		-- is player mercenary?
		local action, popped, count, mapName, mercenary = strsplit(",", result)
		if (mercenary == "true") then
			-- mercenary enabled
			print(strformat(L["%s: %s has Mercenary Contract enabled."], NS.CommunityFlare_Title, sender))
		end

		-- entered?
		if (action == "entered") then
			-- entered popped queue
			print(strformat(L["%s: %s has entered popped queue for %s with %s members."], NS.CommunityFlare_Title, sender, mapName, count))
		-- left?
		elseif (action == "left") then
			-- left popped queue
			local text = strformat(L["Left Queue For Popped %s!"], mapName)
			print(strformat(L["%s: %s has left popped queue for %s with %s members."], NS.CommunityFlare_Title, sender, mapName, count))
		-- popped?
		elseif (action == "popped") then
			-- has queue pop
			print(strformat(L["%s: %s has queue pop for %s with %s members."], NS.CommunityFlare_Title, sender, mapName, count))
		-- queued?
		elseif (action == "queued") then
			-- has no queue pop
			print(strformat(L["%s: %s is still queued for %s with %s members."], NS.CommunityFlare_Title, sender, mapName, count))
		-- none?
		else
			-- not in queue
			print(strformat(L["%s: %s is not in queue."], NS.CommunityFlare_Title, sender))
		end
 	end

	-- finished
	return true
end

-- process queues commands
function NS.CommunityFlare_Process_Queues_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- process all social queues
		local text = ""
		local lines = {}
		for k,v in pairs (NS.CommFlare.CF.SocialQueues) do
			-- has queues and members?
			if (v.numQueues and (v.numQueues > 0) and v.numMembers and (v.numMembers > 0)) then
				-- local?
				local guid = k
				if (guid == "local") then
					-- replace with player guid
					guid = UnitGUID("player")
				end

				-- get length of k
				local length = strlen(k)
				local textlength = strlen(text)
				if ((length + textlength + 1) > 235) then
					-- insert line
					tinsert(lines, text)
						-- reset text
					text = strformat("%s", text, guid)
				else
					-- no text?
					if (text == "") then
						-- no separator
						text = strformat("%s", guid)
					else
						-- add separator
						text = strformat("%s;%s", text, guid)
					end
				end
			end
		end

		-- none found?
		if (text == "") then
			-- send queues info
			NS.CommunityFlare_SendMessage(sender, strformat("!CF@Queues@Status@none"))
		else
			-- insert last text
			tinsert(lines, text)

			-- process all lines
			local timer = 0.0
			for k,v in ipairs(lines) do
				-- throttle
				TimerAfter(timer, function()
					-- send queues info
					NS.CommunityFlare_SendMessage(sender, strformat("!CF@Queues@Status@%s", v))
				end)

				-- next
				timer = timer + 0.1
			end
		end
	-- status?
	elseif ((subcommand == "status") and result) then
		-- no queues?
		if (result == "none") then
			-- no queues found
			print(strformat(L["%s: %s has no queues found."], NS.CommunityFlare_Title, sender))
		else
			-- split queues
			local count = 0
			local partyGUIDs = {strsplit(";", result)}
			for k,v in ipairs(partyGUIDs) do
				-- local queue?
				local groupGUID = v
				if (v:find("Player")) then
					-- attempt to find group for player
					groupGUID = SocialQueueGetGroupForPlayer(v)
				end

				-- has group guid?
				if (groupGUID) then
					-- get queue info
					local leaderName = nil
					local leaderRealm = nil
					local canJoin, numQueues, _, _, _, isSoloQueueParty, _, leaderGUID = SocialQueueGetGroupInfo(groupGUID)
					if (leaderGUID) then
						-- get leader name / realm
						leaderName, leaderRealm = select(6, GetPlayerInfoByGUID(leaderGUID))

						-- found leader name?
						if (leaderName) then
							-- no realm detected?
							if (not leaderRealm or (leaderRealm == "")) then
								leaderRealm = NS.CommFlare.CF.PlayerServerName
							end

							-- get members / queues
							local members = SocialQueueGetGroupMembers(groupGUID)
							local queues = SocialQueueGetGroupQueues(groupGUID)
							if (members and (#members > 0) and queues) then
								-- process all queues
								for k2,v2 in ipairs(queues) do
									-- has queueData?
									if (v2.queueData and v2.queueData.mapName) then
										-- display queue info
										print(strformat(L["%s: %s has queue for %s-%s for %s with %d/5 members."],
											NS.CommunityFlare_Title, sender, leaderName, leaderRealm, v2.queueData.mapName, #members))

										-- increase
										count = count + 1
									end
								end
							end
						end
					end
				end
			end

			-- none found?
			if (count == 0) then
				-- no queues found
				print(strformat(L["%s: %s has no queues found."], NS.CommunityFlare_Title, sender))
			end
		end
 	end

	-- finished
	return true
end

-- process version commands
function NS.CommunityFlare_Process_Version_Commands(event, sender, command, subcommand, result)
	-- sanity check
	if ((subcommand ~= "check") and (subcommand ~= "status")) then
		-- finished
		return true
	end

	-- check?
	if (subcommand == "check") then
		-- send version info
		NS.CommunityFlare_SendMessage(sender, strformat("!CF@Version@Status@%s,%s", NS.CommunityFlare_Version, NS.CommunityFlare_Build))
	-- status?
	elseif ((subcommand == "status") and result) then
		-- display version info
		local version, build = strsplit(",", result)
		print(strformat(L["%s: %s has version %s (%s)"], NS.CommunityFlare_Title, sender, version, build))
	end

	-- finished
	return true
end

-- handle internal commands
function NS.CommunityFlare_Handle_Internal_Commands(event, sender, text, ...)
	-- no shared community?
	if (NS.CommunityFlare_HasSharedCommunity(sender, true) == false) then
		-- finished
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
			-- setup command / subcommand
			local command = strlower(args[2])
			local subcommand = strlower(args[3])
			if (not subcommand) then
				-- finished
				return true
			end

			-- battleground?
			if (command == "battleground") then
				-- process battleground commands
				NS.CommunityFlare_Process_Battleground_Commands(event, sender, command, subcommand, args[4])
			-- map?
			elseif (command == "map") then
				-- process map commands
				NS.CommunityFlare_Process_Map_Commands(event, sender, command, subcommand, args[4])
			-- mercenary?
			elseif (command == "mercenary") then
				-- process mercenary commands
				NS.CommunityFlare_Process_Mercenary_Commands(event, sender, command, subcommand, args[4])
			-- party?
			elseif (command == "party") then
				-- process party commands
				NS.CommunityFlare_Process_Party_Commands(event, sender, command, subcommand, args[4])
			-- pop?
			elseif (command == "pop") then
				-- process pop commands
				NS.CommunityFlare_Process_Pop_Commands(event, sender, command, subcommand, args[4])
			-- queues?
			elseif (command == "queues") then
				-- process queue commands
				NS.CommunityFlare_Process_Queues_Commands(event, sender, command, subcommand, args[4])
			-- version?
			elseif (command == "version") then
				-- process version commands
				NS.CommunityFlare_Process_Version_Commands(event, sender, command, subcommand, args[4])
			end
		end
	end

	-- finished
	return true
end
