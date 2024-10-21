extends Node

const starting_lives = 3

var time: float = 0.0
var timer_running = false
var game_started = false

# This stores all of the info about our game so we can just pass it around with the scene switcher.  Just add more stuff to it if we need.
@export var game_data = {
	"player" : {
		"lives" : starting_lives,
		"fuel" : 100
	},
	"level": 1,
	"inventory": { 
		"credits": 0,
		"pink_crystals": 0,
		"blue_crystals": 0,
		"green_crystals": 0
	},
	"upgrades": {
		"max_inventory" : 3,
		"thrust_upgrade": 1, #0
		"fuel_efficiency_upgrade": 1,
		"fuel_regen_upgrade": 1,
		"shield": 0
	},
	"settings": { 		
		"difficulty" : 1,
		"starting_lives": starting_lives,
		"gravity": 100,
		"start_Scene": true,
		"timer":0.0,
		"game_started":false,
		"rings_gathered":0
	},
	"crystals": {
		"Crystal1": true,
		"Crystal2": true,
		"Crystal3": true,
		"Crystal4": true,
		"Crystal5": true,
		"Crystal6": true
	},
	"rings": {
		"Ring1": true,
		"Ring2": true,
		"Ring3": true
	}
}

# This is called when we switch scenes. In theory, we could use it to save game state to a file and bring it back.
func set_game_data(new_game_data: Dictionary):
	game_data = new_game_data

# Update the UI when we switch scenes
# Set all the labels to the correct things.
func update_ui(): 
	print("[Main Scene]")	
	print("thrust_upgrade: " + str(game_data["upgrades"]["thrust_upgrade"]))
	print("fuel_efficiency_upgrade: " + str(game_data["upgrades"]["fuel_efficiency_upgrade"]))
	print("fuel_regen_upgrade: " + str(game_data["upgrades"]["fuel_regen_upgrade"]))
	print("shield: " + str(game_data["upgrades"]["shield"]))

# Called when the node enters the scene tree for the first time.
func _ready():
	if(game_data["settings"]["start_Scene"]):
		game_data["settings"]["start_Scene"] = false
	else:
		print("hide start button")
		$StartHUD/StartButton.hide()
	$HUD/RetryButton.hide()
	$HUD/DeadLabel.hide()	
	update_ui()
	$Astronaut.updateStats()
	print("Ready!")
	if (game_data["settings"]["game_started"]):
		start_timer()
		print("Game was started, start the timer")
	
	#
	#if (check_crystal("green_crystal_1")):
		#$GreenCrystal1.show()
	#else:
		#$GreenCrystal1.hide()
	#if (check_crystal("green_crystal_2")):
		#$GreenCrystal2.show()
	#else:
		#$GreenCrystal2.hide()
		#
	#if (check_crystal("blue_crystal_1")):
		#$BlueCrystal1.show()
	#else:
		#$BlueCrystal1.hide()
	#if (check_crystal("blue_crystal_2")):
		#$BlueCrystal2.show()
	#else:
		#$BlueCrystal2.hide()
		#
	#if (check_crystal("pink_crystal_1")):
		#$PinkCrystal1.show()
	#else:
		#$PinkCrystal1.hide()
	#if (check_crystal("pink_crystal_2")):
		#$PinkCrystal2.show()
	#else:
		#$PinkCrystal2.hide()
	
	var crystals = game_data["crystals"]
	for crystal in crystals:
		var crystal_active = crystals[crystal]
		if (!crystal_active):
			var current_crystal = get_node("%" + crystal)
			current_crystal.deactivate()
		#print(str(crystal) + " : " + str(crystal_active))
	
	var rings = 	game_data["rings"]
	for ring in rings:
		var ring_active = rings[ring]
		if (!ring_active):
			var current_ring = get_node("%" + ring)
			current_ring.deactivate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (timer_running):
		#time += delta
		game_data["settings"]["timer"] += delta
	#print(time)
	$HUD/Timer.text = "Mission Timer: " + str("%.2f" % game_data["settings"]["timer"])
	if Input.is_action_pressed("Jetpack_and_Start") && $StartHUD/StartButton.visible:
		_on_start_button_pressed()


func _on_start_button_pressed():
	print("start button pressed")
	$StartHUD/StartButton.hide()
	$Astronaut.start($StartPosition.position)
	print("Start button pressed")
	start_game()

func _on_button_pressed() -> void:
	print("Is on platform:" + str($Astronaut.is_on_platform))
	if $Astronaut.is_on_platform == true:
		SceneSwitcher.switch_scene("shop")
		
func start_timer():
	timer_running = true
	
func stop_timer():
	timer_running = false
	
func reset_player():
	print("Reset Player")
	#game_data.inventory.green_crystals = 0
	#game_data["inventory"]["green_crystals"] = 0
	game_data["settings"]["timer"] = 0.0
	
func start_game():
	game_data["settings"]["game_started"] = true
	print("Firing start game")
	
func collect_crystal(crystal):
	game_data["crystals"][crystal] = false

func check_crystal(crystal):
	return game_data["crystals"][crystal]


func deactivate_crystal(crystal_name):
	game_data["crystals"][crystal_name] = false
