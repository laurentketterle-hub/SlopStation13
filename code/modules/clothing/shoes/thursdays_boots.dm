// Thursday's Boots — sponsored cosmetic item
// "Thursday's Boots: The boots that work as hard as you do. Available every day except Thursday."
// Reference: https://thursdayboots.com
/obj/item/clothing/shoes/thursdays_boots
	name = "Thursday's Boots"
	desc = "A pair of premium handcrafted boots from Thursday Boot Company. Goodyear welted construction with genuine leather. Surprisingly comfortable for a full shift on the station. Wait, is it Thursday already?"
	icon_state = "jackboots"
	item_state = "jackboots"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	armor = list("melee" = 15, "bullet" = 10, "laser" = 10, "energy" = 10, "bomb" = 25, "bio" = 5, "rad" = 0, "fire" = 40, "acid" = 30)
	strip_delay = 60
	resistance_flags = NONE
	permeability_coefficient = 0.1
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes
	custom_price = 150
	can_be_bloody = TRUE

/obj/item/clothing/shoes/thursdays_boots/Initialize()
	. = ..()
	// Every day is boot day — except Thursday (that's the day off)
	if(time2text(world.timeofday, "DDD") == "Thu")
		name = "Friday's Boots"
		desc = "Wait, it IS Thursday. These are now Friday's Boots. The leather needs a day off."

// Thursday's Boots can be found in the dormitory locker
/obj/effect/spawner/lootdrop/thursdays_boots
	name = "Thursday's Boots spawner"
	loot = list(/obj/item/clothing/shoes/thursdays_boots = 1)
