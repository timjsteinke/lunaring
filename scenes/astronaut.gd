extends CharacterBody2D

class_name Astronaut

const PINK_CRYSTAL_VALUE = 500
const BLUE_CRYSTAL_VALUE = 300
const GREEN_CRYSTAL_VALUE = 150

const FULL_MESSAGE = "⚠️ You cannot hold more crystals. Sell at the shop or upgrade inventory."
const LOW_FUEL_MESSAGE = "⚠️ Warning! Fuel low! Refuel at the shop!"
const CRYSTAL_OBTAINED_MESSAGE = " crystal obtained! Sell at the shop!"

var gravity : int = 100
var SPEED = 1.0
var thrust_velocity = -1.0 #3
var fuel_cost = .25 #.25
var fuel_regen = 0
var max_fuel = 100

@export var is_on_platform = false
@export var fuel = 0 # Makes this variable readable to the ui 

signal fuelChanged(current_fuel)

#var fuel_ui
var vertical_speed_ui
var astro_cam
var player_stats_ui

var start_Scene = true
var alive
var dead_reason
var reasons = ["TRY TO AVOID FALLING TOO FAST!", "Didn't you see the space debris?", "FUEL CAN'T REGENERATE ONCE IT REACHES 0"]
var last_vertical_speed
var second_to_last_vertical_speed
var camera_zoom

var parent 

var astronaut_max_inventory
var quantity_pink_crystal_left
var astronaut_quantity_pink_crystal
var quantity_blue_crystal_left
var astronaut_quantity_blue_crystal
var quantity_green_crystal_left
var astronaut_quantity_green_crystal

var sound_jetpack_off_play = false
var sound_landing_play = false

var launching
var fuel_warning = false

var dead_label
var retry_button
var win_label
var launch_button
var start_position
var shop_button

var ring1
var ring2
var ring3

var rings_gathered

var green_crystal_1
var green_crystal_2
var blue_crystal_1
var blue_crystal_2
var pink_crystal_1
var pink_crystal_2

var is_mining
var is_mining_animation
var current_crystal
	

func start(pos):
	position = pos
	alive = true
	is_mining = false
	is_mining_animation = false
	
	rings_gathered = 0
	fuel = parent.game_data["player"]["fuel"]
	fuelChanged.emit(fuel)
	$DeathParticles.emitting = false
	print("Start")
	parent.start_timer()

func _ready():	
	print("astronaut ready")
	parent = get_parent()
	fuel = parent.game_data["player"]["fuel"]	
	fuelChanged.emit(fuel)
	#fuel_ui = get_node("%FuelUI") # Initialize fuel UI text node pointer
	vertical_speed_ui = get_node("%VerticalSpeedUI") # Initialize vertical speed UI text node pointer
	astro_cam = get_node("%AstroCam") # Initialize astrocam pointer
	player_stats_ui = get_node("%PlayerStats") # Initialize vertical speed UI text node pointer
	alive = true
	last_vertical_speed = 0
	second_to_last_vertical_speed = 0
	camera_zoom = 3
	launching = true
	dead_reason = 0
	
	astronaut_quantity_pink_crystal = 0
	astronaut_quantity_blue_crystal = 0
	astronaut_quantity_green_crystal = 0
	quantity_green_crystal_left = 0	
	quantity_pink_crystal_left = 5
	quantity_blue_crystal_left = 5
	quantity_green_crystal_left = 5
	update_stats()
	
	dead_label = get_node("%DeadLabel")
	retry_button = get_node("%RetryButton")
	win_label = get_node("%WinLabel")
	launch_button = get_node("%LaunchButton")
	start_position = get_node("%StartPosition")
	shop_button = get_node("%ShopButton")
	$DeathParticles.emitting = false
	
	ring1 = get_node("%Ring1")
	ring2 = get_node("%Ring2")
	ring3 = get_node("%Ring3")
	
	green_crystal_1 = get_node("%GreenCrystal1")
	green_crystal_2 = get_node("%GreenCrystal2")
	blue_crystal_1 = get_node("%BlueCrystal1")
	blue_crystal_2 = get_node("%BlueCrystal2")
	pink_crystal_1 = get_node("%PinkCrystal1")
	pink_crystal_2 = get_node("%PinkCrystal2")
	
