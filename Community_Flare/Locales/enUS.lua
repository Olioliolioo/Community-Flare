local ADDON_NAME, NS = ...

-- create new locale
assert(NS.Libs)
local L = NS.Libs.AceLocale:NewLocale(ADDON_NAME, "enUS", true)
if (not L) then
	-- finished
	return
end

-- Battlegrounds.lua
L["%d minutes, %d seconds"] = true
L["%s: AFK after %d minutes, %d seconds?"] = true
L["%s: Healers = %d, Tanks = %d"] = true
L["%s: Not an epic battleground to track."] = true
L["%s: Not in battleground yet."] = true
L["%s has been queued for %d %s and %d %s for %s."] = true
L["%s Alliance Ready!"] = true
L["%s Dropped Mercenary Queue For %s!"] = true
L["%s Dropped Queue For %s!"] = true
L["%s Horde Ready!"] = true
L["%s Joined Queue For %s! Estimated Wait: %s!"] = true
L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"] = true
L["%s Mercenary Queue Popped For %s!"] = true
L["%s Queue Popped For %s!"] = true
L["%s [%d Tanks, %d Healers, %d DPS]"] = true
L["Accepted Queue For Popped %s!"] = true
L["Alliance"] = true
L["Alterac Valley"] = true
L["Arathi Basin"] = true
L["Ashran"] = true
L["Battle for Wintergrasp"] = true
L["Bunkers Left"] = true
L["Community Counts: %s"] = true
L["Community Members"] = true
L["Community Members: %s"] = true
L["Community Mercenaries: %s"] = true
L["Date: %s; MapName: %s; Player: %s; Roster: %s"] = true
L["Deepwind Gorge"] = true
L["Defense"] = true
L["Destroyed"] = true
L["East"] = true
L["Entered Mercenary Queue For Popped %s!"] = true
L["Entered Queue For Popped %s!"] = true
L["Estimated Wait"] = true
L["Eye of the Storm"] = true
L["For auto invite, whisper me INV"] = true
L["Front"] = true
L["Gates Destroyed"] = true
L["Horde"] = true
L["IBT"] = true
L["Isle of Conquest"] = true
L["IWB"] = true
L["Jeron"] = true
L["joined the queue for"] = true
L["Just entered match. Gates not opened yet!"] = true
L["Korrak's Revenge"] = true
L["Left Mercenary Queue For Popped %s!"] = true
L["Left Queue For Popped %s!"] = true
L["Mercenary Counts: %s"] = true
L["minutes"] = true
L["Missed Mercenary Queue For Popped %s!"] = true
L["Missed Queue For Popped %s!"] = true
L["N/A"] = true
L["North"] = true
L["Not currently in an epic battleground or queue!"] = true
L["POPPED: %s-%s (%d/5)"] = true
L["Offense"] = true
L["Port Expired"] = true
L["Queue for %s has paused!"] = true
L["Queue for %s has resumed!"] = true
L["Random Battleground"] = true
L["Random Epic Battleground"] = true
L["Rylai"] = true
L["seconds"] = true
L["Seething Shore"] = true
L["SHB"] = true
L["Silvershard Mines"] = true
L["Sorry, Battle.NET auto invite not enabled."] = true
L["Sorry, community auto invite not enabled."] = true
L["Sorry, currently in a battleground now."] = true
L["Sorry, currently in a brawl now."] = true
L["Sorry, group is currently full."] = true
L["South"] = true
L["Temple of Kotmogu"] = true
L["The Battle for Gilneas"] = true
L["Time Elapsed"] = true
L["Total Members: %d"] = true
L["Total Mercenaries: %d"] = true
L["Towers Destroyed"] = true
L["Towers Left"] = true
L["TP"] = true
L["Twin Peaks"] = true
L["Up"] = true
L["Warsong Gulch"] = true
L["West"] = true
L["Wintergrasp"] = true

-- Bootstrap.lua
L["Sorry, can not accept invites while currently queued as a mercenary."] = true

