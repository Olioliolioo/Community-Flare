local ADDON_NAME, NS = ...

-- create new locale
assert(NS.Libs)
local L = NS.Libs.AceLocale:NewLocale(ADDON_NAME, "frFR", true)
if (not L) then
	-- finished
	return
end

-- Battlegrounds.lua
L["%d minutes, %d seconds"] = "%d minutes, %d secondes"
L["%s: AFK after %d minutes, %d seconds?"] = "%s: LDC après %d minutes, %d secondes"
L["%s: Healers = %d, Tanks = %d"] = "%s: Guérisseurs = %d, Tanks = %d"
L["%s: Not an epic battleground to track."] = "Ce n'est pas un champ de bataille épique à suivre."
L["%s: Not in battleground yet."] = "%s: Pas encore dans un champ de bataille."
L["%s has been queued for %d %s and %d %s for %s."] = "%s a été mis en file d'attente pour %d %s et %d %s pour %s."
L["%s Alliance Ready!"] = "%s Alliance prête!"
L["%s Dropped Mercenary Queue For %s!"] = "%s a annulé la file d'attente de mercenaires pour %s!"
L["%s Dropped Queue For %s!"] = "%s a annulé la file d'attente pour %s!" 
L["%s Horde Ready!"] = "%s Horde prête!"
L["%s Joined Queue For %s! Estimated Wait: %s!"] = "%s a été mis en file d'attente pour %s! Temps d'attente estimé: %s!"
L["%s Joined Mercenary Queue For %s! Estimated Wait: %s!"] = "%s a été mis en file d'attente de mercenaires pour %s! Temps d'attente estimé: %s!"
L["%s Mercenary Queue Popped For %s!"] = "%s la file d'attente de mercenaires a abouti pour %s!"
L["%s Queue Popped For %s!"] = "%s La file d'attente a abouti pour %s!"
L["%s [%d Tanks, %d Healers, %d DPS]"] = "%s [%d Tanks, %d Guérisseurs, %d DPS]"
L["Accepted Queue For Popped %s!"] =  "Est rentré dans le champ de bataille %s!"
L["Alliance"] = "Alliance"
L["Alterac Valley"] = "Vallée d'Alterac"
L["Arathi Basin"] = "Bassin D'Arathi"
L["Ashran"] = "Ashran"
L["Battle for Wintergrasp"] = "La Bataille pour Wintergrasp"
L["Bunkers Left"] = "Abri renforcé à gauche"
L["Community Counts: %s"] = "Total de la communauté: %s"
L["Community Members"] = "Membre de la communauté"
L["Community Members: %s"] = "Membre de la communauté: %s"
L["Community Mercenaries: %s"] = "Communauté mercenaire: %s"
L["Date: %s; MapName: %s; Player: %s; Roster: %s"] = "Date: %s; Nom de la carte: %s; Joueur: %s"
L["Deepwind Gorge"] = "Gorge des Vents hurlants"
L["Defense"] = "Défense"
L["Destroyed"] = "Détruit"
L["East"] =  "À l'est"
L["Entered Mercenary Queue For Popped %s!"] = "File d'attente des mercenaires entrée pour %s déclenché."
L["Entered Queue For Popped %s!"] = "File d'attente entrée pour %s déclenché."
L["Estimated Wait"] = "Temps d'attente estimé"
L["Eye of the Storm"] = "L'oeil de la tempête"
L["For auto invite, whisper me INV"] = "Pour une invitation automatique, chuchote moi INV"
L["Front"] = "En avant"
L["Gates Destroyed"] = "Barrière détruite"
L["Horde"] = "Horde"
L["IBT"] = "IBT"
L["Isle of Conquest"] = "L'Isle de la Conquête"
L["IWB"] = "IWB"
L["Jeron"] = "Jeron"
L["joined the queue for"] = "rejoint la file d’attente pour"
L["Just entered match. Gates not opened yet!"] = "Je viens d'entrer dans un match. Les portes ne sont pas encore ouvertes."
L["Korrak's Revenge"] = "La Vengeance de Korrak"
L["Left Mercenary Queue For Popped %s!"] = "Annulé la file d'attente des mercenaires pour %s déclenché."
L["Left Queue For Popped %s!"] = "Annulé la file d'attente pour %s déclenché"
L["Mercenary Counts: %s"] = "Total des mercenaires: %s"
L["minutes"] = "Minutes"
L["Missed Mercenary Queue For Popped %s!"] = "Raté la file d'attente des mercenaires pour %s déclenché !"
L["Missed Queue For Popped %s!"] = "Raté la file d'attente pour %s déclenché!"
L["N/A"] = "N/A"
L["North"] = "Au Nord"
L["Not currently in an epic battleground or queue!"] = "Actuellement pas dans un champ de bataille épique ou en file d'attente!"
L["POPPED: %s-%s (%d/5)"] = "Déclenché: %s-%s (%d/5)"
L["Offense"] = "Offensive"
L["Port Expired"] = "Port expiré"
L["Queue for %s has paused!"] = "La file d'attente pour %s est en pause!"
L["Queue for %s has resumed!"] = "La file d'attente pour %s a repris!"
L["Random Battleground"] = "Champ de bataille aléatoire"
L["Random Epic Battleground"] = "Champ de bataille épique aléatoire"
L["Rylai"] = "Rylai"
L["seconds"] = "Secondes"
L["Seething Shore"] = "Le rivage bouillonnant"
L["SHB"] = "SHB"
L["Silvershard Mines"] = "Les Mines d'éclargent"
L["Sorry, Battle.NET auto invite not enabled."] = "Désolé, l'invitation automatique de Battle.NET n'est pas activée."
L["Sorry, community auto invite not enabled."] = "Désolé, l'invitation automatique de la communauté n'est pas activée."
L["Sorry, currently in a battleground now."] = "Désolé, je suis dans un champ de bataille."
L["Sorry, currently in a brawl now."] = "Désolé, je suis présentement dans une bagarre."
L["Sorry, group is currently full."] = "Désolé, le groupe est plein."
L["South"] = "Au sud"
L["Temple of Kotmogu"] = "Templte de Kotmogu"
L["The Battle for Gilneas"] = "La Bataille de Gilneas"
L["Time Elapsed"] = "Temps écoulé"
L["Total Members: %d"] = "Nombre total de membres: %d"
L["Total Mercenaries: %d"] = "Nombre total de mercenaires: %d"
L["Towers Destroyed"] = "Tours détruits"
L["Towers Left"] = "Tours restantes"
L["TP"] = "TP"
L["Twin Peaks"] = "Les Pics Jumeaux"
L["Up"] = "En haut"
L["Warsong Gulch"] = "Goulet de Warsong"
L["West"] = "à l'ouest"