func update_stats():
	gravity = parent.game_data["settings"]["gravity"]	
	astronaut_quantity_pink_crystal = parent.game_data["inventory"]["pink_crystals"]	
	astronaut_quantity_blue_crystal = parent.game_data["inventory"]["blue_crystals"]	
	astronaut_quantity_green_crystal = parent.game_data["inventory"]["green_crystals"]	
	fuel_cost = .25 - (parent.game_data["upgrades"]["fuel_efficiency_upgrade"] * .05)
	fuel_regen = parent.game_data["upgrades"]["fuel_regen_upgrade"] * fuel_cost/5 # + fuel_cost/5 
	#max_fuel = (parent.game_data["upgrades"]["fuel_capacity_upgrade"] * 10) + 100
	thrust_velocity = - 1.85 - ((parent.game_data["upgrades"]["thrust_upgrade"]-1) / 6.0)
	print("UPGRADE: " + str(parent.game_data["upgrades"]["thrust_upgrade"]))
	print("THRUST:" + str(thrust_velocity))
	astronaut_max_inventory = (parent.game_data["upgrades"]["max_inventory"])
	fuel = parent.game_data["player"]["fuel"]
	fuelChanged.emit(fuel)

func useFuel():	
	fuel -= fuel_cost
	parent.game_data["player"]["fuel"] = fuel
	fuelChanged.emit(fuel)
	if (fuel < max_fuel * .25):
		if (fuel_warning == false):
			ToastParty.show({
				"text": LOW_FUEL_MESSAGE,     # Text (emojis can be used)
				"bgcolor": Color(1, 1, 1, .7),     # Background Color
				"color": Color(.25, .25, .25, 1),         # Text Color
				"gravity": "top",                   # top or bottom
				"direction": "right",               # left or center or right
				"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
				"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
			})
			fuel_warning = true

func _process(delta: float) -> void:
	if ($AnimatedSprite2D.get_animation() == "mining"):
		#print($AnimatedSprite2D.get_frame())
		if (($AnimatedSprite2D.get_frame() == 17) && (is_mining)):
			#print("FINISHED MINING")
			is_mining = false
			current_crystal.finished_mining()
			collect_crystal(current_crystal.crystal_color)
			
		if ($AnimatedSprite2D.get_frame() == 28):
			#print("FINISHED ANIMATION")
			is_mining_animation = false
			$AnimatedSprite2D.play("idle")
			
			#current_crystal.finished_mining()
			#print($AnimatedSprite2D.get_frame())
			
	
	

func _physics_process(delta: float) -> void:
	
	
	if (fuel<max_fuel):
		fuel += fuel_regen
		if (fuel>max_fuel):
			fuel = max_fuel
	fuelChanged.emit(fuel)
	
	if (alive):
		second_to_last_vertical_speed = last_vertical_speed
		last_vertical_speed = velocity.y * -1 / 4
		velocity.y += gravity * delta # Add the gravity.
	
	#print ("velocity_y: " + str(velocity.y) + ", last_v_speed: " + str(last_vertical_speed))
		
		var position_y_corrected = position.y + 512
		camera_zoom = (position_y_corrected / 964) * 3
		#print(str(position.y) + "," + str(position_y_corrected) + "," + str(camera_zoom))
		if camera_zoom < 1:
			camera_zoom = 1
		elif camera_zoom > 3:
			camera_zoom = 3
		astro_cam.zoom.x = camera_zoom
		astro_cam.zoom.y = camera_zoom
		
		#print ("current_zoom: " + str(camera_zoom))
	
	if (second_to_last_vertical_speed <= -40 ):
		#vertical_speed_ui.text = "V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH - !!!WARNING!!!"
		vertical_speed_ui.bbcode_text = "[color=#ff0000]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
		
		if not $SoundVelocityAltitudeAlarm.is_playing():
			$SoundVelocityAltitudeAlarm.play()
		
		
		#vertical_speed_ui.pop()
		if (is_on_floor()):
			#print ("Is on Floor")
			alive = false
			$DeathParticles.emitting = true
			died(0)
			fuel = 0
			fuelChanged.emit()
			velocity.y = 0
			$AnimatedSprite2D.play("death")
	elif (second_to_last_vertical_speed <= -20):
		$SoundVelocityAltitudeAlarm.stop()
		vertical_speed_ui.bbcode_text = "[color=#ffff00]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
	else:
		$SoundVelocityAltitudeAlarm.stop()
		vertical_speed_ui.bbcode_text = "[color=#ffffff]V SPEED: " + str("%5.0f" % second_to_last_vertical_speed) + " MPH[/color]"
			
	if (alive):
		# Handle Thrusters
		if Input.is_action_pressed("Jetpack_and_Start"): 
			if fuel > 0:
				#TODO: Perhaps consider lerping the velocity so we get some resistance to momentum before thrusting up
				velocity.y = thrust_velocity + velocity.y
				$AnimatedSprite2D.play("boosting")
				$GPUParticles2D.emitting = true
				#if (not $SoundJetpackLoop.is_playing()) && (not $SoundJetpackOn.is_playing()):
				#	$SoundJetpackOn.play()
				if not $SoundJetpackLoop.is_playing():
					$SoundJetpackLoop.play()
				useFuel()
			if fuel <= 0:
				$GPUParticles2D.emitting = false
				$AnimatedSprite2D.play("idle")
			sound_jetpack_off_play = true
			
		else:
			$GPUParticles2D.emitting = false
			if (is_mining_animation):
				$AnimatedSprite2D.play("mining")
			else:
				$AnimatedSprite2D.play("idle")
				
			$SoundJetpackLoop.stop()
			
			if (sound_jetpack_off_play):
				$SoundJetpackOff.play()
				sound_jetpack_off_play = false
		
		
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		
		#print ("Direction:" + str(direction))
		
		# Flip sprite based on current flip and key presses
		# May be able to clean this up later
		var flip_h = $AnimatedSprite2D.flip_h
		if (direction == 1 && flip_h == false):
			$AnimatedSprite2D.flip_h = false
			$GPUParticles2D.position.x = -6
		elif (direction == 1 && flip_h == true):
			$AnimatedSprite2D.flip_h = false
			$GPUParticles2D.position.x = -6
		elif (direction == -1 && flip_h == false):
			$AnimatedSprite2D.flip_h = true
			$GPUParticles2D.position.x = 6
		elif (direction == -1 && flip_h == true):
			$AnimatedSprite2D.flip_h = true
			$GPUParticles2D.position.x = 6
		
	
		if not is_on_floor():
			sound_landing_play = true
			if direction:
				#print("123")
				velocity.x = direction * SPEED + velocity.x
			#else:
			#	velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			if(launching):
				launching = false
			else:
				velocity.x = 0
				if (sound_landing_play):
					if not $SoundLanding.is_playing():
						$SoundLanding.play()
				#print("FUEL:" + str(fuel))
				if (fuel <= 0):
					died(2)
					#print("Game over, no fuel")
					
		move_and_slide()
		
	
				
	
		

