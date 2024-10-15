extends Node

const starting_lives = 3

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
		"max_inventory" : 1,
		"thrust_upgrade": 0,
		"fuel_efficiency_upgrade": 0,
		"fuel_capacity_upgrade": 0,
		"shield": 0
	},
	"settings": { 		
		"difficulty" : 1,
		"starting_lives": starting_lives,
		"gravity": 100,
		"start_Scene": true
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
	print("fuel_capacity_upgrade: " + str(game_data["upgrades"]["fuel_capacity_upgrade"]))
	print("shield: " + str(game_data["upgrades"]["shield"]))

# Called when the node enters the scene tree for the first time.
func _ready():
	if(game_data["settings"]["start_Scene"]):
		game_data["settings"]["start_Scene"] = false
	else:
		print("hide start button")
		$HUD/StartButton.hide()
	$HUD/RetryButton.hide()
	$HUD/DeadLabel.hide()	
	update_ui()
	$Astronaut.updateStats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Jetpack_and_Start") && $StartHUD/StartButton.visible:
		_on_start_button_pressed()


func _on_start_button_pressed():
	$StartHUD/StartButton.hide()
	$Astronaut.start($StartPosition.position)

func _on_button_pressed() -> void:
	if $Astronaut.is_on_platform == true:
		SceneSwitcher.switch_scene("shop")
