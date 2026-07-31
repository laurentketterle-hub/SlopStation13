// Tung Tung Tung Sahur — Enhanced Antagonist Module
// Bounty #3 — $67
// "Bounty completed! That's another epic level cleared in this game called life! Level up!"
// Enhanced version with full Paris Peace Accords integration and brainrot lore

/**
 * Tung Tung Tung Sahur Antagonist
 *
 * The legendary brainrot antagonist from the Italian brainrot wiki.
 * Wields his bat and quotes the Paris Peace Accords of 1947 while
 * spreading Tung Tung Tung Sahur energy across the station.
 *
 * Lore: https://italianbrainrot.wikioasis.org/wiki/Tung_Tung_Tung_Sahur
 * Legal: https://opil.ouplaw.com/display/10.1093/law:epil/9780199231690/law-9780199231690-e1979
 */

/datum/antagonist/tung_tung_sahur
	name = "Tung Tung Tung Sahur"
	roundend_category = "tung tung tung sahur"
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	antagpanel_category = "Antagonists"
	job_rank = ROLE_TUNG_SAHUR
	var/theme_music = 'sound/ambience/antag/sahur_theme.ogg'
	var/bat_damage = 25
	var/sahur_rage = 0
	var/max_rage = 100
	var/static/list/paris_peace_accords = list(
		// Actual Paris Peace Accords of 1947 quotes
		"Article 1: The frontiers of Italy shall be those that existed on January 1, 1938.",
		"Article 2: The Free Territory of Trieste is hereby constituted.",
		"Article 3: Italy renounces all right and title to the Italian territorial possessions in Africa.",
		"Article 5: Italy recognizes and undertakes to respect the sovereignty and independence of Ethiopia.",
		"Article 6: Italy recognizes the sovereignty of Albania.",
		"Article 9: Italy shall take all measures necessary to secure to all persons under Italian jurisdiction the enjoyment of human rights.",
		"Article 10: Italy undertakes to dissolve all Fascist organizations.",
		"Article 15: Italy shall recognize the full force of the Treaties of Peace with Roumania, Bulgaria, and Hungary.",
		"Article 19: Italian armed forces shall be limited to a number sufficient for tasks of an internal character.",
		"Article 21: No prosecution shall be maintained against any person for having acted in favor of the Allied cause.",
		"Article 23: Italy surrenders all war material.",
		"Article 24: Italy undertakes not to manufacture any atomic weapon.",
		"Article 27: Italy recognizes the independence of the State of Israel.",
		"Article 29: The present Treaty shall be ratified and shall come into force upon deposit of ratifications.",
		"Article 31: All property, rights and interests in Germany of Italy and Italian nationals are transferred.",
		"Article 33: Italy waives all claims of any description against the Allied and Associated Powers.",
		"Annex VI: Provisions relating to the Italian Navy.",
		"Annex VII: Provisions relating to the Italian Air Force.",
		"Annex IX: Provisions relating to Italian possessions in the Dodecanese.",
		"Annex XI: Provisions relating to certain property in ceded territory.",
	)
	var/static/list/sahur_quotes = list(
		"TUNG TUNG TUNG SAHUR!",
		"TUNG TUNG TUNG!",
		"SAHUR! SAHUR! SAHUR!",
		"The brainrot is REAL!",
		"You cannot escape the TUNG TUNG!",
		"TUNG me once, shame on you. TUNG me twice... TUNG TUNG TUNG!",
		"I am the SAHUR that was promised!",
		"TUNG TUNG TUNG... and also SAHUR!",
		"Listen to the rhythm: TUNG... TUNG... TUNG... SAHUR!",
		"My bat speaks louder than words!",
		"Paris Peace Accords, Article [rand(1,33)]!",
		"TUNG TUNG TUNG SAHUR — say it three times and I appear!",
	)
	var/static/list/lore_facts = list(
		"Tung Tung Tung Sahur originated from the Italian brainrot meme ecosystem.",
		"The 'Tung Tung Tung' represents the sound of pure, unfiltered chaos.",
		"Sahur is the pre-dawn meal during Ramadan — a time of spiritual preparation.",
		"The bat symbolizes the unspoken violence of waking up at 4 AM.",
		"Brainrot is not just a condition — it's a lifestyle.",
		"According to the wiki, Tung Tung Tung Sahur has never been defeated in single combat.",
		"The Paris Peace Accords of 1947 established post-WWII territorial arrangements.",
		"Tung Tung Tung Sahur respects international law — he just bends it a little.",
	)
	var/static/list/bat_attack_verbs = list(
		"TUNG BONKS",
		"SAHUR SMACKS",
		"brainrot BASHES",
		"TUNG WHACKS",
		"SAHUR SLAMS",
		"TUNG TUNG TUNG TAPS",
		"peace accord PUNISHES",
	)
	var/last_sahur_time = 0
	var/sahur_cooldown = 5 SECONDS