-- Config.lua
L["%d community leaders found."] = "%d chef de la communauté trouvé"
L["3 Seconds"] = "3 secondes"
L["4 Seconds"] = "4 secondes"
L["5 Seconds"] = "5 secondes"
L["6 Seconds"] = "6 secondes"
L["Adjust vehicle turn speed?"] = "Modifier la vitesse de rotation du véhicule?"
L["All"] = "Tous"
L["All Community Members"] = "Tous les membres de la communauté" 
L["Always automatically queue?"] = "Toujours mettre en file d'attente automatiquement?"
L["Always remove, then re-add community channels to general? *EXPERIMENTAL*"] = "Toujours retirer, puis réajouter les canaux de la communauté à général ? EXPÉRIMENTAL"
L["Automatically accept invites from Battle.NET friends?"] = "Accepter automatiquement les invitations des amis Battle.NET?"
L["Automatically accept invites from community members?"] = "Accepter automatiquement les invitations des membres de la communauté?"
L["Automatically blocks shared quests during a battleground."] = "Bloquer automatiquement les quêtes partagées pendant un champ de bataille."
L["Auto assist community members?"] = "Attribuer automatiquement le rôle d'assistant aux membres de la communauté"
L["Automatically promotes community members to raid assist in matches."] = "Attribuer automatiquement le rôle d'assistant de raid dans les matchs."
L["Automatically queue if your group leader is in community?"] = "Mettre automatiquement en file d'attente si votre chef de groupe est dans la communauté ?"
L["Automatically queue if your group leader is your Battle.Net friend?"] = "Mettre automatiquement en file d'attente si votre chef de groupe est votre ami Battle.Net ?"
L["Battleground Options"] = "Options pour les champs de batailles"
L["Block game menu hotkeys inside PVP content?"] = "Bloquer les raccourcis du menu du jeu pendant le contenu PvP?"
L["Block shared quests?"] = "Bloquer les quêtes partagées?"
L["Choose the communities that you want to save a roster list upon the gate opening in battlegrounds."] = "Sélectionnez les communautés pour lesquelles vous souhaitez enregistrer une liste de membres à l'ouverture des portes dans les champs de bataille."
L["Choose the community that you want to report queues to."] = "Sélectionnez la communauté à laquelle vous souhaitez signaler les files d'attente."
L["Choose the main community from your subscribed list."] = "Choisissez la communauté principale dans votre liste d'abonnements."
L["Choose the other communities from your subscribed list."] = "Choisissez les autres communautés dans votre liste d'abonnements."
L["Community Options"] = "Options de la Communauté"
L["Community to report to?"] = "Communauté pour qui notifier?"
L["Database members found: %s"] = "Membres de la base de donnée trouvé: %s"
L["Debug Options"] = "Options de débogage"
L["Default (180)"] = "Par défaut (180)"
L["Disabled"] = "Désactivé"
L["Display community member names when running /comf command?"] = "Afficher les noms des membres de la communauté lors de l'exécution de la commande /comf ?"
L["Display notification for popped groups?"] = "Afficher une notification pour les groupes déclenchés ?"
L["Enable debug mode to help debug issues?"] = "Activer le mode débogage pour aider à résoudre les problèmes ?"
L["Enable some debug printing to general window to help debug issues?"] = "Activer l'impression de débogage dans la fenêtre générale pour aider à résoudre les problèmes ?"
L["Fast (360)"] = "Rapidement (360)"
L["Invite Options"] = "Options d'invitation"
L["Irrelevant"] = "Impertinent"
L["Leaders Only"] = "Seulement les Chefs"
L["Log roster list for matches from these communities?"] = "Enregistrer la liste des membres pour les matchs de ces communautés ?"
L["Main Community?"] = "Communauté principale?"
L["Max (540)"] = "Max (540)"
L["Mercenary Contract"] = "Contrat de mercenaire"
L["None"] = "Aucun"
L["Notify you upon given party leadership?"] = "Vous notifier lorsque vous obtenez le leadership du groupe?"
L["Other Communities?"] = "Autres communautés?"
L["Party Options"] = "Options du groupe"
L["Performs an action if you are about to hearth stone or teleport out of an active battleground."] = "Effectue une action si vous êtes sur le point d'utiliser la pierre de foyer ou de téléporter hors d'un champ de bataille actif."
L["Pops up a box to uninvite any users that are AFK at the time of queuing."] = "Affiche une boîte pour désinviter tout utilisateur LDC au moment de la mise en file d'attente."
L["Popup PVP queue window upon leaders queing up? (Only for group leaders.)"] = "Afficher une fenêtre de file d'attente PvP lorsque les chefs de groupe s'inscrivent? (Uniquement pour les chefs de groupe.)"
L["Queue Options"] = "Options de mise en attente"
L["Raid Warning"] = "Avertissement de Raid"
L["Rebuilding community database member list."] = "Reconstruction de la liste des membres de la base de données de la communauté."
L["Rebuild Members?"] = "Reconstruction des membres?"
L["Refresh Members?"] = "Actualiser les membres?"
L["Report queues to main community? (Requires community channel to have /# assigned.)"] = "Signaler les files d'attente à la communauté principale ? (Nécessite que le canal de la communauté ait /# assigné.)"
L["Restrict players from using the /ping system?"] = "Empêcher les joueurs d'utiliser le système de /ping ?"
L["This will adjust your turn speed while inside of a vehicle to make them turn faster during a battleground."] = "Ceci ajustera votre vitesse de rotation lorsque vous êtes à l'intérieur d'un véhicule pour les faire tourner plus rapidement pendant un champ de bataille."
L["This will always automatically accept all queues for you."] = "Ceci acceptera automatiquement toutes les files d'attente pour vous."
L["This will automatically accept group/party invites from Battle.NET friends."] = "Ceci acceptera automatiquement les invitations de groupe/amis Battle.NET."
L["This will automatically accept group/party invites from community members."] = "Ceci acceptera automatiquement les invitations de groupe/des membres de la communauté."
L["This will automatically delete communities channels from general and re-add them upon login."] = "Ceci supprimera automatiquement les canaux de la communauté de général et les réajoutera lors de la connexion."
L["This will automatically display all community members found in the battleground when the /comf command is run."] = "Ceci affichera automatiquement tous les membres de la communauté trouvés dans le champ de bataille lorsque la commande /comf est exécutée."
L["This will automatically queue if your group leader is in community."] = "Ceci mettra automatiquement en file d'attente si votre chef de groupe est dans la communauté."
L["This will automatically queue if your group leader is your Battle.Net friend."] = "Ceci mettra automatiquement en file d'attente si votre chef de groupe est votre ami Battle.Net."
L["This will block players from using the /ping system if they do not have raid assist or raid lead."] = "Ceci bloquera les joueurs d'utiliser le système /ping s'ils n'ont pas le statut d'assistant de raid ou de chef de raid."
L["This will block the game menus from coming up inside an arena or battleground from pressing their hot keys. (To block during recording videos for example.)"] = "Ceci bloquera l'affichage des menus de jeu en utilisant les raccourcis clavier à l'intérieur d'une arène ou d'un champ de bataille. (Pour bloquer pendant l'enregistrement de vidéos, par exemple.)"
L["This will display a notification in your General chat window when groups pop."] = "Ceci affichera une notification dans votre fenêtre de discussion générale lorsque les groupes reçoivent une fenêtre pour un match."
L["This will do various things to help with debugging bugs in the addon to help MESO fix bugs."] = "Cela effectuera différentes actions pour aider à déboguer les bogues dans l'extension afin d'aider MESO à corriger les problèmes."
L["This will open up the PVP queue window if a leader is queing up for PVP so you can queue up too."] = "Ceci ouvrira la fenêtre de file d'attente PvP si un chef de groupe s'inscrit pour du PvP, afin que vous puissiez également vous inscrire."
L["This will print some extra data to your general window that will help MESO debug anything to help fix bugs."] = "Ceci affichera des données supplémentaires dans votre fenêtre générale pour aider MESO à déboguer tout problème et à corriger les bogues."
L["This will provide a quick popup message for you to send your queue status to the Community chat."] = "Ceci fournira un message contextuel rapide pour envoyer votre statut de file d'attente dans le chat de la Communauté."
L["This will provide a warning message or popup message for Group Leaders, if/when their queue becomes paused."] = "Ceci fournira un message d'avertissement ou une fenêtre contextuelle pour les chefs de groupe lorsque leur file d'attente est mise en pause."
L["This will show a raid warning to you when you are given leadership of your party."] = "Ceci affichera un avertissement de raid lorsque vous obtenez le leadership de votre groupe."
L["Uninvite any players that are AFK?"] = "Retirez tous les joueurs qui sont LDC?"
L["Use this to refresh the members database from currently selected communities."] = "Utilisez ceci pour rafraîchir la base de données des membres des communautés actuellement sélectionnées."
L["Use this to totally rebuild the members database from currently selected communities."] = "Utilisez ceci pour reconstruire entièrement la base de données des membres des communautés actuellement sélectionnées."
L["Warn before hearth stoning or teleporting inside a battleground?"] = "Prévenir avant d'utiliser la pierre de foyer ou de se téléporter à l'intérieur d'un champ de bataille ?"
L["Warn if/when queues become paused?"] = "Prévenir si/quand les files d'attente sont mises en pause ?"

