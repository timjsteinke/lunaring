extends Node2D

var game_data: Dictionary

const THRUST_COST_PER_LEVEL = 0
const EFFICIENCY_COST_PER_LEVEL = 300
const FUELREGEN_COST_PER_LEVEL = 150
const SHIELD_COST_PER_LEVEL = 300
const INVENTORY_COST_PER_LEVEL = 500
const FUEL_COST_PER_UNIT = 0 #1

func _on_back_button_pressed() -> void:
	SceneSwitcher.switch_scene("main")
	
func _ready():
	pass

func set_game_data(new_game_data: Dictionary):
	game_data = new_game_data
	update_ui()

#Update the UI when we switch scenes
func update_ui(): 
	#print("[Shop Scene]")	
	#print("upgrades:")
	#print("thrust_upgrade: " + str(game_data["upgrades"]["thrust_upgrade"]))
	#print("fuel_efficiency_upgrade: " + str(game_data["upgrades"]["fuel_efficiency_upgrade"]))
	#print("fuel_capacity_upgrade: " + str(game_data["upgrades"]["fuel_capacity_upgrade"]))
	#print("shield: " + str(game_data["upgrades"]["shield"]))
	$CreditsLabel.text = "CREDITS: " + str(game_data["inventory"]["credits"])
	$ThrustLabel.text = "UPGRADE THRUST (CURRENT LEVEL: " + str(game_data["upgrades"]["thrust_upgrade"]) + ")"
	$FuelEfficiencyLabel.text =  "UPGRADE FUEL EFFICIENCY (CURRENT LEVEL: " + str(game_data["upgrades"]["fuel_efficiency_upgrade"]) + ")"
	$FuelRegenLabel.text =  "UPGRADE FUEL REGEN (CURRENT LEVEL: " + str(game_data["upgrades"]["fuel_regen_upgrade"]) + ")"
	$ShieldLabel.text =  "UPGRADE SHIELD (CURRENT LEVEL: " + str(game_data["upgrades"]["shield"]) + ")"
	$InventoryLabel.text =  "UPGRADE INVENTORY (CURRENT LEVEL: " + str(game_data["upgrades"]["max_inventory"]) + ")"
		
	$ThrustButton.text = "COST: " + str(calc_thrust_cost())
	$FuelEfficiencyButton.text = "COST: " + str(calc_fuel_efficiency_cost())
	$FuelRegenButton.text = "COST: " + str(calc_fuel_regen_cost())
	$ShieldButton.text = "COST: " + str(calc_shield_cost())
	$InventoryButton.text = "COST: " + str(calc_inventory_cost())
	$RefuelButton.text = "REFUEL: " + str(calc_refuel_cost())

func calc_max_fuel(): 
	return 100 #+ (10 * game_data["upgrades"]["fuel_capacity_upgrade"])

func calc_refuel_cost(): 
	var refuel_cost = floor((calc_max_fuel() - game_data["player"]["fuel"]) * FUEL_COST_PER_UNIT)
	if (refuel_cost < 0):
		refuel_cost = 0
	return refuel_cost
	
func calc_thrust_cost():
	return (game_data["upgrades"]["thrust_upgrade"]) * THRUST_COST_PER_LEVEL

func calc_fuel_efficiency_cost():
	return (game_data["upgrades"]["fuel_efficiency_upgrade"]) * EFFICIENCY_COST_PER_LEVEL

func calc_fuel_regen_cost():
	return (game_data["upgrades"]["fuel_regen_upgrade"]) * FUELREGEN_COST_PER_LEVEL

func calc_shield_cost():
	return (game_data["upgrades"]["thrust_upgrade"]) * THRUST_COST_PER_LEVEL

func calc_inventory_cost():
	return (game_data["upgrades"]["max_inventory"]-2) * INVENTORY_COST_PER_LEVEL

func cant_afford():
	print("Can't afford")
	$CantAfford.play()
	ToastParty.show({
		"text": "Sorry, you cannot afford that.",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})

func on_click_buy_thruster():
	
	var cost = calc_thrust_cost()
	if (game_data["inventory"]["credits"] < cost):
		cant_afford()
		return
	print("Player bought more thrust power")
	game_data["upgrades"]["thrust_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost
	update_ui()
	ToastParty.show({
		"text": "Thrust power upgraded!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()

func on_click_buy_fuel_efficiency():
	var cost = calc_fuel_efficiency_cost()
	if (game_data["inventory"]["credits"] < cost):
		cant_afford()
		return
	print("Player bought more fuel efficiency")
	game_data["upgrades"]["fuel_efficiency_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost
	update_ui()
	ToastParty.show({
		"text": "Fuel efficiency upgraded!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()

func on_click_buy_fuel_regen():
	var cost = calc_fuel_regen_cost()
	if (game_data["inventory"]["credits"] < cost):
		cant_afford()
		return
	print("Player bought more fuel regen")
	game_data["upgrades"]["fuel_regen_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost
	update_ui()
	ToastParty.show({
		"text": "Fuel regen upgraded!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()

func on_click_buy_shield():
	var cost = calc_shield_cost()
	if (game_data["inventory"]["credits"] < cost):
		cant_afford()
		return
	print("Player bought shields")
	game_data["upgrades"]["shield"] += 1
	game_data["inventory"]["credits"] -= cost
	update_ui()
	ToastParty.show({
		"text": "Shield upgraded!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()

func on_click_buy_inventory():
	var cost = calc_inventory_cost()
	if (game_data["inventory"]["credits"] < cost):
		cant_afford()
		return
	print("Player bought more inventory space")
	game_data["upgrades"]["max_inventory"] += 1
	game_data["inventory"]["credits"] -= cost
	update_ui()
	ToastParty.show({
		"text": "Inventory expanded!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()

func _on_refuel_button_pressed():
	var refuel_cost = calc_refuel_cost()
	var actual_cost = 0
	var fuel_amount = 0
	
	if (game_data["inventory"]["credits"] < refuel_cost):
		if (game_data["inventory"]["credits"] > 0):
			actual_cost = game_data["inventory"]["credits"]
			fuel_amount = actual_cost/refuel_cost * calc_max_fuel()
		else:
			cant_afford()
			return
	else:
		actual_cost = refuel_cost
		fuel_amount = calc_max_fuel()
		
	#if (game_data["inventory"]["credits"] < cost):
	#	cant_afford()
	#	return
	
	
	print("Player refueled for " + str(actual_cost) + " credits.")
	game_data["player"]["fuel"] = fuel_amount
	game_data["inventory"]["credits"] -= actual_cost
	update_ui()
	ToastParty.show({
		"text": "Refueling complete!",     # Text (emojis can be used)
		"bgcolor": Color(1, 1, 1, .7),     # Background Color
		"color": Color(.25, .25, .25, 1),         # Text Color
		"gravity": "top",                   # top or bottom
		"direction": "right",               # left or center or right
		"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	})
	$Upgrade.play()