-- Config.lua
L["%d community leaders found."] = true
L["3 Seconds"] = true
L["4 Seconds"] = true
L["5 Seconds"] = true
L["6 Seconds"] = true
L["Adjust vehicle turn speed?"] = true
L["All"] = true
L["All Community Members"] = true
L["Always automatically queue?"] = true
L["Always remove, then re-add community channels to general? *EXPERIMENTAL*"] = true
L["Automatically accept invites from Battle.NET friends?"] = true
L["Automatically accept invites from community members?"] = true
L["Automatically blocks shared quests during a battleground."] = true
L["Auto assist community members?"] = true
L["Automatically promotes community members to raid assist in matches."] = true
L["Automatically queue if your group leader is in community?"] = true
L["Automatically queue if your group leader is your Battle.Net friend?"] = true
L["Battleground Options"] = true
L["Block game menu hotkeys inside PVP content?"] = true
L["Block shared quests?"] = true
L["Choose the communities that you want to build the leaders list from."] = true
L["Choose the communities that you want to save a roster list upon the gate opening in battlegrounds."] = true
L["Choose the community that you want to report queues to."] = true
L["Choose the main community from your subscribed list."] = true
L["Choose the other communities from your subscribed list."] = true
L["Community Leaders?"] = true
L["Community Options"] = true
L["Community to report to?"] = true
L["Database members found: %s"] = true
L["Debug Options"] = true
L["Default (180)"] = true
L["Disabled"] = true
L["Display community member names when running /comf command?"] = true
L["Display notification for popped groups?"] = true
L["Enable debug mode to help debug issues?"] = true
L["Enable some debug printing to general window to help debug issues?"] = true
L["Fast (360)"] = true
L["Invite Options"] = true
L["Irrelevant"] = true
L["Leaders Only"] = true
L["Log roster list for matches from these communities?"] = true
L["Main Community?"] = true
L["Max (540)"] = true
L["Mercenary Contract"] = true
L["None"] = true
L["Notify you upon given party leadership?"] = true
L["One or more of the changes you have made require a ReloadUI."] = true
L["Other Communities?"] = true
L["Party Options"] = true
L["Performs an action if you are about to hearth stone or teleport out of an active battleground."] = true
L["Pops up a box to uninvite any users that are AFK at the time of queuing."] = true
L["Popup PVP queue window upon leaders queing up? (Only for group leaders.)"] = true
L["Queue Options"] = true
L["Raid Warning"] = true
L["Rebuilding community database member list."] = true
L["Rebuild Members?"] = true
L["Refresh Members?"] = true
L["Report queues to main community? (Requires community channel to have /# assigned.)"] = true
L["Restrict players from using the /ping system?"] = true
L["This will adjust your turn speed while inside of a vehicle to make them turn faster during a battleground."] = true
L["This will always automatically accept all queues for you."] = true
L["This will automatically accept group/party invites from Battle.NET friends."] = true
L["This will automatically accept group/party invites from community members."] = true
L["This will automatically delete communities channels from general and re-add them upon login."] = true
L["This will automatically display all community members found in the battleground when the /comf command is run."] = true
L["This will automatically queue if your group leader is in community."] = true
L["This will automatically queue if your group leader is your Battle.Net friend."] = true
L["This will block players from using the /ping system if they do not have raid assist or raid lead."] = true
L["This will block the game menus from coming up inside an arena or battleground from pressing their hot keys. (To block during recording videos for example.)"] = true
L["This will display a notification in your General chat window when groups pop."] = true
L["This will do various things to help with debugging bugs in the addon to help MESO fix bugs."] = true
L["This will open up the PVP queue window if a leader is queing up for PVP so you can queue up too."] = true
L["This will print some extra data to your general window that will help MESO debug anything to help fix bugs."] = true
L["This will provide a quick popup message for you to send your queue status to the Community chat."] = true
L["This will provide a warning message or popup message for Group Leaders, if/when their queue becomes paused."] = true
L["This will show a raid warning to you when you are given leadership of your party."] = true
L["Uninvite any players that are AFK?"] = true
L["Use this to refresh the members database from currently selected communities."] = true
L["Use this to totally rebuild the members database from currently selected communities."] = true
L["Warn before hearth stoning or teleporting inside a battleground?"] = true
L["Warn if/when queues become paused?"] = true

-- Database.lua
L["-%s = %d member/s"] = true
L["%s: %s Deployed Members."] = true
L["%s: %s (%d, %d) added to community %s."] = true
L["%s: %s (%d, %d) removed from community %s."] = true
L["%s: Added %d %s members to the database."] = true
L["%s: No members are deployed."] = true
L["%s: No members are deployed for %s."] = true
L["%s: No subscribed clubs found."] = true
L["%s: Removed %d %s members from the database."] = true
L["Around"] = true
L["Count: %d"] = true
L["is NOT in the Database."] = true
L["Moved: %s to %s"] = true
L["Not Member: %s"] = true
L["Not seen recently."] = true