-- Database.lua
L["%s: %s (%d, %d) added to community %s."] = "%s: %s (%d, %d) rajouter à la communauté %s."
L["%s: %s (%d, %d) removed from community %s."] = "%s: %s (%d, %d) retiré de la communauté %s."
L["%s: Added %d %s members to the database."] = "Rajouté %d %s membres à la base de données."
L["%s: No subscribed clubs found."] = "aucun club abonné trouvé."
L["%s: Removed %d %s members from the database."] = "%s: Retiré %d %s membres de la base de données."
L["Around"] = "Aux alentours"
L["Completed Match Count"] = "nombre de matchs terminés"
L["Count: %d"] = "Total: %d"
L["Grouped Match Count"] = "Nombre de parties en groupe"
L["is NOT in the Database."] = "N'est pas dans la base de données."
L["Last Grouped"] = "Dernièrement groupé"
L["Last Seen"] = "Dernièrement groupé"
L["Last Seen Around?"] = "Dernièrement vue aux alentours de?"
L["Moved: %s to %s"] = "Déplacé: %s à %s"
L["Not Member: %s"] = "Pas membre: %s"
L["Not seen recently."] = "Pas vue récemment."

-- Debug.lua
L["%s: Info not found!"] = "%s: Info pas trouvé!"
L["%s: Invalid index!"] = "%s: Index non valide"
L["%s: Not currently in an active match."] = "%s: N'est pas dans une partie active à présent."
L["Faction"] = "Faction"
L["GUID"] = "GUID"
L["Player"] = "Joueur"
L["Specialization"] = "Spécialisation"