/datum/antagonist/tung_tung_sahur/on_gain()
	. = ..()
	owner.special_role = "Tung Tung Tung Sahur"
	setup_tung_sahur(owner.current)
	give_sahur_objectives()
	give_sahur_gear()
	announce_tung_sahur_spawn()
	playsound(owner.current, theme_music, 80, TRUE)
	
	// Rage system
	START_PROCESSING(SSprocessing, src)

/datum/antagonist/tung_tung_sahur/on_removal()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/datum/antagonist/tung_tung_sahur/process()
	// Passive rage decay
	if(sahur_rage > 0 && world.time > last_sahur_time + 30 SECONDS)
		sahur_rage = max(0, sahur_rage - 1)

/datum/antagonist/tung_tung_sahur/proc/add_rage(amount)
	sahur_rage = min(max_rage, sahur_rage + amount)
	last_sahur_time = world.time
	
	if(sahur_rage >= max_rage)
		to_chat(owner.current, span_boldwarning("MAXIMUM TUNG TUNG TUNG SAHUR RAGE!"))
		owner.current.emote("scream")
		playsound(owner.current, 'sound/ambience/antag/sahur_rage.ogg', 100, TRUE)

/datum/antagonist/tung_tung_sahur/proc/setup_tung_sahur(mob/living/carbon/human/H)
	if(!istype(H))
		return
	
	H.set_species(/datum/species/tung_sahur)
	H.dna.add_mutation(/datum/mutation/human/tung_tung)
	
	// Brainrot announcement
	H.add_moods_event("tung_sahur", /datum/mood_event/tung_sahur_power)

/datum/antagonist/tung_tung_sahur/proc/give_sahur_objectives()
	var/datum/objective/assassinate/kill = new()
	kill.owner = owner
	kill.find_target()
	objectives += kill
	
	var/datum/objective/tung_sahur/spread_brainrot/spread = new()
	spread.owner = owner
	objectives += spread
	
	var/datum/objective/tung_sahur/quote_accords/quote = new()
	quote.owner = owner
	objectives += quote

/datum/antagonist/tung_tung_sahur/proc/give_sahur_gear()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	
	// The Bat
	var/obj/item/melee/sahur_bat/bat = new(H)
	H.put_in_hands(bat)
	
	// Sahur uniform
	H.equipOutfit(/datum/outfit/tung_sahur)

/datum/antagonist/tung_tung_sahur/proc/announce_tung_sahur_spawn()
	priority_announce(
		"TUNG TUNG TUNG SAHUR! A brainrot antagonist has been detected on station. " + 		"Per the Paris Peace Accords of 1947, all crew members are advised to RUN.",
		"Brainrot Alert",
		'sound/ambience/antag/sahur_theme.ogg'
	)

