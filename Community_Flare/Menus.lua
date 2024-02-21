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
local print                                     = _G.print
local type                                      = _G.type
local strformat                                 = _G.string.format

-- show history
function NS.CommunityFlare_Show_History(...)
	-- find member
	local player = NS.CommFlare.CF.MenuData.player
	local member = NS.CommunityFlare_GetCommunityMember(player)
	if (member) then
		-- find history
		print(strformat("%s: %s", NS.CommunityFlare_Title, member.name))
		local history = NS.CommunityFlare_History_Get(player)
		if (history) then
			-- has first seen?
			if (history.first) then
				-- show first seen time
				local firstseen = date("%Y-%m-%d %H:%M:%S", history.first)
				print(strformat("%s: %s %s", L["First Seen"], L["Around"], firstseen))
			end

			-- has last seen?
			if (history.last) then
				-- string?
				if (type(history.last) == "string") then
					-- show last seen time
					print(strformat("%s: %s %s", L["Last Seen"], L["Around"], history.last))
				else
					-- show last seen time
					local lastseen = date("%Y-%m-%d %H:%M:%S", history.last)
					print(strformat("%s: %s %s", L["Last Seen"], L["Around"], lastseen))
				end
			else
				-- not seen recently
				print(strformat("%s: %s", L["Last Seen"], L["Not seen recently."]))
			end

			-- has last grouped?
			if (history.lastgrouped) then
				-- string?
				if (type(history.lastgrouped) == "string") then
					-- display last grouped
					print(strformat("%s: %s", L["Last Grouped"], history.lastgrouped))
				else
					-- display last grouped
					local lastgrouped = date("%Y-%m-%d %H:%M:%S", history.lastgrouped)
					print(strformat("%s: %s", L["Last Grouped"], lastgrouped))
				end
			end

			-- has grouped matches?
			if (history.gmc) then
				-- display grouped matches count
				print(strformat("%s: %d", L["Grouped Match Count"], history.gmc))
			end

			-- has completed matches?
			if (history.cmc) then
				-- display completed matches count
				print(strformat("%s: %d", L["Completed Match Count"], history.cmc))
			end

			-- has community message count?
			if (history.ncm) then
				-- display community messages sent
				print(strformat("%s: %d", L["Community Messages Sent"], history.ncm))
			end

			-- has last community message time?
			if (history.lcmt) then
				-- display last grouped
				local timestamp = date("%Y-%m-%d %H:%M:%S", history.lcmt)
				print(strformat("%s: %s", L["Last Community Message Sent"], timestamp))
			end
		end
	else
		-- not in database yet
		print(strformat("%s: %s %s", L["Last Seen"], player, L["is NOT in the Database."]))
	end
end

-- drop down options
NS.CommunityFlare_DropDownOptions = {
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
		local menuFound = false
		if (dropdown.which == "COMMUNITIES_WOW_MEMBER") then
			-- found club info?
			local club = dropdown.clubInfo
			if (club and (club.clubType == Enum.ClubType.Character)) then
				-- setup name / server
				local name = dropdown.name
				local server = dropdown.server
				if (server == nil) then
					server = NS.CommFlare.CF.PlayerServerName
				end

				-- save menu data
				menuFound = true
				NS.CommFlare.CF.MenuData.which = dropdown.which
				NS.CommFlare.CF.MenuData.clubInfo = dropdown.clubInfo
				NS.CommFlare.CF.MenuData.clubMemberInfo = dropdown.clubMemberInfo
				NS.CommFlare.CF.MenuData.player = strformat("%s-%s", name, server)
			end
		end

		-- menu found?
		if (menuFound == true) then
			-- showing?
			if (event == "OnShow") then
				-- add the dropdown options to the options table
				local index = 0
				for i = 1, #NS.CommunityFlare_DropDownOptions do
					-- can show?
					local option = NS.CommunityFlare_DropDownOptions[i]
					if (not option.show or option.show()) then
						-- add menu option
						index = index + 1
						options[index] = option
					end
				end

				-- added something?
				if (index > 0) then
					-- we have added options to the dropdown menu
					return true
				end
			-- hiding?
			elseif (event == "OnHide") then
				-- when hiding we can remove our dropdown options from the options table
				for i = #options, 1, -1 do
					-- delete menu options
					options[i] = nil
				end

				-- reset menu data
				NS.CommFlare.CF.MenuData = {}
			end
		end
	end
end

-- registers our callback function for the show and hide events for the first dropdown level only
NS.Libs.LibDropDownExtension:RegisterEvent("OnShow OnHide", NS.CommunityFlare_OnEvent, 1)