-- Events.lua
L["%s: %d Community Leaders found."] = "%s: %d Chef de communauté trouvé."
L["%s: Listing Community Leaders"] = "%s: Liste des chefs de la communauté"
L["%s: Refreshed members database! %d members found."] = "Base de données des membres actualisée! %d membres trouvés."
L["%s: Reset %d profile settings to default."] = "%s: Réinitialisé %d paramètres de profil par défaut."
L["%s has %s %s (%s)"] = "%s a %s %s (%s)"
L["%s is under attack!"] = "%s se fait attaqué!"
L["Are you really sure you want to hearthstone?"] = "Êtes-vous vraiment sûr(e) de vouloir utiliser la pierre de foyer?"
L["Are you really sure you want to teleport?"] = "Êtes-vous vraiment sûr(e) de vouloir téléporter?"
L["Auto declined quest from"] = "Quête automatiquement refusée de la part de"
L["begone, uncouth scum!"] = "Vas-t'en, salle vache!"
L["Captain Balinda Stonehearth"] = "Capitaine Balinda Pierre-hearth"
L["Captain Galvangar"] = "Capitaine Galvangar"
L["Checking for inactive players"] = "Vérification pour des joueurs inactifs"
L["Checking for older members"] = "Vérification pour des joueurs plus anciens"
L["Cleared members database!"] = "Base de données des membres effacée!"
L["Count: %d"] = "Total: %d"
L["CPU Usage"] = "Utilisation du processeur"
L["Deserter"] = "Déserteur"
L["deserter"] = "déserteur"
L["Epic battleground has completed with a"] = "Champs de bataille épique a complété avec un"
L["Entered"] = "Entrée"
L["Full Now"] = "Maintenant plein"
L["has requested to join your group"] = "A demandé de se joindre à votre groupe d'instance"
L["I currently have the %s buff! (Are we mercing?)"] = "J'ai actuellement la buff %s! (Sommes-nous en train de recruter des mercenaires?)"
L["jeron emberfall has been slain"] = "Jeron Chûtepierre a été vaincu"
L["Killed"] = "Tué"
L["Leaving party to avoid interrupting the queue"] = "Je quitte le groupe pour éviter d'interrompre la file d'attente."
L["Listing"] = "Liste"
L["loss"] = "Perte"
L["Map ID: Not Found"] = "Identification de carte: Pas trouvé"
L["Memory Usage"] = "Usage de mémoire"
L["Ready"] = "Prêt"
L["%s: Reset %d profile settings to default."] = "Réinitialiser %d profil paramètes à défaut."
L["rylai crestfall has been slain"] = "Rylai Brise-du-Crest a été vaincu"
L["Someone has deserter debuff"] = "Quelqu'un à le status de déserteur"
L["Sorry, I currently have deserter"] = "Je suis désolé, j'ai le status de déserteur"
L["victory"] = "Victoire"
L["WARNING: REPORTED INACTIVE!\nGet into combat quickly!"] = "AVERTISSEMENT SIGNALÉ INACTIF!\nEntrez rapidement en combat!"
L["WARNING: SHADOW RIFT!\nCast immunity or run out of the circle!"] = "AVERTISSEMENT: FRACTURE DE L'OMBRE!\nLancez une immunité ou quittez le cercle!"
L["YOU ARE CURRENTLY THE NEW GROUP LEADER"] = "VOUS ÊTES MAINTENANT LE NOUVEAU CHEF DU GROUPE"
L["you will be removed from"] = "Vous allez être retiré de"
L["your kind has no place in alterac valley"] = "Votre espèces n'a pas de place dans la vallée d'Alterac"

