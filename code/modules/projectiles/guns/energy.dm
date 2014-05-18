/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	fire_sound = 'sound/weapons/Taser.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = "/obj/item/weapon/cell"
	var/projectile_type = "/obj/item/projectile/beam/practice"
	var/modifystate

	emp_act(severity)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
		..()


	New()
		..()
		if(cell_type)
			power_supply = new cell_type(src)

		else
			power_supply = new(src)
		power_supply.give(power_supply.maxcharge)
		return


	load_into_chamber()
		if(in_chamber)	return 1
		if(!power_supply)	return 0
		if(!power_supply.use(charge_cost))	return 0
		if(!projectile_type)	return 0
		in_chamber = new projectile_type(src)
		return 1


	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"


/obj/item/weapon/gun/energy/attackby(var/obj/item/U as obj, var/mob/user as mob)
	if(istype(U,/obj/item/weapon/screwdriver))
		if(!power_supply)
			usr << "[src] is empty."
			return
		else
			usr << "You eject the battery from [src]"
			power_supply.loc = usr.loc
			power_supply = null
			update_icon()
			return
	if (istype(U,/obj/item/weapon/cell))
		if(power_supply)
			usr << "Battery already inserted."
			return
		else
			usr << "You have inerted battery in [src]."
			src.power_supply = U
			user.drop_item()
			U.loc = src
			update_icon()
			return



