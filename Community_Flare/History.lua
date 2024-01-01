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

	-- sanity checks
	if (not NS.db or not NS.db.global) then
		-- failed
		return nil
	end

	-- not initialized?
	if (not NS.db.global.history) then
		-- initialize
		NS.db.global.history = {}
	end

	-- player not found?
	if (not NS.db.global.history[player]) then
		-- failed
		return nil
	end

	-- return history
	return NS.db.global.history[player]
end

-- update completed matches
function NS.CommunityFlare_History_Update_Completed_Matches(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- sanity checks
	if (not NS.db or not NS.db.global) then
		-- failed
		return false
	end

	-- not initialized?
	if (not NS.db.global.history) then
		-- initialize
		NS.db.global.history = {}
	end

	-- player not initialized?
	if (not NS.db.global.history[player]) then
		-- initialize
		NS.db.global.history[player] = {}
	end

	-- first completed match?
	if (not NS.db.global.history[player].completedmatches) then
		-- initialize
		NS.db.global.history[player].completedmatches = 1
	else
		-- increase
		NS.db.global.history[player].completedmatches = NS.db.global.history[player].completedmatches + 1
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

	-- sanity checks
	if (not NS.db or not NS.db.global) then
		-- failed
		return false
	end

	-- not initialized?
	if (not NS.db.global.history) then
		-- initialize
		NS.db.global.history = {}
	end

	-- player not initialized?
	if (not NS.db.global.history[player]) then
		-- initialize
		NS.db.global.history[player] = {}
	end

	-- first grouped match?
	if (not NS.db.global.history[player].groupedmatches) then
		-- initialize
		NS.db.global.history[player].groupedmatches = 1
	else
		-- increase
		NS.db.global.history[player].groupedmatches = NS.db.global.history[player].groupedmatches + 1
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

	-- sanity checks
	if (not NS.db or not NS.db.global) then
		-- failed
		return false
	end

	-- not initialized?
	if (not NS.db.global.history) then
		-- initialize
		NS.db.global.history = {}
	end

	-- player not initialized?
	if (not NS.db.global.history[player]) then
		-- initialize
		NS.db.global.history[player] = {}
	end

	-- save last grouped
	NS.db.global.history[player].lastgrouped = date()
	return true
end

-- update last seen
function NS.CommunityFlare_History_Update_Last_Seen(player)
	-- build proper name
	if (not strmatch(player, "-")) then
		-- add realm name
		player = player .. "-" .. NS.CommFlare.CF.PlayerServerName
	end

	-- sanity checks
	if (not NS.db or not NS.db.global) then
		-- failed
		return false
	end

	-- not initialized?
	if (not NS.db.global.history) then
		-- initialize
		NS.db.global.history = {}
	end

	-- player not initialized?
	if (not NS.db.global.history[player]) then
		-- initialize
		NS.db.global.history[player] = {}
	end

	-- update last seen
	NS.db.global.history[player].lastseen = date()
	return true
end