-- Init.lua
L["AFK"] = "LDC"
L["Are you sure you want to wipe the members database and totally rebuild from scratch?"] = "Êtes-vous sûr de vouloir effacer la base de données des membres et la reconstruire entièrement?"
L["Blood"] = "Sang"
L["Brewmaster"] = "Brewmaster"
L["Discipline"] = "Discipline"
L["Guardian"] = "Gardien"
L["Holy"] = "Saint"
L["Kick: %s?"] = "Expulser: %s?"
L["Mistweaver"] = "Tisse-brume"
L["No"] = "Non"
L["Preservation"] = "Préservation?"
L["Protection"] = "Protection"
L["Restoration"] = "Restoration"
L["Send"] = "Envoyer"
L["Send: %s?"] = "Envoyer: %s?"
L["Uninviting ..."] = "Désinvitation ..."
L["Vengeance"] = "Vengeance"
L["Whisper me INV and if a spot is still available, you'll be readded to the party."] = "Chuchotez-moi INV et si il y a une place disponible, vous serez rajouté à nouveau au groupe."
L["Yes"] = "Oui"
L["You've been removed from the party for being AFK."] = "Vous avez été retiré du groupe pour être LDC."

-- Social.lua
L["%s: Group%d = %d Members"] = "%s: Group%d = %d Membres"
L["Community Leader %s has queued for %s. You should probably queue up now too!"] = "Chef de la communauté %s a rejoint la file d'attente pour %s. Vous devriez rejoindre la file d'attente également!"