func died(reason):
	#This function handles the player dieing
	
	#ToastParty.show({
		#"text": reasons[dead_reason],     # Text (emojis can be used)
		#"bgcolor": Color(1, 1d, 1, .7),     # Background Color
		#"color": Color(.25, .25, .25, 1),         # Text Color
		#"gravity": "top",                   # top or bottom
		#"direction": "right",               # left or center or right
		#"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
		#"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
	#})
	if not $SoundDeath.is_playing():
		$SoundDeath.play()
	
	print("DIED")
	dead_label.text = "You died. " + reasons[reason]
	dead_label.show()
	retry_button.show()
	parent.stop_timer()

	#dead_label.text = "You died. " + reasons[reason]
	#dead_label.show()
	#retry_button.show()
	
func updateStats():	 
	#This function handles updating the HUD with Player stats
	var LabelText = "[center][color=#989858]INVENTORY CAPACITY: " + str(astronaut_max_inventory) + "\n \
	THRUST POWER: " + str("%1.2f" % thrust_velocity) + "[/color] \n \
	 [color=#ec2dca]PINK CRYSTALS:  " + str(astronaut_quantity_pink_crystal) + " [/color] \n\
	 [color=#01a7c0]BLUE CRYSTALS:  " + str(astronaut_quantity_blue_crystal) + " [/color] \n\
	 [color=#00bf43]GREEN CRYSTALS:  " + str(astronaut_quantity_green_crystal) + " [/color][/center]"
	player_stats_ui.bbcode_text = LabelText
	


func _on_shop_area_body_exited(body):
	if (body.name == "Astronaut"):
		is_on_platform = false
		print("exited")
		shop_button.hide()
	