-- Debug.lua
L["%s: Info not found!"] = true
L["%s: Invalid index!"] = true
L["%s: Not currently in an active match."] = true
L["Faction"] = true
L["GUID"] = true
L["Player"] = true
L["Specialization"] = true

-- Events.lua
L["%s: %d Community Leaders found."] = true
L["%s: Alliance Gate = %.1f, Horde Gate = %.1f"] = true
L["%s: Listing Community Leaders"] = true
L["%s: Refreshed members database! %d members found."] = true
L["%s: Reset %d profile settings to default."] = true
L["%s has %s %s (%s)"] = true
L["%s is under attack!"] = true
L["Are you really sure you want to hearthstone?"] = true
L["Are you really sure you want to teleport?"] = true
L["Auto declined quest from"] = true
L["begone, uncouth scum!"] = true
L["Captain Balinda Stonehearth"] = true
L["Captain Galvangar"] = true
L["Checking for inactive players"] = true
L["Checking for older members"] = true
L["Cleared members database!"] = true
L["Count: %d"] = true
L["CPU Usage"] = true
L["Deserter"] = true
L["deserter"] = true
L["Epic battleground has completed with a"] = true
L["Entered"] = true
L["Full Now"] = true
L["has requested to join your group"] = true
L["I currently have the %s buff! (Are we mercing?)"] = true
L["jeron emberfall has been slain"] = true
L["Killed"] = true
L["Leaving party to avoid interrupting the queue"] = true
L["Listing"] = true
L["loss"] = true
L["Map ID: Not Found"] = true
L["Memory Usage"] = true
L["Ready"] = true
L["%s: Reset %d profile settings to default."] = true
L["rylai crestfall has been slain"] = true
L["Someone has deserter debuff"] = true
L["Sorry, I currently have deserter"] = true
L["victory"] = true
L["WARNING: REPORTED INACTIVE!\nGet into combat quickly!"] = true
L["WARNING: SHADOW RIFT!\nCast immunity or run out of the circle!"] = true
L["YOU ARE CURRENTLY THE NEW GROUP LEADER"] = true
L["you will be removed from"] = true
L["your kind has no place in alterac valley"] = true

-- Init.lua
L["AFK"] = true
L["Are you sure you want to wipe the members database and totally rebuild from scratch?"] = true
L["Blood"] = true
L["Brewmaster"] = true
L["Discipline"] = true
L["Guardian"] = true
L["Holy"] = true
L["Kick: %s?"] = true
L["Mistweaver"] = true
L["No"] = true
L["Preservation"] = true
L["Protection"] = true
L["Restoration"] = true
L["Send"] = true
L["Send: %s?"] = true
L["Uninviting ..."] = true
L["Vengeance"] = "Venganza"
L["Whisper me INV and if a spot is still available, you'll be readded to the party."] = true
L["Yes"] = true
L["You've been removed from the party for being AFK."] = true

-- Menus.lua
L["Community Messages Sent"] = true
L["Completed Match Count"] = true
L["First Seen"] = true
L["Grouped Match Count"] = true
L["Last Community Message Sent"] = true
L["Last Grouped"] = true
L["Last Seen"] = true
L["Last Seen Around?"] = true

-- Social.lua
L["%s: Group%d = %d Members"] = true
L["Community Leader %s has queued for %s. You should probably queue up now too!"] = true

-- Transmission.lua
L["%s: %s does not have the Deserter debuff."] = true
L["%s: %s has %s"] = true
L["%s: %s has entered popped queue for %s with %s members."] = true
L["%s: %s has left popped queue for %s with %s members."] = true
L["%s: %s has Mercenary Contract enabled."] = true
L["%s: %s has Mercenary Contract disabled."] = true
L["%s: %s has no queues found."] = true
L["%s: %s has queue for %s-%s for %s with %d/5 members."] = true
L["%s: %s has queue pop for %s with %s members."] = true
L["%s: %s has the Deserter debuff."] = true
L["%s: %s has version %s (%s)"] = true
L["%s: %s is not in queue."] = true
L["%s: %s is in %s. (Map ID = %s)"] = true
L["%s: %s is in %s for %d minutes, %d seconds. (Active Time: %d minutes, %d seconds.)"] = true
L["%s: %s is in party with %d players."] = true
L["%s: %s is in raid with %d players."] = true
L["%s: %s is not in any party or raid."] = true
L["%s: %s is popped for %s for %d minutes, %d seconds. (Count: %s.)"] = true
L["%s: %s is queued for %s for %d minutes, %d seconds. (Estimated Wait: %d minutes, %d seconds.)"] = true
L["%s: %s is still queued for %s with %s members."] = true