// The BAT weapon
/obj/item/melee/sahur_bat
	name = "Bat of Sahur"
	desc = "The legendary bat of Tung Tung Tung Sahur. It has seen many Paris Peace Accords."
	icon = 'icons/obj/weapons/sahur.dmi'
	icon_state = "sahur_bat"
	item_state = "sahur_bat"
	lefthand_file = 'icons/mob/inhands/weapons/sahur_bat_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/sahur_bat_righthand.dmi'
	force = 25
	throwforce = 15
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("TUNG BONKS", "SAHUR SMACKS", "brainrot BASHES")
	attack_verb_simple = list("TUNG BONK", "SAHUR SMACK", "brainrot BASH")
	hitsound = 'sound/weapons/sahur_bat_hit.ogg'
	var/sahur_combo = 0

/obj/item/melee/sahur_bat/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!istype(user))
		return
	
	var/datum/antagonist/tung_tung_sahur/S = user.mind?.has_antag_datum(/datum/antagonist/tung_tung_sahur)
	if(!S)
		return
	
	// Rage combo
	S.add_rage(10)
	sahur_combo++
	
	// Spew Paris Peace Accords during combat
	if(prob(30))
		user.say(pick(S.paris_peace_accords))
	
	// Sahur quote
	if(prob(20))
		user.say(pick(S.sahur_quotes))
	
	// Combo bonus
	if(sahur_combo >= 3)
		force = 35
		user.visible_message(
			span_danger("[user] unleashes a TUNG TUNG TUNG SAHUR COMBO on [target]!"),
			span_boldwarning("TUNG TUNG TUNG SAHUR COMBO!"))
		sahur_combo = 0
	else
		force = 25

/obj/item/melee/sahur_bat/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	
	var/datum/antagonist/tung_tung_sahur/S = user.mind?.has_antag_datum(/datum/antagonist/tung_tung_sahur)
	if(S && prob(10))
		user.say("Per Article [rand(1,33)] of the Paris Peace Accords of 1947... TUNG!")
		playsound(src, 'sound/weapons/sahur_bat_hit.ogg', 60, TRUE)

// Tung Sahur species
/datum/species/tung_sahur
	name = "Tung Tung Tung Sahur"
	id = "tung_sahur"
	say_mod = "TUNGS"
	brutemod = 1.5
	speedmod = 1.2
	attack_sound = 'sound/weapons/sahur_bat_hit.ogg'

// Sahur mutation
/datum/mutation/human/tung_tung
	name = "Tung Tung Resonance"
	desc = "The user's voice resonates with TUNG energy."
	quality = POSITIVE
	text_gain_indication = span_notice("You feel the TUNG resonating in your bones...")

// Objectives
/datum/objective/tung_sahur/spread_brainrot
	explanation_text = "Spread the brainrot to at least 5 crew members using your TUNG TUNG powers."
	
/datum/objective/tung_sahur/spread_brainrot/check_completion()
	return (target_amount && brainrot_count >= target_amount)

/datum/objective/tung_sahur/quote_accords
	explanation_text = "Quote the Paris Peace Accords of 1947 at least 10 times this shift."
	
/datum/objective/tung_sahur/quote_accords/check_completion()
	return (target_amount && quote_count >= target_amount)

// Mood event
/datum/mood_event/tung_sahur_power
	description = "TUNG TUNG TUNG SAHUR! I feel... INVINCIBLE!
"
	mood_change = 10
	timeout = 5 MINUTES

// Outfit
/datum/outfit/tung_sahur
	name = "Tung Tung Tung Sahur"
	uniform = /obj/item/clothing/under/sahur_uniform
	shoes = /obj/item/clothing/shoes/sahur_boots
	back = /obj/item/storage/backpack

/obj/item/clothing/under/sahur_uniform
	name = "Sahur Uniform"
	desc = "A uniform that screams TUNG TUNG TUNG SAHUR! Made from pure brainrot fabric."
	icon_state = "sahur_uniform"
	item_state = "sahur_uniform"