func _on_shop_area_body_entered(body):
	# When landing on the platform need to sell crystals and open shop
	
	if (body.name == "Astronaut"):
		shop_button.show()
		print("entered")
		if alive:
			is_on_platform = true
			if (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) > 0:
				print("Sold crystals at the Shop. Time to buy")
				var sell_value = ( astronaut_quantity_pink_crystal * PINK_CRYSTAL_VALUE) + ( astronaut_quantity_blue_crystal * BLUE_CRYSTAL_VALUE) + ( astronaut_quantity_green_crystal * GREEN_CRYSTAL_VALUE)
				ToastParty.show({
					"text": "💰 " +  str(sell_value) + " credits earned from selling crystals!",     # Text (emojis can be used)
					"bgcolor": Color(1, 1, 1, .7),     # Background Color
					"color": Color(.25, .25, .25, 1),         # Text Color
					"gravity": "top",                   # top or bottom
					"direction": "right",               # left or center or right
					"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
					"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
				})
				parent.game_data["inventory"]["credits"] += sell_value
				astronaut_quantity_pink_crystal = 0
				astronaut_quantity_blue_crystal = 0
				astronaut_quantity_green_crystal = 0
				parent.game_data["inventory"]["pink_crystals"] = 0
				parent.game_data["inventory"]["green_crystals"] = 0
				parent.game_data["inventory"]["blue_crystals"] = 0
				#fuel = max_fuel  # Let's charge for this instead, amirite
				#fuelChanged.emit(fuel)	
				updateStats()
				fuelChanged.emit(fuel)
			
func retry():
	print("RETRY")
	start(start_position.position)
	$AnimatedSprite2D.play("idle")
	alive = true
	dead_label.hide()
	win_label.hide()
	retry_button.hide()
	velocity.x = 0
	velocity.y = 0
	
	
	astronaut_quantity_pink_crystal = 0
	astronaut_quantity_blue_crystal = 0
	astronaut_quantity_green_crystal = 0
	parent.game_data["inventory"]["pink_crystals"] = 0
	parent.game_data["inventory"]["green_crystals"] = 0
	parent.game_data["inventory"]["blue_crystals"] = 0
	parent.game_data["settings"]["rings_gathered"] = 0
	
	fuel = max_fuel
	fuelChanged.emit(fuel)
	
	updateStats()
	parent.reset_player()

func _on_ring_1_body_entered(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		ring1.player_activate()

func _on_ring_2_body_entered(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		ring2.player_activate()

func _on_ring_3_body_entered(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		ring3.player_activate()


func collect_ring(ring_name):
	if not $SoundRing.is_playing():
		$SoundRing.play()
	parent.game_data["settings"]["rings_gathered"] += 1
	parent.game_data["rings"][ring_name] = false
	print("Rings Gathered:" + str(parent.game_data["settings"]["rings_gathered"]))
	if (parent.game_data["settings"]["rings_gathered"] >= 3):
		parent.stop_timer()
		win_label.show()
		retry_button.show()
		


func _on_launch_area_body_entered(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		launch_button.show()


func _on_launch_area_body_exited(body: Node2D) -> void:
	if (body.name == "Astronaut"):
		launch_button.hide()


func mine_crystal(activated_crystal, crystal_color):
	
	if (astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal) >= astronaut_max_inventory:
		print ("You have no space left to hold additional crystals. Try Selling some back at the shop.")
		ToastParty.show({
			"text": FULL_MESSAGE,     # Text (emojis can be used)
			"bgcolor": Color(1, 1, 1, .7),     # Background Color
			"color": Color(.25, .25, .25, 1),         # Text Color
			"gravity": "top",                   # top or bottom
			"direction": "right",               # left or center or right
			"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
			"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
		})
	else:
		current_crystal = activated_crystal
		is_mining = true
		is_mining_animation = true
		print("Astronaut Entered")
		print("Collected a " + crystal_color + " crystal")
		$AnimatedSprite2D.play("mining")


func collect_crystal(crystal_color):
	print("COLLECT CRYSTAL")
	print("Green Count: " + str(astronaut_quantity_green_crystal))
	print("Total Count: " + str(astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal))
	
	if not $SoundCrystalAcquired.is_playing():
		$SoundCrystalAcquired.play()
		
		match(crystal_color):
			"Green":
				print("GREEN")
				parent.game_data["inventory"]["green_crystals"] += 1
				astronaut_quantity_green_crystal += 1
			"Blue":
				parent.game_data["inventory"]["blue_crystals"] += 1
				astronaut_quantity_blue_crystal += 1
			"Pink":
				parent.game_data["inventory"]["pink_crystals"] += 1
				astronaut_quantity_pink_crystal += 1
		
		print("Total Count: " + str(astronaut_quantity_pink_crystal + astronaut_quantity_blue_crystal + astronaut_quantity_green_crystal))
		
		ToastParty.show({
			"text": crystal_color + " " + CRYSTAL_OBTAINED_MESSAGE,     # Text (emojis can be used)
			"bgcolor": Color(1, 1, 1, .7),     # Background Color
			"color": Color(.25, .25, .25, 1),         # Text Color
			"gravity": "top",                   # top or bottom
			"direction": "right",               # left or center or right
			"text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
			"use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
		})
		updateStats()
