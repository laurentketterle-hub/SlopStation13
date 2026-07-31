// Kirkificator — the ultimate Kirkification module for SlopStation13
// "Bounty completed! That's another epic level cleared in this game called life! Level up!"
// Bounty #2 — UNCLAIMED

/**
 * Kirkification System
 *
 * Applies William Shatner's legendary acting style to in-game objects and mobs.
 * When activated, targets speak... with... dramatic... pauses... and gain
 * +10 charisma, -5 patience from nearby crew.
 */
/datum/kirkification
	var/name = "Kirkificator"
	var/active = FALSE
	var/kirk_level = 1
	var/static/list/kirk_quotes = list(
		"KHAAAAAAAN!",
		"I... have had... enough... of... YOU!",
		"We... come in... peace. Shoot to kill.",
		"Risk... is our business. That's what this starship is all about.",
		"I'm... givin' her... all she's got, Captain!",
		"The needs... of the many... outweigh... the needs of the few.",
		"Double dumb-ass on you!",
		"Space... the final frontier.",
		"Beam me up, Scotty!",
		"I don't believe in... the no-win scenario.",
		"Second star to the right... and straight on 'til morning.",
		"You... Klingon bastards! You've killed my son!",
		"Galloping around the cosmos is a game for the young.",
		"Don't... mince words. What... is... it?",
		"Logic... is the beginning of wisdom. Not the end.",
		"My God, Bones... what have I done?",
		"Let's... see what... she's got.",
		"Fire!",
		"Status report!",
		"Shields! Shields!"
	)
	var/kirk_sound = 'sound/voice/kirk/khaaan.ogg'
	var/list/affected_mobs = list()
	var/cooldown = 0

// Global Kirkificator instance
/var/global/datum/kirkification/kirkificator = new()

/**
 * Kirkification proc — applies dramatic Shatner pauses to speech
 * @param speaker - the mob being kirkified
 * @param message - original message
 * @return - kirkified message with dramatic pauses
 */
/proc/kirkify_speech(mob/speaker, message)
	if(!global.kirkificator?.active)
		return message
	
	// Add dramatic pauses between words
	var/list/words = splittext(message, " ")
	var/kirkified = ""
	for(var/i in 1 to words.len)
		kirkified += words[i]
		if(prob(40) && i < words.len)
			kirkified += "... "
		else if(i < words.len)
			kirkified += " "
	
	// Occasionally add a Kirk quote
	if(prob(15))
		kirkified += " ... " + pick(global.kirkificator.kirk_quotes)
	
	// Random dramatic pauses
	if(prob(10))
		kirkified = "... " + kirkified + " ..."
	
	return kirkified

/**
 * Activate Kirkification on a target
 * Makes them dramatically pause and occasionally burst into Kirk quotes
 */
/proc/activate_kirkification(mob/target)
	target.add_verb(/mob/proc/kirkify_activate)
	target.add_verb(/mob/proc/kirkify_deactivate)
	to_chat(target, span_boldwarning("You feel... a sudden urge... to speak... DRAMATICALLY!"))
	playsound(target, 'sound/voice/kirk/khaaan.ogg', 50, TRUE)

// Kirkificator item — handheld device
/obj/item/kirkificator
	name = "Kirkificator"
	desc = "A handheld device that applies William Shatner's legendary acting style to any target. Point... and... dramaticize!"
	icon = 'icons/obj/device.dmi'
	icon_state = "kirkificator"
	item_state = "kirkificator"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown = 0

/obj/item/kirkificator/attack(mob/living/M, mob/living/user)
	if(world.time < cooldown + 300)
		to_chat(user, span_warning("The Kirkificator needs... a moment... to recharge!"))
		return
	
	cooldown = world.time
	user.visible_message(
		span_danger("[user] aims the Kirkificator at [M]!"),
		span_notice("You aim the Kirkificator at [M]... and... FIRE!"))
	
	playsound(src, 'sound/weapons/emitter2.ogg', 30, TRUE)
	
	if(global.kirkificator.active)
		global.kirkificator.active = FALSE
		to_chat(M, span_notice("You feel... normal again."))
		user.visible_message(span_notice("[M] seems... less dramatic."))
	else
		global.kirkificator.active = TRUE
		to_chat(M, span_boldwarning("EVERYTHING... MUST BE... DRAMATIC!"))
		M.say(pick(global.kirkificator.kirk_quotes))
		user.visible_message(span_notice("[M] suddenly seems... very... dramatic!"))

// Kirkification status effect
/datum/status_effect/kirkified
	id = "kirkified"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/kirkified

/atom/movable/screen/alert/status_effect/kirkified
	name = "Kirkified"
	desc = "You're channeling your inner Shatner! Everything... must... be... DRAMATIC!"
	icon_state = "kirkified"

// Admin verb for Kirkification
/client/proc/toggle_kirkification()
	set category = "Fun"
	set name = "Toggle Global Kirkification"
	
	if(!check_rights(R_FUN))
		return
	
	global.kirkificator.active = !global.kirkificator.active
	message_admins("[key_name_admin(usr)] has [global.kirkificator.active ? "enabled" : "disabled"] global Kirkification!")
	log_admin("[key_name(usr)] toggled global Kirkification")

// Kirkification game mode announcement
/proc/announce_kirkification()
	var/announcement = pick(list(
		"Attention crew: Kirkification protocols are now... ACTIVE! Speak... dramatically!",
		"This is your Captain speaking. I... am... taking... command... of this station!",
		"Red alert! Someone has activated... THE KIRKIFICATOR!",
		"Crew meeting in the bar. We WILL... discuss... our feelings!",
	))
	priority_announce(announcement, "Kirkification Alert")

// New Kirkification verb for mobs
/mob/proc/kirkify_activate()
	set name = "Dramatize!"
	set category = "Kirkification"
	
	global.kirkificator.active = TRUE
	to_chat(src, span_boldwarning("You channel your inner Shatner!"))
	src.say(pick(global.kirkificator.kirk_quotes))

/mob/proc/kirkify_deactivate()
	set name = "De-dramatize"
	set category = "Kirkification"
	
	global.kirkificator.active = FALSE
	to_chat(src, span_notice("You feel... normal again. (Boring.)"))
