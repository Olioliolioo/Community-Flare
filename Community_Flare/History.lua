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
local date                                      = _G.date
local strmatch                                  = _G.string.match

-- get history
function NS.CommunityFlare_History_Get(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- player not found?
	if (not NS.globalDB.global.history[player]) then
		-- failed
		return nil
	end

	-- return history
	return NS.globalDB.global.history[player]
end

-- update completed matches
function NS.CommunityFlare_History_Update_Completed_Matches(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- player not initialized?
	if (not NS.globalDB.global.history[player]) then
		-- initialize
		NS.globalDB.global.history[player] = {}
	end

	-- first completed match?
	if (not NS.globalDB.global.history[player].completedmatches) then
		-- initialize
		NS.globalDB.global.history[player].completedmatches = 1
	else
		-- increase
		NS.globalDB.global.history[player].completedmatches = NS.globalDB.global.history[player].completedmatches + 1
	end
	return true
end

-- update grouped matches
function NS.CommunityFlare_History_Update_Grouped_Matches(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- player not initialized?
	if (not NS.globalDB.global.history[player]) then
		-- initialize
		NS.globalDB.global.history[player] = {}
	end

	-- first grouped match?
	if (not NS.globalDB.global.history[player].groupedmatches) then
		-- initialize
		NS.globalDB.global.history[player].groupedmatches = 1
	else
		-- increase
		NS.globalDB.global.history[player].groupedmatches = NS.globalDB.global.history[player].groupedmatches + 1
	end
	return true
end

-- update last grouped
function NS.CommunityFlare_History_Update_Last_Grouped(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- player not initialized?
	if (not NS.globalDB.global.history[player]) then
		-- initialize
		NS.globalDB.global.history[player] = {}
	end

	-- save last grouped
	NS.globalDB.global.history[player].lastgrouped = date()
	return true
end

-- update last seen
function NS.CommunityFlare_History_Update_Last_Seen(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- player not initialized?
	if (not NS.globalDB.global.history[player]) then
		-- initialize
		NS.globalDB.global.history[player] = {}
	end

	-- update last seen
	NS.globalDB.global.history[player].lastseen = date()
	return true
end

-- show history
NS.player_check = nil
function NS.CommunityFlare_Show_History(...)
	-- find member
	local member = NS.CommunityFlare_GetCommunityMember(NS.player_check)
	if (member) then
		-- find history
		print(strformat("%s: %s", NS.CommunityFlare_Title, member.name))
		local history = NS.CommunityFlare_History_Get(NS.player_check)
		if (history) then
			-- has last seend?
			if (history and history.lastseen) then
				-- show last seen time
				print(strformat("%s: %s %s", L["Last Seen"], L["Around"], history.lastseen))
			else
				-- not seen recently
				print(strformat("%s: %s", L["Last Seen"], L["Not seen recently."]))
			end

			-- has last grouped?
			if (history.lastgrouped) then
				-- display last grouped
				print(strformat("%s: %s", L["Last Grouped"], history.lastgrouped))
			end

			-- has grouped matches?
			if (history.groupedmatches) then
				-- display grouped matches count
				print(strformat("%s: %d", L["Grouped Match Count"], history.groupedmatches))
			end

			-- has completed matches?
			if (history.completedmatches) then
				-- display completed matches count
				print(strformat("%s: %d", L["Completed Match Count"], history.completedmatches))
			end
		end
	else
		-- not in database yet
		print(strformat("%s: %s %s", L["Last Seen"], NS.player_check, L["is NOT in the Database."]))
	end
end

-- last seen drop down options
NS.CommunityFlare_DropDownOptions_LastSeen = {
	{
		text = L["Last Seen Around?"],
		func = NS.CommunityFlare_Show_History,
	},
}

-- the callback function for when the dropdown event occurs
function NS.CommunityFlare_OnEvent(dropdown, event, options)
	-- has which menu?
	if (dropdown.which) then
		-- community member?
		if (dropdown.which == "COMMUNITIES_WOW_MEMBER") then
			-- found club info?
			NS.player_check = nil
			local club = dropdown.clubInfo
			if (club and (club.clubType == Enum.ClubType.Character)) then
				local name = dropdown.name
				local server = dropdown.server
				if (server == nil) then
					server = NS.CommFlare.CF.PlayerServerName
				end

				-- save player check
				NS.player_check = name .. "-" .. server

				-- showing?
				if (event == "OnShow") then
					-- add the dropdown options to the options table
					for i = 1, #NS.CommunityFlare_DropDownOptions_LastSeen do
						options[i] = NS.CommunityFlare_DropDownOptions_LastSeen[i]
					end

					-- we have added options to the dropdown menu
					return true
				-- hiding?
				elseif (event == "OnHide") then
					-- when hiding we can remove our dropdown options from the options table
					for i = #options, 1, -1 do
						options[i] = nil
					end
				end
			end
		end
	end
end

-- registers our callback function for the show and hide events for the first dropdown level only
NS.Libs.LibDropDownExtension:RegisterEvent("OnShow OnHide", NS.CommunityFlare_OnEvent, 1)