-- Transmission.lua
L["%s: %s has %s"] = "%s: %s a %s"
L["%s: %s has entered popped queue for %s with %s members."] = "%s: %s est entré dans la file d'attente sautée pour %s avec %s membres."
L["%s: %s has left popped queue for %s with %s members."] = "%s: %s a quitté la file d'attente sautée pour %s avec %s membres."
L["%s: %s has Mercenary Contract enabled."] = "%s: %s a activé le Contrat de mercenaire."
L["%s: %s has Mercenary Contract disabled."] = "%s: %s a désactivé le Contrat de mercenaire."
L["%s: %s has no queues found."] = "%s: %s n'a pas de file d'attente de partie trouvée"
L["%s: %s has queue for %s-%s for %s with %d/5 members."] = "%s: %s est en file d'attente pour %s-%s pour %s avec %d/5 membres."
L["%s: %s has queue pop for %s with %s members."] = "%s: %s a une file d'attente pour %s avec %s membres."
L["%s: %s has version %s (%s)"] = "%s: %s a la version %s (%s)"
L["%s: %s is not in queue."] = "%s n'est pas dans une file d'attente."
L["%s: %s is in %s. (Map ID = %s)"] = "%s: %s est dans %s. (Identification de carte = %s"
L["%s: %s is in %s for %d minutes, %d seconds. (Active Time: %d minutes, %d seconds.)"] = "%s: %s est dans %s pendant %d minutes, %d secondes. (Durée d'activité : %d minutes, %d secondes.)"
L["%s: %s is in party with %d players."] = "%s: %s est dans un groupe avec %d joueurs."
L["%s: %s is in raid with %d players."] = "%s: %s est dans un groupe de raid avec %d joueurs."
L["%s: %s is not in any party or raid."] = "%s: %s n'est pas dans un groupe ou un groupe de raid."
L["%s: %s is popped for %s for %d minutes, %d seconds. (Count: %s.)"] = "%s: %s a reçu une invitation pour %s pour %d minutes, %d secondes. (Total: %s.)"
L["%s: %s is queued for %s for %d minutes, %d seconds. (Estimated Wait: %d minutes, %d seconds.)"] = "%s: %s est en file d'attente pour %s pour %d minutes, %d secondes. (Temps d'attente estimé: %d minutes, %d secondes.)"
L["%s: %s is still queued for %s with %s members."] = "%s : %s est toujours en file d'attente pour %s avec %s membres."