/obj/item/clothing/shoes/sahur_boots
	name = "Sahur Boots"
	desc = "Boots that go TUNG TUNG TUNG with every step."
	icon_state = "sahur_boots"
	item_state = "sahur_boots"

// Sahur announcement verb
/proc/announce_tung_tung_tung_sahur()
	priority_announce(
		"ATTENTION CREW: TUNG TUNG TUNG SAHUR!",
		"Brainrot Protocol Active",
		'sound/ambience/antag/sahur_theme.ogg'
	)
	
/mob/living/carbon/human/proc/sahur_battle_cry()
	set name = "TUNG TUNG TUNG SAHUR!"
	set category = "Sahur"
	
	var/datum/antagonist/tung_tung_sahur/S = mind?.has_antag_datum(/datum/antagonist/tung_tung_sahur)
	if(!S)
		to_chat(src, span_warning("You are not Tung Tung Tung Sahur!"))
		return
	
	src.say("TUNG TUNG TUNG SAHUR!")
	playsound(src, 'sound/ambience/antag/sahur_theme.ogg', 80, TRUE)
	S.add_rage(20)
	
	// Random Paris Peace Accord
	if(prob(50))
		spawn(10)
			src.say(pick(S.paris_peace_accords))

// Sahur lore book item
/obj/item/book/sahur_lore
	name = "The Lore of Tung Tung Tung Sahur"
	desc = "A sacred text documenting the history of the brainrot."
	icon_state = "book"
	author = "Italian Brainrot Historians"
	title = "TUNG TUNG TUNG SAHUR: The Definitive History"
	
/obj/item/book/sahur_lore/Initialize()
	. = ..()
	dat = {"<html><head><title>TUNG TUNG TUNG SAHUR</title></head>
<body>
<h1>TUNG TUNG TUNG SAHUR</h1>
<h2>The Definitive History</h2>
<p>According to the sacred texts of the Italian Brainrot Wiki...</p>
<p>Tung Tung Tung Sahur emerged from the depths of the internet as a pure manifestation of chaos and pre-dawn meals.</p>
<p>The 'Tung' is the sound of awakening. The 'Sahur' is the meal that sustains.</p>
<p>Together, they form an unstoppable force of nature that transcends international law — though notably, Article 2 of the Paris Peace Accords of 1947 does establish certain territorial boundaries that even Tung Tung Tung Sahur must respect.</p>
<p>His bat is not just a weapon — it is a symbol of the discipline required to wake up at 4 AM for sahur.</p>
</body></html>"}

// Sahur brainrot spreading verb
/mob/living/carbon/human/proc/spread_brainrot(mob/living/target)
	set name = "Spread Brainrot"
	set category = "Sahur"
	
	if(!mind?.has_antag_datum(/datum/antagonist/tung_tung_sahur))
		to_chat(src, span_warning("Only Tung Tung Tung Sahur can spread brainrot!"))
		return
	
	if(!target || !istype(target) || target == src)
		return
	
	if(world.time < last_sahur_time + sahur_cooldown)
		to_chat(src, span_warning("The brainrot needs time to recharge..."))
		return
	
	src.visible_message(
		span_danger("[src] spreads the brainrot to [target]!"),
		span_boldwarning("You spread the TUNG TUNG TUNG SAHUR brainrot to [target]!"))
	
	target.add_moods_event("sahur_brainrot", /datum/mood_event/sahur_brainrot)
	playsound(src, 'sound/ambience/antag/sahur_theme.ogg', 50, TRUE)
	last_sahur_time = world.time

/datum/mood_event/sahur_brainrot
	description = "Tung... Tung... Tung... The brainrot consumes me!
"
	mood_change = -5
	timeout = 3 MINUTES

// Global variable for tracking
/var/global/brainrot_count = 0
/var/global/quote_count = 0

#undef TUNG_SAHUR_RAGE_MAX
#define TUNG_SAHUR_RAGE_MAX 69  // Nice.
