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
local time                                      = _G.time
local type                                      = _G.type
local tonumber                                  = _G.tonumber
local strgsub                                   = _G.string.gsub
local strmatch                                  = _G.string.match

-- clean up history
function NS.CommunityFlare_CleanUpHistory()
	-- process all
	local MON = { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
	for k,v in pairs(NS.globalDB.global.history) do
		-- last seen = old string format?
		if (v.lastseen and (type(v.lastseen) == "string")) then
			-- calculate timestamp
			local str = strgsub(v.lastseen, "  ", " ")
			local pattern = "(%a+) (%a+) (%d+) (%d+):(%d+):(%d+) (%d+)"
			local _, month, day, hour, min, sec, year = str:match(pattern)
			month = MON[month]
			local timestamp = time({day=day,month=month,year=year,hour=hour,min=min,sec=sec})

			-- update
			NS.globalDB.global.history[k].lastseen = timestamp
		end

		-- last grouped = old string format?
		if (v.lastgrouped and (type(v.lastgrouped) == "string")) then
			-- calculate timestamp
			local str = strgsub(v.lastgrouped, "  ", " ")
			local pattern = "(%a+) (%a+) (%d+) (%d+):(%d+):(%d+) (%d+)"
			local _, month, day, hour, min, sec, year = str:match(pattern)
			month = MON[month]
			local timestamp = time({day=day,month=month,year=year,hour=hour,min=min,sec=sec})

			-- update
			NS.globalDB.global.history[k].lastgrouped = timestamp
		end
	end
end

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
	NS.globalDB.global.history[player].lastgrouped = time()
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
	NS.globalDB.global.history[player].lastseen = time()
	return true
end
