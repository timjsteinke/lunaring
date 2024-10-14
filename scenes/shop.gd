extends Node2D

var game_data: Dictionary

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
	pass
	
# TODO: Finish this
func on_click_buy_thruster():
	print("Player bought more thrust power")
	var cost = (game_data["upgrades"]["thrust_upgrade"]+1) * 300
	if (game_data["inventory"]["credits"] < cost):
		print("Can't afford")
		return
	game_data["upgrades"]["thrust_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost
	
# TODO: Finish this	
func on_click_buy_fuel_efficiency():
	var cost = (game_data["upgrades"]["fuel_efficiency_upgrade"]+1) * 300
	if (game_data["inventory"]["credits"] < cost):
		print("Can't afford")
		return
	print("Player bought more fuel efficiency")
	game_data["upgrades"]["fuel_efficiency_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost
	
	# TODO: Finish this	
func on_click_buy_fuel_capacity():
	var cost = (game_data["upgrades"]["fuel_capacity_upgrade"]+1) * 300
	if (game_data["inventory"]["credits"] < cost):
		print("Can't afford")
		return	
	print("Player bought more fuel capacity")
	game_data["upgrades"]["fuel_capacity_upgrade"] += 1
	game_data["inventory"]["credits"] -= cost

# TODO: Finish this
func on_click_buy_shield():
	var cost = (game_data["upgrades"]["shield"]+1) * 300
	if (game_data["inventory"]["credits"] < cost):
		print("Can't afford")
		return
	print("Player bought shields")
	game_data["upgrades"]["shield"] += 1
	game_data["inventory"]["credits"] -= cost

# TODO: Finish this
func on_click_buy_more_inventory():
	var cost = (game_data["upgrades"]["max_inventory"]+1) * 1000
	if (game_data["inventory"]["credits"] < cost):
		print("Can't afford")
		return
	print("Player bought more inventory space")
	game_data["upgrades"]["max_inventory"] += 1
	game_data["inventory"]["credits"] -= cost
	
